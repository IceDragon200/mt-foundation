local subject = foundation.com.KDL

local case = foundation.com.Luna:new("foundation.com.KDL.Decoder")

case:describe("decode/1", function (t2)
  t2:test("can decode a simple kdl document", function (t3)
    local doc = [[
    node {
      // shouldn't appear in the decoded document
      node2 "Hello, World"
    }
    ]]

    local ok, nodes, err = subject.decode(doc)

    t3:assert(ok, err)

    t3:assert_deep_eq({
      name = "node",
      attributes = {},
      annotations = {},
      children = {
        {
          name = "node2",
          attributes = {
            {
              type = 'string',
              annotations = {},
              value = 'Hello, World',
              format = 'plain',
            },
          },
          annotations = {},
          children = nil,
        }
      },
    }, nodes[1]:to_table())
  end)

  t2:test("can decode deeply nested nodes", function (t3)
    local doc = [[
    node {
      node2 {
        node3 {
          node4
        }
      }
    }
    ]]

    local ok, nodes, err = subject.decode(doc)

    t3:assert(ok, err)

    t3:assert_deep_eq({
      name = "node",
      attributes = {},
      annotations = {},
      children = {
        {
          name = "node2",
          attributes = {},
          annotations = {},
          children = {
            {
              name = "node3",
              attributes = {},
              annotations = {},
              children = {
                {
                  name = "node4",
                  attributes = {},
                  annotations = {},
                  children = nil,
                }
              },
            }
          },
        }
      },
    }, nodes[1]:to_table())
  end)

  t2:test("can decode every number type", function (t3)
    local doc = [[
    integer 12
    float 12.364
    decimal 12.34e8
    bin 0b10_00
    oct 0o7_432
    hex 0xDE_AD_BEEF
    ]]

    local ok, nodes, err = subject.decode(doc)

    local doc = {}
    for i, node in ipairs(nodes) do
      doc[i] = node:to_table()
    end

    t3:assert(ok, err)

    t3:assert_deep_eq({
      {
        name = "integer",
        attributes = {
          {
            type = "integer",
            annotations = {},
            value = 12,
            format = 'plain',
          },
        },
        annotations = {},
        children = nil,
      },
      {
        name = "float",
        attributes = {
          {
            type = "float",
            annotations = {},
            value = 12.364,
            format = 'plain',
          },
        },
        annotations = {},
        children = nil,
      },
      {
        name = "decimal",
        attributes = {
          {
            type = "float",
            annotations = {},
            value = 12.34e8,
            format = 'plain',
          },
        },
        annotations = {},
        children = nil,
      },
      {
        name = "bin",
        attributes = {
          {
            type = "integer",
            annotations = {},
            value = 8,
            format = 'binary',
          },
        },
        annotations = {},
        children = nil,
      },
      {
        name = "oct",
        attributes = {
          {
            type = "integer",
            annotations = {},
            value = 3866,
            format = 'octal',
          },
        },
        annotations = {},
        children = nil,
      },
      {
        name = "hex",
        attributes = {
          {
            type = "integer",
            annotations = {},
            value = 0xDEADBEEF,
            format = 'hex',
          },
        },
        annotations = {},
        children = nil,
      },
    }, doc)
  end)

  t2:test("can decode node with properties", function (t3)
    local doc = [[
    node prop1=1 prop2="hello" prop3=r"world" prop4=true prop5=false prop6=null
    ]]

    local ok, nodes, err = subject.decode(doc)

    t3:assert(ok, err)

    t3:assert_deep_eq({
      name = "node",
      attributes = {
        {
          key = {
            type = "id",
            value = "prop1",
            annotations = {},
            format = "plain",
          },
          value = {
            type = "integer",
            value = 1,
            annotations = {},
            format = "plain",
          },
        },
        {
          key = {
            type = "id",
            value = "prop2",
            annotations = {},
            format = "plain",
          },
          value = {
            type = "string",
            value = "hello",
            annotations = {},
            format = "plain",
          },
        },
        {
          key = {
            type = "id",
            value = "prop3",
            annotations = {},
            format = "plain",
          },
          value = {
            type = "string",
            value = "world",
            annotations = {},
            format = "raw",
          },
        },
        {
          key = {
            type = "id",
            value = "prop4",
            annotations = {},
            format = "plain",
          },
          value = {
            type = "boolean",
            value = true,
            annotations = {},
            format = "plain",
          },
        },
        {
          key = {
            type = "id",
            value = "prop5",
            annotations = {},
            format = "plain",
          },
          value = {
            type = "boolean",
            value = false,
            annotations = {},
            format = "plain",
          },
        },
        {
          key = {
            type = "id",
            value = "prop6",
            annotations = {},
            format = "plain",
          },
          value = {
            type = "null",
            value = nil,
            annotations = {},
            format = "plain",
          },
        },
      },
      annotations = {},
      children = nil
    }, nodes[1]:to_table())
  end)

  t2:test("can annotate things", function (t3)
    local doc = [[
    (Person)someone name = "John Doe" {
      address (tag)id=2 desc=(note)"something" {
        name "John Doe"
        tel (nanp)"12003004000"
      }
    }
    ]]

    local ok, nodes, err = subject.decode(doc)

    t3:assert(ok, err)

    t3:assert_deep_eq({
      annotations = {
        "Person",
      },
      name = "someone",
      attributes = {
        {
          key = {
            value = "name",
            type = "id",
            annotations = {},
            format = "plain",
          },
          value = {
            type = "string",
            value = "John Doe",
            annotations = {},
            format = "plain",
          },
        },
      },
      children = {
        {
          annotations = {},
          name = "address",
          attributes = {
            {
              key = {
                type = "id",
                value = "id",
                annotations = {
                  "tag",
                },
                format = "plain",
              },
              value = {
                type = "integer",
                value = 2,
                annotations = {
                },
                format = "plain",
              }
            },
            {
              key = {
                type = "id",
                value = "desc",
                annotations = {},
                format = "plain",
              },
              value = {
                type = "string",
                value = "something",
                annotations = {
                  "note"
                },
                format = "plain",
              }
            }
          },
          children = {
            {
              annotations = {},
              name = "name",
              attributes = {
                {
                  annotations = {},
                  type = "string",
                  value = "John Doe",
                  format = "plain",
                }
              }
            },
            {
              annotations = {},
              name = "tel",
              attributes = {
                {
                  annotations = {
                    "nanp",
                  },
                  type = "string",
                  value = "12003004000",
                  format = "plain",
                }
              }
            },
          }
        }
      }
    }, nodes[1]:to_table())
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
