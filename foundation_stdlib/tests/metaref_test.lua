local Luna = assert(foundation.com.Luna)
local subject = foundation.com

local case = Luna:new("foundation.com.metaref_*")

local function make_metaref()
  local item_stack = ItemStack()

  return item_stack:get_meta()
end

local TEST_PREFIX = "test_list_"
local MAX_SIZE = 10

case:describe("metaref_int_list_to_table/3", function (t2)
  t2:test("can return a int list (is empty)", function (t3)
    local meta = make_metaref()

    local count, list =
      subject.metaref_int_list_to_table(meta, TEST_PREFIX, MAX_SIZE)

    t3:assert_table_eq(list, {})
    t3:assert_eq(count, 0)
  end)

  t2:test("can return an int list with items", function (t3)
    local meta = make_metaref()

    for i = 1,6 do
      subject.metaref_int_list_push(meta, TEST_PREFIX, MAX_SIZE, i)
    end

    local count, list =
      subject.metaref_int_list_to_table(meta, TEST_PREFIX, MAX_SIZE)

    t3:assert_table_eq(list, {1, 2, 3, 4, 5, 6})
    t3:assert_eq(count, 6)
  end)
end)

case:describe("metaref_int_list_pop/3", function (t2)
  t2:test("returns nil if popping a non-existent item", function (t3)
    local meta = make_metaref()

    local item = subject.metaref_int_list_pop(meta, TEST_PREFIX, MAX_SIZE)

    t3:refute(item)
  end)

  t2:test("correctly pops items in list", function (t3)
    local meta = make_metaref()

    local item = math.random(0xFFFF)

    t3:assert(subject.metaref_int_list_push(meta, TEST_PREFIX, MAX_SIZE, item))

    local item2 = subject.metaref_int_list_pop(meta, TEST_PREFIX, MAX_SIZE)

    t3:assert_eq(item, item2)

    item2 = subject.metaref_int_list_pop(meta, TEST_PREFIX, MAX_SIZE)

    t3:refute(item2)
  end)
end)

case:describe("metaref_int_list_peek/3", function (t2)
  t2:test("returns nil if peeking a non-existent item", function (t3)
    local meta = make_metaref()

    local item = subject.metaref_int_list_peek(meta, TEST_PREFIX, MAX_SIZE)

    t3:refute(item)
  end)

  t2:test("correctly peeks at items in list", function (t3)
    local meta = make_metaref()

    local item = math.random(0xFFFF)

    t3:assert(subject.metaref_int_list_push(meta, TEST_PREFIX, MAX_SIZE, item))

    local item2 = subject.metaref_int_list_peek(meta, TEST_PREFIX, MAX_SIZE)

    t3:assert_eq(item, item2)

    item2 = subject.metaref_int_list_peek(meta, TEST_PREFIX, MAX_SIZE)

    t3:assert_eq(item, item2)
  end)
end)

case:describe("metaref_string_list_to_table/3", function (t2)
  t2:test("can return a string list (is empty)", function (t3)
    local meta = make_metaref()

    local count, list =
      subject.metaref_string_list_to_table(meta, TEST_PREFIX, MAX_SIZE)

    t3:assert_table_eq(list, {})
    t3:assert_eq(count, 0)
  end)

  t2:test("can return an string list with items", function (t3)
    local meta = make_metaref()

    local source = { "a", "b", "c", "d", "e", "f" }
    for _, letter in ipairs(source) do
      subject.metaref_string_list_push(meta, TEST_PREFIX, MAX_SIZE, letter)
    end

    local count, list =
      subject.metaref_string_list_to_table(meta, TEST_PREFIX, MAX_SIZE)

    t3:assert_table_eq(list, source)
    t3:assert_eq(count, 6)
  end)
end)

case:describe("metaref_string_list_pop/3", function (t2)
  t2:test("returns nil if popping a non-existent item", function (t3)
    local meta = make_metaref()

    local item = subject.metaref_string_list_pop(meta, TEST_PREFIX, MAX_SIZE)

    t3:refute(item)
  end)

  t2:test("correctly pops items in list", function (t3)
    local meta = make_metaref()

    local item = "abcdefjhkhdsf"

    t3:assert(subject.metaref_string_list_push(meta, TEST_PREFIX, MAX_SIZE, item))

    local item2 = subject.metaref_string_list_pop(meta, TEST_PREFIX, MAX_SIZE)

    t3:assert_eq(item, item2)

    item2 = subject.metaref_string_list_pop(meta, TEST_PREFIX, MAX_SIZE)

    t3:refute(item2)
  end)
end)

case:describe("metaref_string_list_peek/3", function (t2)
  t2:test("returns nil if peeking a non-existent item", function (t3)
    local meta = make_metaref()

    local item = subject.metaref_string_list_peek(meta, TEST_PREFIX, MAX_SIZE)

    t3:refute(item)
  end)

  t2:test("correctly peeks at items in list", function (t3)
    local meta = make_metaref()

    local item = "abcdefjhkhdsf"

    t3:assert(subject.metaref_string_list_push(meta, TEST_PREFIX, MAX_SIZE, item))

    local item2 = subject.metaref_string_list_peek(meta, TEST_PREFIX, MAX_SIZE)

    t3:assert_eq(item, item2)

    item2 = subject.metaref_string_list_peek(meta, TEST_PREFIX, MAX_SIZE)

    t3:assert_eq(item, item2)
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
