local subject = foundation.com.KDL

local case = foundation.com.Luna:new("foundation.com.KDL.Lexer")

local SPACE = {"space", true}
local NL = {"nl", true}

local function assert_tokens_eq(ctx, a, b)
  ctx:assert(a, "expected a token list (a)")
  ctx:assert(b, "expected a token list (b)")

  ctx:assert_eq(#a, #b)

  for i,token in ipairs(b) do
    ctx:assert_table_eq(a[i], token)
  end
end

case:describe("tokenize/1", function (t2)
  t2:test("can tokenize an empty raw string", function (t3)
    local ok, tokens, err =
      subject.tokenize('r""')

    t3:assert(ok, err)

    local expected = {
      {"raw_string", ""},
    }

    assert_tokens_eq(t3, expected, tokens:to_list())
  end)

  t2:test("can tokenize a raw string", function (t3)
    local ok, tokens, err =
      subject.tokenize('r"a raw string, yep \\n"')

    t3:assert(ok, err)

    local expected = {
      {"raw_string", "a raw string, yep \\n"},
    }

    assert_tokens_eq(t3, expected, tokens:to_list())
  end)

  t2:test("can tokenize a raw string with #", function (t3)
    local ok, tokens, err =
      subject.tokenize('r#"a raw string, yep \\n"#')

    t3:assert(ok, err)

    local expected = {
      {"raw_string", "a raw string, yep \\n"},
    }

    assert_tokens_eq(t3, expected, tokens:to_list())
  end)

  t2:test("can tokenize an empty double quoted string", function (t3)
    local ok, tokens, err =
      subject.tokenize('""')

    t3:assert(ok, err)

    local expected = {
      {"dquote_string", ""}
    }

    assert_tokens_eq(t3, expected, tokens:to_list())
  end)

  t2:test("can tokenize a double quoted string", function (t3)
    local ok, tokens, err =
      subject.tokenize('"Hello, World"')

    t3:assert(ok, err)

    local expected = {
      {"dquote_string", "Hello, World"}
    }

    assert_tokens_eq(t3, expected, tokens:to_list())
  end)

  t2:test("can tokenize a simple ascii term", function (t3)
    local ok, tokens, err =
      subject.tokenize('this_is_a_simple_term')

    t3:assert(ok, err)

    local expected = {
      {"term", "this_is_a_simple_term"}
    }

    assert_tokens_eq(t3, expected, tokens:to_list())
  end)

  t2:test("can tokenize a utf-8 term (hiragana)", function (t3)
    local ok, tokens, err =
      subject.tokenize('さよなら')

    t3:assert(ok, err)

    local expected = {
      {"term", "さよなら"}
    }

    assert_tokens_eq(t3, expected, tokens:to_list())
  end)

  t2:test("can tokenize a kdl document", function (t3)
    local ok, tokens, err =
      subject.tokenize([[
        // single line comment
        node key=r"value" int=1 {
          /*
            Multiline comment
          */
          node2 { /* Inline Multiline Comment */
            node3 "string" // inline comment
          }
        }
      ]])

    t3:assert(ok, err)

    local expected = {
      SPACE, {"comment_c", " single line comment"}, NL,
      SPACE, {"term", "node"}, SPACE,
        {"term", "key"}, {"=", true}, {"raw_string", "value"}, SPACE,
        {"term", "int"}, {"=", true}, {"term", "1"}, SPACE,
        {"open_block", true}, NL,
      SPACE, {"comment_multiline_c",
        "\n            Multiline comment\n          "
      }, NL,
      SPACE, {"term", "node2"}, SPACE,
        {"open_block", true}, SPACE,
        {"comment_multiline_c", " Inline Multiline Comment "}, NL,
      SPACE, {"term", "node3"}, SPACE,
        {"dquote_string", "string"}, SPACE,
        {"comment_c", " inline comment"}, NL,
      SPACE, {"close_block", true}, NL,
      SPACE, {"close_block", true}, NL,
      SPACE,
    }

    assert_tokens_eq(t3, expected, tokens:to_list())
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
