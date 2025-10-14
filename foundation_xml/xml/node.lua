--- @namespace foundation.com.XML
local List = foundation.com.List

--- @class Element
local Element = foundation.com.Class:extends("foundation_xml.XML.Element")
do
  local ic = Element.instance_class

  --- @spec #initialize(): void
  function ic:initialize()
    ic._super.initialize(self)

    self.name = ""
    self.attributes = List:new()
    self.children = List:new()
  end
end

foundation_xml.XML.Element = Element
