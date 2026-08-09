local min = assert(math.min)
local ceil = assert(math.ceil)
local floor = assert(math.floor)

local mod = foundation_binary

--- @namespace foundation.com

--- @class BaseBinaryBuffer
local BaseBinaryBuffer = foundation.com.Class:extends("foundation.com.BaseBinaryBuffer")
do
  local ic = BaseBinaryBuffer.instance_class

  ic.BLOCK_SIZE = 4096

  function ic:align_block_size(size)
    local blocks = ceil(size / self.BLOCK_SIZE)
    return blocks * self.BLOCK_SIZE
  end

  --- @spec #initialize(initial_size_or_data: Integer | String, mode: String): void
  function ic:initialize(initial_size_or_data, mode)
    local size, allocated_size, data
    if type(initial_size_or_data) == 'number' then
      allocated_size = initial_size_or_data
      data = ""
    else
      data = initial_size_or_data or ""
    end
    size = #data

    ic._super.initialize(self)
    allocated_size = allocated_size or self:align_block_size(size)
    assert(allocated_size >= size)
    self.m_size = size
    self.m_allocated_size = allocated_size
    self:prepare_data(data)
    self:open(mode)
  end

  --- @overridable
  --- @spec #prepare_data(data: String): void
  function ic.prepare_data(data)
    error("unimplemented")
  end

  --- @spec #allocated_size(): Integer
  function ic:allocated_size()
    return self.m_allocated_size
  end

  --- @spec #size(): Integer
  function ic:size()
    return self.m_size
  end

  --- @spec #close(): void
  function ic:close()
    self.m_mode = false
  end

  --- @spec #open(mode: String): void
  function ic:open(mode)
    assert(mode == "r" or mode == "w" or mode == "rw", "expected mode to be r, w or rw")
    self.m_cursor = 1
    self.m_mode = mode
    -- append
    if self.m_mode == "a" then
      self.m_cursor = 1 + self.m_size
    end
  end

  --- @spec #reopen(mode: String): void
  function ic:reopen(mode)
    self:close()
    self:open(mode)
  end

  --- @spec #tell(): Integer
  function ic:tell()
    return self.m_cursor
  end

  --- @spec #seek(new_pos: Integer): self
  function ic:seek(new_pos)
    self.m_cursor = new_pos
    return self
  end

  --- @spec #calc_read_length(len: Integer): (len: Integer, remaining_len: Integer)
  function ic:calc_read_length(len)
    assert(self.m_mode == "r" or self.m_mode == "rw", "expected read mode")
    local remaining_len = self.m_size - self.m_cursor + 1
    len = min(len or remaining_len, remaining_len)
    return len, remaining_len
  end

  --- @overridable
  --- @spec #blob(len?: Integer): String
  function ic.blob(_len)
    error("unimplemented")
  end

  --- @overridable
  --- @spec #resize(new_size: Integer): String
  function ic.resize(_new_size)
    error("unimplemented")
  end

  --- @overridable
  --- @spec #read(len: Integer): (String, len: Integer)
  function ic.read(_len)
    error("unimplemented")
  end

  --- @overridable
  --- @spec #write(blob: String): (was_written: Boolean, err: Error)
  function ic.write(_blob)
    error("unimplemented")
  end
end

foundation.com.BaseBinaryBuffer = BaseBinaryBuffer

mod:require("binary_buffer/ffi.lua")
mod:require("binary_buffer/lua.lua")

--- @const BinaryBuffer: FFIBinaryBuffer | LuaBinaryBuffer
foundation.com.BinaryBuffer = foundation.com.FFIBinaryBuffer or foundation.com.LuaBinaryBuffer
