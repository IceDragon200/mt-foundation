local mod = foundation.com.XML
local Luna = assert(foundation.com.Luna)

local case = Luna:new("foundation.com.XML")

case:describe("tokenize/1", function (t2)
  t2:test("can tokenize an empty xml document", function (t3)
    local subject = ""
    local okay, tokens, rest = mod.tokenize(subject)
    t3:assert(okay)
    t3:assert(tokens:isEOB()) -- should be empty
    t3:assert_eq(rest, "")
  end)

  t2:test("can tokenize a simple STag", function (t3)
    local subject = [[<STag>]]
    local okay, tokens, rest = mod.tokenize(subject)
    t3:assert(okay)
    t3:assert_matches(tokens:next_token(), { "stag_open", true })
    t3:assert_matches(tokens:next_token(), { "name", "STag" })
    t3:assert_matches(tokens:next_token(), { "stag_close", true })
    t3:assert_eq(rest, "")
  end)

  t2:test("can tokenize a STag with spaces after name", function (t3)
    local subject = [[<STag    >]]
    local okay, tokens, rest = mod.tokenize(subject)
    t3:assert(okay)
    t3:assert_matches(tokens:next_token(), { "stag_open", true })
    t3:assert_matches(tokens:next_token(), { "name", "STag" })
    t3:assert_matches(tokens:next_token(), { "space", nil })
    t3:assert_matches(tokens:next_token(), { "stag_close", true })
    t3:assert_eq(rest, "")
  end)

  t2:test("can tokenize a STag with attributes", function (t3)
    local subject = [[<STag x="y" attr ="value" attr2= 'other value' attr3 = "'">]]
    local okay, tokens, rest = mod.tokenize(subject)
    t3:assert(okay)
    t3:assert_matches(tokens:next_token(), { "stag_open", true })
    t3:assert_matches(tokens:next_token(), { "name", "STag" })
    t3:assert_matches(tokens:next_token(), { "space", " " })
    --
    t3:assert_matches(tokens:next_token(), { "name", "x" })
    t3:assert_matches(tokens:next_token(), { "eq", true })
    t3:assert_matches(tokens:next_token(), { "attr_value", "y" })
    t3:assert_matches(tokens:next_token(), { "space", " " })
    --
    t3:assert_matches(tokens:next_token(), { "name", "attr" })
    t3:assert_matches(tokens:next_token(), { "space", " " })
    t3:assert_matches(tokens:next_token(), { "eq", true })
    t3:assert_matches(tokens:next_token(), { "attr_value", "value" })
    t3:assert_matches(tokens:next_token(), { "space", " " })
    --
    t3:assert_matches(tokens:next_token(), { "name", "attr2" })
    t3:assert_matches(tokens:next_token(), { "eq", true })
    t3:assert_matches(tokens:next_token(), { "space", " " })
    t3:assert_matches(tokens:next_token(), { "attr_value", "other value" })
    t3:assert_matches(tokens:next_token(), { "space", " " })
    --
    t3:assert_matches(tokens:next_token(), { "name", "attr3" })
    t3:assert_matches(tokens:next_token(), { "space", " " })
    t3:assert_matches(tokens:next_token(), { "eq", true })
    t3:assert_matches(tokens:next_token(), { "space", " " })
    t3:assert_matches(tokens:next_token(), { "attr_value", "'" })
    --
    t3:assert_matches(tokens:next_token(), { "stag_close", true })
    t3:assert_eq(rest, "")
  end)
  --

  t2:test("cannot tokenize an invalid STag", function (t3)
    local subject = [[< STag>]]
    local okay, tokens, rest = mod.tokenize(subject)
    t3:refute(okay)
  end)

  --
  t2:test("can tokenize a valid ETag", function (t3)
    local subject = [[</ETag>]]
    local okay, tokens, rest = mod.tokenize(subject)
    t3:assert(okay)
    t3:assert_eq(rest, "")
    t3:assert_matches(tokens:next_token(), { "etag_open", true })
    t3:assert_matches(tokens:next_token(), { "name", "ETag" })
    t3:assert_matches(tokens:next_token(), { "etag_close", true })
    t3:assert(tokens:isEOB())
  end)

  t2:test("can tokenize a valid ETag with tailing spaces", function (t3)
    local subject = [[</ETag  >]]
    local okay, tokens, rest = mod.tokenize(subject)
    t3:assert(okay)
    t3:assert_eq(rest, "")
    t3:assert_matches(tokens:next_token(), { "etag_open", true })
    t3:assert_matches(tokens:next_token(), { "name", "ETag" })
    t3:assert_matches(tokens:next_token(), { "space", "  " })
    t3:assert_matches(tokens:next_token(), { "etag_close", true })
    t3:assert(tokens:isEOB())
  end)

  --
  t2:test("can tokenize chardata", function (t3)
    local subject = [[Some data that isn't in an element]]
    local okay, tokens, rest = mod.tokenize(subject)
    t3:assert(okay)
    t3:assert_eq(rest, "")
    t3:assert_matches(tokens:next_token(), { "chardata", "Some data that isn't in an element" })
    t3:assert(tokens:isEOB())
  end)
end)

case:describe("decode/1", function (t2)
  t2:test("can decode an xml payload", function (t3)
    local subject = [[
    <!-- A comment of sorts -->
    <body>
      <!-- A comment within the sub element -->
      <A>Data</A>
      <B>X</B>
    </body>
    ]]

    local okay, elm, err = mod.decode(subject)
    t3:assert(okay)
    t3:assert_eq(elm.name, "")
    t3:assert_eq(elm.children:size(), 1)
    t3:assert_matches(elm.children:first(), {
      name = "body",
    })

    local a = elm:find_element_by_name("A")
    t3:assert_eq(a.children:size(), 1)
    t3:assert_eq(a.children:first(), "Data")
    local b = elm:find_element_by_name("B")
    t3:assert_eq(b.children:size(), 1)
    t3:assert_eq(b.children:first(), "X")
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
