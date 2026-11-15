--
-- Stone bacteria item
--

local stone_bacteria = table.deepcopy(data.raw["item"]["iron-bacteria"])
stone_bacteria.name = "stone-bacteria"
stone_bacteria.localised_name = {"item-name.stone-bacteria"}

-- Spoils into stone
stone_bacteria.spoil_result = "stone"

-- Icon
stone_bacteria.icon = "__stone-bacteria__/graphics/icons/stone-bacteria.png"
stone_bacteria.icon_size = 64
stone_bacteria.icons = nil

data:extend({stone_bacteria})

--
-- Cultivation recipe
--

local recipe = table.deepcopy(
    data.raw["recipe"]["iron-bacteria-cultivation"]
)
recipe.name = "stone-bacteria-cultivation"

-- Replace iron bacteria in the ingredients
for _, ingredient in pairs(recipe.ingredients) do
    if ingredient.name == "iron-bacteria" then
        ingredient.name = "stone-bacteria"
    end
end

-- Replace iron bacteria in the results
for _, result in pairs(recipe.results) do
    if result.name == "iron-bacteria" then
        result.name = "stone-bacteria"
    end
end

recipe.enabled = false
recipe.icon = "__stone-bacteria__/graphics/icons/stone-bacteria-cultivation.png"
recipe.icon_size = 64
recipe.icons = nil
recipe.localised_name = nil
recipe.localised_description = nil
data:extend({recipe})


--
-- Initial creation recipe
--

data:extend({
    {
        type = "recipe",
        name = "stone-bacteria",
        categories = {"organic"},
        enabled = false,
        energy_required = 1,
        ingredients = {
            {type = "item", name = "bioflux", amount = 1}
        },
        results = {
            {
                type = "item",
                name = "stone-bacteria",
                amount = 1,
                independent_probability = 0.1
            },
            {
                type = "item",
                name = "spoilage",
                amount = 2
            }
        },
        surface_conditions = {
            {
                property = "pressure",
                min = 2000,
                max = 2000
            }
        },
        main_product = "stone-bacteria",
        allow_productivity = true
    }
})


--
-- Require the bacteria-cultivation technology to unlock the recipes
--

local technology = data.raw["technology"]["bacteria-cultivation"]

table.insert(technology.effects, {
    type = "unlock-recipe",
    recipe = "stone-bacteria"
})

table.insert(technology.effects, {
    type = "unlock-recipe",
    recipe = "stone-bacteria-cultivation"
})


--
-- Put them after copper bacteria in the same subgroup
--

local subgroup = data.raw["recipe"]["copper-bacteria-cultivation"].subgroup

data.raw["item"]["stone-bacteria"].subgroup = subgroup
data.raw["recipe"]["stone-bacteria"].subgroup = subgroup
data.raw["recipe"]["stone-bacteria-cultivation"].subgroup = subgroup

local copper_order = data.raw["recipe"]["copper-bacteria-cultivation"].order
data.raw["recipe"]["stone-bacteria"].order = copper_order .. "-a"
data.raw["recipe"]["stone-bacteria-cultivation"].order = copper_order .. "-b"


--
-- Change stromatolite minable results to include stone bacteria
--

local function modify_stromatolite(name)

    local stromatolite = data.raw["simple-entity"][name]

    if not stromatolite then
        error("Stromatolite not found: " .. name)
    end

    local products = stromatolite.minable.results

    -- Reduce stone production
    for _, product in pairs(products) do
        if product.name == "stone" then
            product.amount_min = 1
            product.amount_max = 3
            product.amount = nil
        end
    end

    -- Add stone bacteria
    table.insert(products, {
        type = "item",
        name = "stone-bacteria",
        amount_min = 1,
        amount_max = 2
    })

end

modify_stromatolite("iron-stromatolite")
modify_stromatolite("copper-stromatolite")