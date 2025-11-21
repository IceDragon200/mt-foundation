--- @namespace foundation.com.headless
local assertions = assert(foundation.com.assertions)

local function matches_pattern(base, pattern)
  local at
  local bt

  local a
  local b
  local s = {oa, ob}
  local i = 2
  while i > 0 do
    b = s[i]
    a = s[i - 1]
    i = i - 2
    at = type(a)
    bt = type(b)
    if at == bt then
      if at == "table" then
        for key, _ in pairs(b) do
          s[i] = a[key]
          s[i + 1] = b[key]
          i = i + 2
        end
      else
        if a ~= b then
          return false
        end
      end
    else
      return false
    end
  end
  return true
end

local function deep_eq(oa, ob)
  local at
  local bt

  local a
  local b
  local s = {oa, ob}
  local i = 2
  local keys
  while i > 0 do
    b = s[i]
    a = s[i - 1]
    i = i - 2
    at = type(a)
    bt = type(b)
    if at == bt then
      if at == "table" then
        keys = {}

        for key, _ in pairs(a) do
          keys[key] = true
        end
        for key, _ in pairs(b) do
          keys[key] = true
        end

        for key, _ in pairs(keys) do
          s[i] = a[key]
          s[i + 1] = b[key]
          i = i + 2
        end
      else
        if a ~= b then
          return false
        end
      end
    else
      return false
    end
  end
  return true
end

--- Shallow copy
local function table_copy(t)
  local result = {}
  for k,v in pairs(t) do
    result[k] = v
  end
  return result
end

--- @class CraftRegistry
local CraftRegistry = foundation.com.Class:extends("foundation.com.headless.CraftRegistry")
do
  local ic = assert(CraftRegistry.instance_class)

  --- @spec #initialize(): void
  function ic:initialize()
    ic._super.initialize(self)

    self.m_craft_recipe_id = self.m_craft_recipe_id or 0
    self.m_registered_crafts = {
      shaped = {},
      shapeless = {},
      fuel = {},
      cooking = {},
    }
    self.m_output_recipes = self.m_output_recipes or {}
    self.m_craft_ingredient_id = 0
    self.m_craft_ingredient_index = {
      [""] = 0,
    }
    self.m_craft_recipe_index = {}
  end

  function ic:sort_items(items)
    local result = table_copy(items)
    table.sort(result, function (a, b)
      if a and b then
        return self.m_craft_ingredient_index[a:get_name()] <
               self.m_craft_ingredient_index[b:get_name()]
      end
      return false
    end)
    return result
  end

  --- @spec #register_craft({
  ---   type = "shaped" | "shapeless" | "fuel" | "cooking"
  --- })
  function ic:register_craft(def)
    def.type = def.type or "shaped"
    assert(type(def.type) == "string", "expected a type")
    if not def.recipe then
      error("expected a recipe (got " .. dump(def) .. ")")
    elseif type(def.recipe) == "string" then
      def.recipe = { def.recipe }
    end
    if def.output then
      assert(type(def.output) == "string", "expected an output")
    end

    if def.type == "shaped" then
      for i,row in pairs(def.recipe) do
        assert(type(row) == "table", "expected recipe to contain rows")
      end
    elseif def.type == "shapeless" then
      for i,row in pairs(def.recipe) do
        assert(type(row) == "string", "expected recipe to contain item strings")
      end
    elseif def.type == "cooking" then
      def.cooktime = def.cooktime or 3.0
      assertions.is_number(def.cooktime)

      for i,row in pairs(def.recipe) do
        assert(type(row) == "string", "expected recipe to contain item strings")
      end
    elseif def.type == "fuel" then
      def.burntime = def.burntime or 1.0
      assertions.is_number(def.burntime)

      for i,row in pairs(def.recipe) do
        assert(type(row) == "string", "expected recipe to contain item strings")
      end
    else
      error("invalid craft recipe type="..def.type)
    end
    local recipe = {}

    if def.type == "shaped" then
      local row_size
      for i,row in pairs(def.recipe) do
        recipe[i] = {}
        if not row_size then
          row_size = #row
        end

        if row_size ~= #row then
          error("expected recipe row size to be size=" .. row_size)
        end

        for j,item_string in pairs(row) do
          local item_stack = ItemStack(item_string)
          self.m_craft_ingredient_id = self.m_craft_ingredient_id + 1
          self.m_craft_ingredient_index[item_stack:get_name()] = self.m_craft_ingredient_id
          recipe[i][j] = item_stack
        end
      end
    else
      for i,item_string in pairs(def.recipe) do
        local item_stack = ItemStack(item_string)
        self.m_craft_ingredient_id = self.m_craft_ingredient_id + 1
        self.m_craft_ingredient_index[item_stack:get_name()] = self.m_craft_ingredient_id
        recipe[i] = item_stack
      end
    end

    if not self.m_registered_crafts[def.type] then
      self.m_registered_crafts[def.type] = {}
    end
    local crafts = assert(self.m_registered_crafts[def.type], "expected craft table to exist")

    self.m_craft_recipe_id = self.m_craft_recipe_id + 1
    local recipe_id = self.m_craft_recipe_id
    def = table_copy(def)
    if def.output then
      def.output = ItemStack(def.output)
      local name = def.output:get_name()
      if not self.m_output_recipes[name] then
        self.m_output_recipes[name] = {}
      end
      self.m_output_recipes[name][recipe_id] = def.type
    end
    def.recipe = recipe
    crafts[recipe_id] = def

    if not self.m_craft_recipe_index[def.type] then
      self.m_craft_recipe_index[def.type] = {
        children = {},
        recipes = {},
      }
    end

    local root = self.m_craft_recipe_index[def.type]

    if def.type == "shaped" then
      local width = #recipe[1]
      if not root.children[width] then
        root.children[width] = {
          children = {},
          recipes = {},
        }
      end
      root = root.children[width]

      local name
      for _,row in ipairs(recipe) do
        for _,item in ipairs(row) do
          name = item:get_name() or ""
          if not root.children[name] then
            root.children[name] = {
              children = {},
              recipes = {},
            }
          end
          root = root.children[name]
        end
      end
    else
      recipe = self:sort_items(recipe)

      local name
      local width = 1
      if not root.children[width] then
        root.children[width] = {
          children = {},
          recipes = {},
        }
      end
      root = root.children[width]

      for _, item in ipairs(recipe) do
        name = item:get_name() or ""
        if not root.children[name] then
          root.children[name] = {
            recipes = {},
            children = {},
          }
        end
        root = root.children[name]
      end
    end

    root.recipes[recipe_id] = true
  end

  --- @spec #get_all_craft_recipes(item_name: String): Recipe[] | nil
  function ic:get_all_craft_recipes(item_name)
    local recipes = self.m_output_recipes[item_name]
    if recipes then
      local result = {}
      local i = 0
      local recipe
      local method
      local width
      local items
      local output

      for recipe_id, craft_type in pairs(recipes) do
        i = i + 1
        recipe = self.m_registered_crafts[craft_type][recipe_id]
        method = recipe.type
        if method == "shaped" or method == "shapeless" then
          method = "normal"
        end
        width = recipe.width
        items = table_copy(recipe.recipe)
        output = recipe.output
        result[i] = {
          method = method,
          width = width,
          items = items,
          output = output,
        }
      end
      return result
    end
    return nil
  end

  --- @spec #clear_craft(Table): void
  function ic:clear_craft(pattern)
    local crafts = self.m_registered_crafts[pattern.type or "shaped"]
    if crafts then
      for id, recipe in pairs(crafts) do
        if matches_pattern(recipe, pattern) then
          if recipe.output and self.m_output_recipes[recipe.output] then
            self.m_output_recipes[recipe.output][id] = nil
            if not next(self.m_output_recipes[recipe.output]) then
              self.m_output_recipes[recipe.output] = nil
            end
          end
          crafts[id] = nil
          break
        end
      end
    end
  end

  local function prepare_craft_result_input(input)
    local result = table_copy(input)
    result.width = result.width or 1
    local width = result.width

    if result.items then
      local old_items = result.items
      result.items = {}
      if width <= 1 then
        for i,item in ipairs(old_items) do
          result.items[i] = ItemStack(item)
        end
      else
        for i,row in ipairs(old_items) do
          result.items[i] = {}
          for j,item in ipairs(row) do
            result.items[i][j] = ItemStack(item)
          end
        end
      end
    end
    return result
  end

  --- @spec #get_craft_result({
  ---   method: "normal" | "cooking" | "fuel",
  ---   width: Integer,
  ---   items: ItemStack[],
  --- }): ({
  ---   item: ItemStack,
  ---   time: Integer,
  ---   replacements: ItemStack[]
  --- }, leftover: {
  ---   items: ItemStack[]
  --- })
  function ic:get_craft_result(input)
    input = prepare_craft_result_input(input)
    local method = input.method
    local width = input.width

    local root
    local recipe_index_name
    if method == "normal" then
      if width > 1 then
        recipe_index_name = "shaped"
      else
        recipe_index_name = "shapeless"
      end
    elseif method == "cooking" then
      recipe_index_name = "cooking"
    elseif method == "fuel" then
      recipe_index_name = "fuel"
    else
      error("unexpected method="..method)
    end

    root = self.m_craft_recipe_index[recipe_index_name]
    if root then
      root = root.children[width]
      if root then
        if width <= 1 then
          -- shapeless
          local items = self:sort_items(input.items)
          for _,item in ipairs(items) do
            root = root.children[item:get_name()]
            if not root then
              break
            end
          end
        else
          -- shaped
          for _,row in ipairs(input.items) do
            for _,item in ipairs(row) do
              root = root.children[item:get_name() or ""]
              if not root then
                break
              end
            end
          end
        end

        if root then
          local recipe_id = next(root.recipes)
          local recipe = self.m_registered_crafts[recipe_index_name][recipe_id]
          if recipe then
            local item
            local leftover = table_copy(input)
            local leftover_items = leftover.items
            leftover.items = {}
            for i,leftover_item_stack in ipairs(leftover_items) do
              leftover_item_stack = ItemStack(leftover_item_stack)
              leftover_item_stack:take_item(1) -- drop an item from the stack
              leftover.items[i] = leftover_item_stack
            end

            if recipe.output then
              item = recipe.output:peek_item(recipe.output:get_count())
            end
            if recipe_index_name == "fuel" then
              return {
                item = item,
                time = recipe.burntime,
                replacements = {},
              }, leftover
            elseif recipe_index_name == "cooking" then
              return {
                item = item,
                time = recipe.cooktime,
                replacements = {},
              }, leftover
            end

            return {
              item = item,
              time = 0,
              replacements = {},
            }, leftover
          end
        end
      end
    end

    return { item = ItemStack(), time = 0, replacements = {} }, input
  end
end

foundation.com.headless.CraftRegistry = CraftRegistry
