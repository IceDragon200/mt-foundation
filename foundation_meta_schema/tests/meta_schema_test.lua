local MetaSchema = assert(foundation.com.MetaSchema)
local Luna = assert(foundation.com.Luna)

local case = Luna:new("foundation.com.MetaSchema")

case:describe("&new/3", function (t2)
  t2:test("accepts a schema of scalar types", function (t3)
    local meta_schema = MetaSchema:new("test.schema", "", {
      x = { type = "integer" },
      name = { type = "string" },
      delta = { type = "float" },
    })

    t3:assert(meta_schema)
    t3:assert_eq(meta_schema.name, "test.schema")
    t3:assert_eq(meta_schema.prefix, "")
  end)
end)

case:describe("#compile/1", function (t2)
  t2:setup_all(function (tags)
    tags.meta_schema = MetaSchema:new("test.schema", "", {
      x = { type = "integer" },
      name = { type = "string" },
      delta = { type = "float" },
    })
    return tags
  end)

  t2:test("compiles a MetaSchema into a fixed schema", function (t3, tags)
    local schema = tags.meta_schema:compile("base")

    t3:assert(schema.set_x)
    t3:assert(schema.get_x)
    t3:assert(schema.set_name)
    t3:assert(schema.get_name)
    t3:assert(schema.set_delta)
    t3:assert(schema.get_delta)

    t3:assert(schema.__keys.x)
    t3:assert(schema.__keys.name)
    t3:assert(schema.__keys.delta)
  end)

  t2:test("compiled MetaSchema functions work as intended", function (t3, tags)
    local meta = foundation.com.headless.MetaDataRef:new()

    local data = meta:to_table()

    t3:assert_deep_eq({
      fields = {},
      inventory = {},
    }, data)

    local schema = tags.meta_schema:compile("base")

    schema:set_x(meta, 12)
    schema:set_name(meta, "John Doe")
    schema:set_delta(meta, 33.2)

    data = schema:get(meta)

    t3:assert_deep_eq({
      x = 12,
      name = "John Doe",
      delta = 33.2,
    }, data)

    data = meta:to_table()

    t3:assert_deep_eq({
      fields = {
        base_x = 12,
        base_name = "John Doe",
        base_delta = 33.2,
      },
      inventory = {},
    }, data)

    t3:assert_eq(schema:get_x(meta), 12)
    t3:assert_eq(schema:get_name(meta), "John Doe")
    t3:assert_eq(schema:get_delta(meta), 33.2)

    schema:set(meta, {
      x = 24,
      name = "Sally Sue",
      delta = 144.22
    })

    data = meta:to_table()

    t3:assert_deep_eq({
      fields = {
        base_x = 24,
        base_name = "Sally Sue",
        base_delta = 144.22,
      },
      inventory = {}
    }, data)
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
