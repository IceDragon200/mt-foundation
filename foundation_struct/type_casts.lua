-- @namespace foundation.com

local List = foundation.com.List
local LinkedList = foundation.com.List

local ic

-- @class List
ic = List.instance_class
local list_next = List.list_next

function ic:to_linked_list()
  local ll = LinkedList:new()

  for _, item in list_next,self.m_data,0 do
    ll:push(item)
  end

  return ll
end

-- @class LinkedList
ic = List.instance_class

function ic:to_list()
  local item
  local list = List:new()
  local node = self.head

  while node do
    item = node.value
    list:push(item)
    node = node.next
  end

  return list
end
