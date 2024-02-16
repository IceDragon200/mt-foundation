max_line_length = 100

-- unused args do not matter
unused_args = false

globals = {
  -- globals
  dump = {},
  -- namespaces
  foundation = {
    fields = {
      modpath = {},
      self_test = {},
      new_module = {},
      new_private_module = {},
      com = {
        fields = {
          -- Modules
          bit = {
            fields = {
              tohex = {},
              arshift = {},
              band = {},
              bnot = {},
              bswap = {},
              bor = {},
              bxor = {},
              lshift = {},
              rol = {},
              ror = {},
              rshift = {},
            },
          },
          local_bit = {
            fields = {
              tohex = {},
              arshift = {},
              band = {},
              bnot = {},
              bswap = {},
              bor = {},
              bxor = {},
              lshift = {},
              rol = {},
              ror = {},
              rshift = {},
            },
          },
          native_bit = {
            fields = {
              tohex = {},
              arshift = {},
              band = {},
              bnot = {},
              bswap = {},
              bor = {},
              bxor = {},
              lshift = {},
              rol = {},
              ror = {},
              rshift = {},
            },
          },
          utf8 = {
            fields = {
              next_codepoint = {},
              next_codepoint_pos = {},
            },
          },
          ByteBuf = {
            fields = {
              little = {},
              big = {},
            },
          },
          Color = {},
          Cuboid = {},
          Directions = {},
          Easers = {
            fields = {
              ["*"] = {},
            },
          },
          Groups = {
            fields = {
              has_group = {},
            },
          },
          InventoryList = {},
          InventorySerializer = {},
          InventoryPacker = {},
          Rect = {
            fields = {
              new = {},
              copy = {},
            },
          },
          SoundsRegistry = {},
          Symbols = {},
          TOML = {},
          KDL = {},
          Tweener = {},
          ULID = {},
          Vector2 = {
            fields = {
              -- functions
              new = {},
              copy = {},
              to_string = {},
              add = {},
              subtract = {},
              multiply = {},
              divide = {},
              idivide = {},
            },
          },
          Vector3 = {
            fields = {
              -- functions
              new = {},
              copy = {},
              to_string = {},
              add = {},
              subtract = {},
              multiply = {},
              divide = {},
              idivide = {},
            },
          },
          Vector4 = {
            fields = {
              -- functions
              new = {},
              copy = {},
              to_string = {},
              add = {},
              subtract = {},
              multiply = {},
              divide = {},
              idivide = {},
            },
          },
          Version = {
            fields = {
              test = {},
            },
          },
          Waves = {},
          WeightedList = {
            fields = {
              -- class properties
              instance_class = {},
              -- class functions
              new = {},
            },
          },
          native_utils = {},
          node_sounds = {},
          ffi = {
            fields = {
              load = {},
              cdef = {},
              new = {},
              copy = {},
              string = {},
            },
          },
          schematic_helpers = {
            fields = {
              from_y_slices = {},
              build = {},
              Builder = {
                fields = {
                  new = {},
                },
              },
            },
          },
          formspec = {
            fields = {
              Form = {},
              Layout = {},
              api = {},
            },
          },
          sounds = {},
          --
          -- Classes
          --
          Luna = {
            fields = {
              instance_class = {},
              -- class methods
              new = {},
            },
          },
          List = {
            fields = {
              instance_class = {
                fields = {
                  to_list = {},
                  to_linked_list = {},
                },
              },
              -- class methods
              new = {},
              list_next = {},
            },
          },
          LinkedList = {
            fields = {
              instance_class = {},
              -- class methods
              new = {},
            },
          },
          TokenBuffer = {},
          RingBuffer = {
            fields = {},
          },
          MetaSchema = {},
          headless = {
            MetaRef = {},
            ItemStack = {},
          },
          Trace = {},
          Class = {
            fields = {
              -- class methods
              extends = {},
              is_object = {},
            },
          },
          ProcessRunner = {
          },
          NodeSoundsRegistry = {
            fields = {
              new = {},
            },
          },
          -- Functions
          --- ascii_pack
          ascii_pack = {},
          ascii_unpack = {},
          ascii_file_pack = {},
          ascii_file_unpack = {},
          apak = {
            fields = {
              pack = {},
              pack_array = {},
              pack_int = {},
              pack_nil = {},
            },
          },
          --- binary_types
          BinSchema = {},
          BinaryBuffer = {},
          StringBuffer = {},
          FileBuffer = {},
          ByteDecoder = {},
          ByteEncoder = {
            fields = {
              LE = {},
              BE = {},
            },
          },
          binary_types = {
            fields = {
              Array = {
                fields = {
                  new = {},
                },
              },
              BitFlags = {},
              Bytes = {},
              Enum = {},
              Map = {
                fields = {
                  new = {},
                },
              },
              Scalars = {
                fields = {
                  ["?"] = {},
                },
              },
              MarshallValue = {},
              NaiveDateTime = {},
            },
          },
          ---
          ALL_PREFIXES = {},
          COMMON_PREFIXES = {},
          --- encoding_tables
          HEX_TABLE = {},
          HEX_TO_DEC = {
            fields = {
              ["0"] = {},
              ["1"] = {},
              ["2"] = {},
              ["3"] = {},
              ["4"] = {},
              ["5"] = {},
              ["6"] = {},
              ["7"] = {},
              ["8"] = {},
              ["9"] = {},
              A = {},
              B = {},
              C = {},
              D = {},
              E = {},
              F = {},
              a = {},
              b = {},
              c = {},
              d = {},
              e = {},
              f = {},
              ["?"] = {},
            },
          },
          HEX_BYTE_TO_DEC = {
            fields = {
              ["?"] = {},
            },
          },
          HEX_UPPERCASE_ENCODE_TABLE = {},
          --HEX_LOWERCASE_ENCODE_TABLE = {},
          CROCKFORD_BASE32_ENCODE_TABLE = {},
          CROCKFORD_BASE32_DECODE_TABLE = {},
          --- inventory_list
          --
          --- iodata
          iodata_to_string = {},
          --- item_stack
          itemstack_copy = {},
          itemstack_deep_equals = {},
          itemstack_get_itemdef = {},
          itemstack_has_group = {},
          itemstack_inspect = {},
          itemstack_is_blank = {},
          itemstack_maybe_merge = {},
          itemstack_new_blank = {},
          itemstack_split = {},
          get_itemstack_item_description = {},
          get_itemstack_description = {},
          set_itemstack_meta_description = {},
          append_itemstack_meta_description = {},
          --- list
          list_concat = {},
          list_crawford_base32_le_rolling_encode_table = {},
          list_get_next = {},
          list_last = {},
          list_map = {},
          list_reduce = {},
          list_reverse = {},
          list_sample = {},
          list_slice = {},
          list_uniq = {},
          list_split = {},
          list_sort = {},
          --- meta_ref
          metaref_merge_fields_from_table = {},
          metaref_dec_float = {},
          metaref_dec_int = {},
          metaref_inc_float = {},
          metaref_inc_int = {},
          metaref_int_list_to_table = {},
          metaref_int_list_index_of = {},
          metaref_int_list_pop = {},
          metaref_int_list_peek = {},
          metaref_int_list_push = {},
          metaref_int_list_clear = {},
          metaref_int_list_lazy_clear = {},
          metaref_string_list_to_table = {},
          metaref_string_list_index_of = {},
          metaref_string_list_pop = {},
          metaref_string_list_peek = {},
          metaref_string_list_push = {},
          metaref_string_list_clear = {},
          metaref_string_list_lazy_clear = {},
          --- node_timer
          maybe_start_node_timer = {},
          --- number
          integer_be_encode = {},
          integer_le_encode = {},
          integer_hex_be_encode = {},
          integer_base16_be_encode = {},
          integer_base16_le_encode = {},
          integer_crockford_base32_be_encode = {},
          integer_crockford_base32_le_encode = {},
          number_round = {},
          number_lerp = {},
          number_moveto = {},
          number_interpolate = {},
          --- string
          binary_splice = {},
          byte_to_hexpair = {},
          lua_string_hex_decode = {},
          lua_string_hex_encode = {},
          lua_string_hex_escape = {},
          lua_string_hex_unescape = {},
          ffi_encoder = {},
          ffi_string_hex_decode = {},
          ffi_string_hex_encode = {},
          ffi_string_hex_escape = {},
          ffi_string_hex_unescape = {},
          handle_escaped_hex = {},
          handle_escaped_dec = {},
          make_string_ref = {},
          nibble_to_hex = {},
          string_bin_encode = {},
          string_bin_decode = {},
          string_dec_encode = {},
          string_dec_decode = {},
          string_empty = {},
          string_ends_with = {},
          string_unescape = {},
          string_hex_clean = {},
          string_hex_decode = {},
          string_hex_encode = {},
          string_hex_escape = {},
          string_hex_pair_to_byte = {},
          string_hex_nibble_to_byte = {},
          string_hex_unescape = {},
          string_pad_leading = {},
          string_pad_trailing = {},
          string_remove_spaces = {},
          string_rsub = {},
          string_split = {},
          string_starts_with = {},
          string_sub_join = {},
          string_to_list = {},
          string_trim_leading = {},
          string_trim_trailing = {},
          --- table
          is_table_empty = {},
          table_bury = {},
          table_concat = {},
          table_copy = {},
          table_cpush = {},
          table_deep_copy = {},
          table_deep_merge = {},
          table_drop = {},
          table_equals = {},
          table_flatten = {},
          table_freeze = {},
          table_includes_value = {},
          table_intersperse = {},
          table_key_of = {},
          table_keys = {},
          table_length = {},
          table_merge = {},
          table_put = {},
          table_reduce = {},
          table_take = {},
          table_values = {},
          table_sample = {},
          --- time
          time_network_frames = {},
          time_network_seconds = {},
          time_network_minutes = {},
          time_network_hours = {},
          time_network_hms = {},
          --- path
          path_join = {},
          path_basename = {},
          path_components = {},
          path_dirname = {},
          --- pretty_units
          format_pretty_unit = {},
          format_pretty_time = {},
          --- random
          random_string = {},
          random_string16 = {},
          random_string32 = {},
          random_string36 = {},
          random_string62 = {},
          --- value
          is_blank = {},
          first_present = {},
          deep_equals = {},
          --- vector
          vector_to_string = {},
          --
          recover_hp = {},
          get_inventory_drops = {},
        },
      },
      is_module_present = {},
    },
  },
  minetest = {
    fields = {
      -- properties
      registered_items = {
        fields = {
          ["?"] = {},
        },
      },
      registered_nodes = {
        fields = {
          ["?"] = {},
        },
      },
      -- functions
      request_insecure_environment = {},
      formspec_escape = {},
      get_current_modname = {},
      get_modpath = {},
      get_item_group = {},
      get_meta = {},
      get_node = {},
      get_node_timer = {},
      get_position_from_hash = {},
      get_translator = {},
      get_us_time = {},
      get_worldpath = {},
      hash_node_position = {},
      log = {},
      mkdir = {},
      register_craftitem = {},
      register_node = {},
      register_tool = {},
      swap_node = {},
      sound_play = {},
    },
  },
  vector = {
    fields = {
      new = {},
      add = {},
      subtract = {},
    },
  },
  -- classes
  ItemStack = {
  },
  SecureRandom = {
  },
  table = {
    fields = {
      copy = {},
    },
  },
  string = {
    fields = {
      split = {},
    },
  },
}

files["foundation_ascii_pack/**/*.lua"] = { globals = {"foundation_ascii_pack"} }
files["foundation_binary/**/*.lua"] = { globals = {"foundation_binary"} }
files["foundation_class/**/*.lua"] = { globals = {"foundation_class"} }
files["foundation_inv/**/*.lua"] = { globals = {"foundation_inv"} }
files["foundation_kdl/**/*.lua"] = { globals = {"foundation_kdl"} }
files["foundation_native/**/*.lua"] = {
  globals = {
    "foundation_native",
  }
}
files["foundation_stdlib/**/*.lua"] = { globals = {"foundation_stdlib"} }
files["foundation_struct/**/*.lua"] = { globals = {"foundation_struct"} }
files["foundation_random/**/*.lua"] = { globals = {"foundation_random"} }
