--
-- Foundation B3D
--
local floor = assert(math.floor)
--- @namespace foundation_b3d
local mod = foundation.new_module("foundation_b3d", "0.0.1")

--- @class Error
mod.Error = foundation.com.Class:extends("foundation_b3d.Error")
do
  local ic = mod.Error.instance_class

  --- @spec #initialize(code: String, message: String): void
  function ic:initialize(code, message)
    ic._super.initialize(self)
    self.code = code
    self.message = message
  end
end

local StringBuffer = assert(foundation.com.StringBuffer)

--- @namespace foundation_b3d

--- @spec load_string_buffer_chunk(
---   buf: StringBuffer,
---   remaining_len: Integer
--- ): (Chunk, remaining_len: Integer, nil) | (nil, remaining_length: Integer, Error)
function mod.load_string_buffer_chunk(buf, remaining_len)
  local br
  if remaining_len > 0 then
    local chunk_tag
    local chunk_size
    chunk_tag, br = buf:read(4)
    remaining_len = remaining_len - br
    chunk_size, br = buf:read_le_u32()
    remaining_len = remaining_len - br

    if chunk_size > remaining_len then
      return nil, remaining_len, Error:new("not_enough_data", "Chunk size exceeds length of remaining data")
    end

    if chunk_tag == "BRUS" then
      local i = 0
      local result = {_type = "TEXS", children = {}}
      local remaining_chunk = chunk_size
      local n_texs
      n_texs, br = buf:read_le_i32()
      remaining_len = remaining_len - br
      remaining_chunk = remaining_chunk - br
      local name
      local r
      local g
      local b
      local a
      local shininess
      local blend
      local fx
      local texture_ids = {}

      while remaining_chunk > 0 do
        texture_ids = {}

        name, br = buf:scan_upto("\0")
        remaining_chunk = remaining_chunk - br
        buf:walk(1)
        remaining_chunk = remaining_chunk - 1

        r, br = buf:read_le_f32()
        remaining_chunk = remaining_chunk - br

        g, br = buf:read_le_f32()
        remaining_chunk = remaining_chunk - br

        b, br = buf:read_le_f32()
        remaining_chunk = remaining_chunk - br

        a, br = buf:read_le_f32()
        remaining_chunk = remaining_chunk - br

        shininess, br = buf:read_le_f32()
        remaining_chunk = remaining_chunk - br

        blend, br = buf:read_le_i32()
        remaining_chunk = remaining_chunk - br

        fx, br = buf:read_le_i32()
        remaining_chunk = remaining_chunk - br

        if n_texs > 0 then
          for n = 1,n_texs do
            texture_ids[n], br = buf:read_le_i32()
            remaining_chunk = remaining_chunk - br
          end
        end

        result.children[i] = {
          name = name,
          r = r,
          g = g,
          b = b,
          a = a,
          shininess = shininess,
          blend = blend,
          fx = fx,
          texture_ids = texture_ids,
        }
      end
      remaining_len = remaining_len - chunk_size
      return result, remaining_len, nil
    elseif chunk_tag == "TEXS" then
      local i = 0
      local result = {_type = "TEXS", children = {}}
      local remaining_chunk = chunk_size
      local name
      local flags
      local blend
      local x_pos
      local y_pos
      local x_scale
      local y_scale
      local rotation

      while remaining_chunk > 0 do
        name, br = buf:scan_upto("\0")
        remaining_chunk = remaining_chunk - br
        buf:walk(1)
        remaining_chunk = remaining_chunk - 1

        flags, br = buf:read_le_i32()
        remaining_chunk = remaining_chunk - br
        blend, br = buf:read_le_i32()
        remaining_chunk = remaining_chunk - br
        x_pos, br = buf:read_le_f32()
        remaining_chunk = remaining_chunk - br
        y_pos, br = buf:read_le_f32()
        remaining_chunk = remaining_chunk - br
        x_scale, br = buf:read_le_f32()
        remaining_chunk = remaining_chunk - br
        y_scale, br = buf:read_le_f32()
        remaining_chunk = remaining_chunk - br
        rotation, br = buf:read_le_f32()
        remaining_chunk = remaining_chunk - br

        i = i + 1
        result.children[i] = {
          name = name,
          flags = flags,
          blend = blend,
          x_pos = x_pos,
          y_pos = y_pos,
          x_scale = x_scale,
          y_scale = y_scale,
          rotation = rotation
        }
      end
      remaining_len = remaining_len - chunk_size
      return result, remaining_len, nil
    elseif chunk_tag == "VRTS" then
      local flags
      local tex_coord_sets
      local tex_coord_set_size

      local remaining_chunk = chunk_size

      flags, br = buf:read_le_i32()
      remaining_len = remaining_len - br
      remaining_chunk = remaining_chunk - br

      tex_coord_sets, br = buf:read_le_i32()
      remaining_len = remaining_len - br
      remaining_chunk = remaining_chunk - br

      tex_coord_set_size, br = buf:read_le_i32()
      remaining_len = remaining_len - br
      remaining_chunk = remaining_chunk - br

      local i = 0
      local result = {_type = "VRTS", children = {}}

      local x
      local y
      local z
      local nx
      local ny
      local nz
      local r
      local g
      local b
      local a
      local tex_coords

      while remaining_chunk > 0 do
        tex_coords = {}

        x, br = buf:read_le_f32()
        y, br = buf:read_le_f32()
        z, br = buf:read_le_f32()
        nx, br = buf:read_le_f32()
        ny, br = buf:read_le_f32()
        nz, br = buf:read_le_f32()
        r, br = buf:read_le_f32()
        g, br = buf:read_le_f32()
        b, br = buf:read_le_f32()
        a, br = buf:read_le_f32()

        remaining_chunk = remaining_chunk - 44

        if tex_coord_sets > 0 then
          for j = 1,tex_coord_sets do
            tex_coords[j] = {}

            if tex_coord_set_size > 0 then
              for k = 1,tex_coord_set_size do
                tex_coords[j][k], br = buf:read_le_f32()
                remaining_chunk = remaining_chunk - br
              end
            end
          end
        end

        i = i + 1
        result[i] = {
          x = x,
          y = y,
          z = z,
          nx = nx,
          ny = ny,
          nz = nz,
          r = r,
          g = g,
          b = b,
          a = a,
          tex_coords = tex_coords,
        }
      end
      remaining_len = remaining_len - chunk_size
      return result, remaining_len, nil
    elseif chunk_tag == "TRIS" then
      local remaining_chunk = chunk_size

      -- Normally tris are int[X][3], but we're flattening it here to avoid allocating more tables
      local result = {_type = "TRIS", children = {}}
      if remaining_chunk % 12 == 0 then
        local v
        local n_verts = floor(remaining_chunk / 4)
        if n_verts > 0 then
          for i = 1,n_verts do
            v, br = buf:read_le_i32()
            i = i + 1
            children[i] = v
          end
        end
      else
        return nil, remaining_len, Error:new("invalid_tris", "Invalid TRIS, chunk would have more or less vertices than expected")
      end
      remaining_len = remaining_len - chunk_size
      return result, remaining_len, nil
    elseif chunk_tag == "MESH" then
      local brush_id
      local vrts
      local err
      brush_id, br = buf:read_le_i32()
      remaining_len = remaining_len - br
      remaining_chunk = chunk_size - br

      local remaining_len2
      vrts, remaining_len2, err = mod.load_string_buffer_chunk(buf, remaining_len)
      remaining_chunk = remaining_chunk - (remaining_len - remaining_len2)
      remaining_len = remaining_len2

      if vrts then
        local result = {_type = "MESH", vrts = vrts, tris_sets = {}}
        local i = 0
        local tris
        while remaining_chunk > 0 do
          tris, remaining_len, err = mod.load_string_buffer_chunk(buf, remaining_len)
          remaining_chunk = remaining_chunk - (remaining_len - remaining_len2)
          remaining_len = remaining_len2

          i = i + 1
          result.tris_sets[i] = tris
        end
      else
        return nil, remaining_len, err
      end
      return result, remaining_len, nil
    elseif chunk_tag == "BONE" then
      local n_bones = chunk_size / 8 -- 8 = vertex_id: i32 + weight: f32
      local result = {_type = "BONE", children = {}}
      if n_bones > 0 then
        local vertex_id
        local weight

        for i = 1,n_bones do
          vertex_id = buf:read_le_i32()
          weight = buf:read_le_f32()

          children[i] = {
            vertex_id = vertex_id,
            weight = weight,
          }
        end
      end

      remaining_len = remaining_len - chunk_size
      return result, remaining_len, nil
    elseif chunk_tag == "KEYS" then
      local flags

      flags, br = buf:read_le_i32()
      remaining_len = remaining_len - br
      remaining_chunk = chunk_size - br

      local result = {_type="KEYS", children = {}}
      local n_keys = floor(remaining_chunk / 44)
      if n_keys > 0 then
        local frame
        -- position
        local x
        local y
        local z
        -- scale
        local sx
        local sy
        local sz
        -- rotation
        local rw
        local rx
        local ry
        local rz

        for i = 1,n_keys do
          frame = buf:read_le_i32()
          x = buf:read_le_f32()
          y = buf:read_le_f32()
          z = buf:read_le_f32()
          sx = buf:read_le_f32()
          sy = buf:read_le_f32()
          sz = buf:read_le_f32()
          rw = buf:read_le_f32()
          rx = buf:read_le_f32()
          ry = buf:read_le_f32()
          rz = buf:read_le_f32()

          result.children[i] = {
            frame = frame,
            position = {x = x, y = y, z = z},
            scale = {x = sx, y = sy, z = sz},
            rotation = {w = rw, x = rx, y = ry, z = rz},
          }
        end
      end

      remaining_len = remaining_len - chunk_size
      return result, remaining_len, nil
    elseif chunk_tag == "ANIM" then
      local flags
      local frames
      local fps

      flags, br = buf:read_le_i32()
      remaining_len = remaining_len - br

      frames, br = buf:read_le_i32()
      remaining_len = remaining_len - br

      fps, br = buf:read_le_f32()
      remaining_len = remaining_len - br

      return {
        _type = "ANIM",
        flags = flags,
        frames = frames,
        fps = fps,
      }, remaining_len, nil
    elseif chunk_tag == "NODE" then
      local name
      -- position
      local x
      local y
      local z
      -- scale
      local sx
      local sy
      local sz
      -- rotation
      local rw
      local rx
      local ry
      local rz

      remaining_chunk = chunk_size

      name, br = buf:scan_upto("\0")
      remaining_chunk = remaining_chunk - br
      buf:walk(1)
      remaining_chunk = remaining_chunk - 1

      frame = buf:read_le_i32()
      x = buf:read_le_f32()
      y = buf:read_le_f32()
      z = buf:read_le_f32()
      sx = buf:read_le_f32()
      sy = buf:read_le_f32()
      sz = buf:read_le_f32()
      rw = buf:read_le_f32()
      rx = buf:read_le_f32()
      ry = buf:read_le_f32()
      rz = buf:read_le_f32()

      remaining_chunk = remaining_chunk - 44

      local i = 0
      local result = {
        _type = "NODE",
        position = {x = x, y = y, z = z},
        scale = {x = sx, y = sy, z = sz},
        rotation = {w = rw, x = rx, y = ry, z = rz},
        children = {},
      }

      local chunk
      local err
      while remaining_chunk > 0 do
        chunk, remaining_chunk, err = mod.load_string_buffer_chunk(buf, remaining_chunk)
        if chunk then
          i = i + 1
          result.children[i] = chunk
        else
          return nil, remaining_len, err
        end
      end

      remaining_len = remaining_len - chunk_size
      return result, remaining_len, nil
    end
  end

  return nil, remaining_len, Error:new("no remaining length for chunk")
end

--- @spec load_string_buffer(buf: StringBuffer):
---   (B3D, remaining_len: Integer, nil)
---   | (nil, remaining_len: Integer, Error)
function mod.load_string_buffer(buf)
  local head = buf:peek(4)
  if head == "BB3D" then
    buf:walk(4) -- skip head
    local root_len
    local br
    root_len, br = buf:read_le_u32()
    if root_len > 0 then
      local ver
      ver, br = buf:read_le_i32()
      -- take the version out
      root_len = root_len - 4
      if ver == 1 then
        return mod.load_string_buffer_chunk(buf, root_len)
      else
        return nil, root_len, Error:new("unsupported_version", "Unsupported version")
      end
    else
      return nil, 0, Error:new("empty", "Empty")
    end
  else
    return nil, 0, Error:new("invalid_magic", "Invalid magic header, expected BB3D")
  end
end

--- @spec load_string(bin: String):
---   (B3D, remaining_len: Integer, nil)
---   | (nil, remaining_len: Integer, error: Error)
function mod.load_string(bin)
  return mod.load_string_buffer(StringBuffer:new(bin, "r"))
end

mod:require("tests.lua")
