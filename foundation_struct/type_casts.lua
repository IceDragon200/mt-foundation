--- @namespace foundation.com

local List = assert(foundation.com.List)
local LinkedList = assert(foundation.com.LinkedList)

local ic

do
  --- @class List<T>
  ic = List.instance_class

  local list_next = List.list_next

  --- @spec #to_linked_list(): LinkedList<T>
  function ic:to_linked_list()
    local ll = LinkedList:new()

    for _, item in list_next,self,0 do
      ll:push(item)
    end

    return ll
  end
end

do
  --- @class LinkedList
  ic = LinkedList.instance_class

  --- @spec #to_list(): List<T>
  function ic:to_list()
    local item
    local list = List:new()
    local node = self.next

    while node do
      item = node.value
      list:push(item)
      node = node.next
    end

    return list
  end
end
