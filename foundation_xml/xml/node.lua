--- @namespace foundation.com.XML
local List = assert(foundation.com.List)
local table_copy = assert(foundation.com.table_copy)

--- @class Element
local Element = foundation.com.Class:extends("foundation_xml.XML.Element")
do
  local ic = Element.instance_class

  --- @spec #initialize(): void
  function ic:initialize()
    ic._super.initialize(self)

    --- @member name: String
    self.name = ""

    --- @member attributes: List<{
    ---   name: String,
    ---   value: String,
    --- }>
    self.attributes = List:new()

    --- @member children: List<Element>
    self.children = List:new()
  end

  --- @spec #initialize_copy(other: Element): void
  function ic:initialize_copy(other)
    self.name = other.name
    self.attributes = List:new()
    self.children = List:new()

    for _,attr in other.attributes:each() do
      self.attributes:push(table_copy(attr))
    end

    for _,child in other.children:each() do
      self.children:push(child)
    end
  end

  --- Creates a shallow copy of the Element, children are not copies.
  ---
  --- @spec #copy(): Element
  function ic:copy()
    local element = Element:alloc()
    element:initialize_copy(self)
    return element
  end

  --- @spec #find_element(predicate: (element: Element) => Boolean): Element | nil
  function ic:find_element(predicate)
    local i = 1
    local stack = {self}
    local element
    while i > 0 do
      element = stack[i]
      stack[i] = nil
      i = i - 1
      if predicate(element) then
        return element
      else
        if type(element) == "table" then
          for j = 1,element.children.m_cursor do
            i = i + 1
            stack[i] = element.children.m_data[j]
          end
        end
      end
    end
    return nil
  end

  --- @spec #find_element_by_name(name: String): Element | nil
  function ic:find_element_by_name(name)
    return self:find_element(function (element)
      if type(element) == "table" then
        return element.name == name
      else
        return false
      end
    end)
  end

  --- @spec #find_element_by_attribute(name: String, value: String): Element | nil
  function ic:find_element_by_attribute(name, value)
    return self:find_element(function (element)
      if type(element) == "table" then
        for _,attr in element.attributes:each() do
          if attr.name == name then
            if value then
              if attr.value == value then
                return true
              end
            else
              return true
            end
          end
        end
      end
      return false
    end)
  end

  --- @spec #find_elements(predicate: (element: Element) => Boolean): Element[]
  function ic:find_elements(predicate)
    local i = 1
    local stack = {self}
    local element
    local r = 0
    local result = {}
    while i > 0 do
      element = stack[i]
      stack[i] = nil
      i = i - 1
      if predicate(element) then
        r = r + 1
        result[r] = element
      end
      for j = 1,element.children.m_cursor do
        i = i + 1
        stack[i] = element.children.m_data[j]
      end
    end
    return result
  end

  --- @spec #find_elements_by_name(name: String): Element[]
  function ic:find_elements_by_name(name)
    return self:find_elements(function (element)
      if type(element) == "table" then
        return element.name == name
      else
        return false
      end
    end)
  end

  --- @spec #find_elements_by_attribute(name: String, value: String): Element[]
  function ic:find_elements_by_attribute(name, value)
    return self:find_elements(function (element)
      if type(element) == "table" then
        for _,attr in element.attributes:each() do
          if attr.name == name then
            if value then
              if attr.value == value then
                return true
              end
            else
              return true
            end
          end
        end
      end
      return false
    end)
  end
end

foundation_xml.XML.Element = Element
