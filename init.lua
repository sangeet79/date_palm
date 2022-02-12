--
-- Date Palm
--

local modname = "date_palm"
local modpath = minetest.get_modpath(modname)
local mg_name = minetest.get_mapgen_setting("mg_name")

-- internationalization boilerplate
local S = minetest.get_translator(minetest.get_current_modname())

-- Date Palm

local function grow_new_date_palm_tree(pos)
	if not default.can_grow(pos) then
		-- try a bit later again
		minetest.get_node_timer(pos):start(math.random(240, 600))
		return
	end
	minetest.remove_node(pos)
	minetest.place_schematic({x = pos.x-4, y = pos.y, z = pos.z-4}, modpath.."/schematics/date_palm.mts", "0", nil, false)
end

--
-- Decoration
--

minetest.register_decoration({
	name = "date_palm:date_palm_tree",
	deco_type = "schematic",
	place_on = {"default:sand"},
	sidelen = 16,
	noise_params = {
		offset = 0.001,
		scale = 0.002,
		spread = {x = 250, y = 250, z = 250},
		seed = 3462,
		octaves = 3,
		persist = 0.66
	},
	biomes = {"sandstone_desert_ocean", "desert_ocean"},
	y_min = 1,
	y_max = 20,
	schematic = modpath.."/schematics/date_palm.mts",
	flags = "place_center_x, place_center_z, force_placement",
	rotation = "random",
})

--
-- Nodes
--

minetest.register_node("date_palm:sapling", {
	description = S("Date Palm Sapling"),
	drawtype = "plantlike",
	tiles = {"date_palm_sapling.png"},
	inventory_image = "date_palm_sapling.png",
	wield_image = "date_palm_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_new_date_palm_tree,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(2400,4800))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			"date_palm:sapling",
			-- minp, maxp to be checked, relative to sapling pos
			-- minp_relative.y = 1 because sapling pos has been checked
			{x = -2, y = 1, z = -2},
			{x = 2, y = 6, z = 2},
			-- maximum interval of interior volume check
			4)

		return itemstack
	end,
})

-- textures taken from VanessaE moretrees mod
minetest.register_node("date_palm:trunk", {
	description = S("Date Palm Trunk"),
	tiles = {
		"date_palm_trunk_top.png",
		"date_palm_trunk_top.png",
		"date_palm_trunk.png"
	},
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	paramtype2 = "facedir",
	is_ground_content = false,
	on_place = minetest.rotate_node,
})

-- date palm wood
minetest.register_node("date_palm:wood", {
	description = S("Date Palm Wood"),
	tiles = {"date_palm_wood.png"},
	paramtype2 = "facedir",
	place_param2 = 0,
	is_ground_content = false,
	groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

-- date palm leaves
minetest.register_node("date_palm:leaves", {
	description = S("Date Palm Leaves"),
    drawtype = "plantlike",
    visual_scale = 1.4,
	node_box = {
		type = "fixed",
		fixed = {
				{-0.5, -0.4375, -0.5, 0.5, -0.5, 0.5},
			},
		},
	tiles = {
		"date_palm_leaves.png",
	},
	paramtype = "light",
	walkable = false,
	waving = 1,
	groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2},
	drop = {
		max_items = 1,
		items = {
			{items = {"date_palm:sapling"}, rarity = 20},
			{items = {"date_palm:leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})

--
-- Dates
--
-- Register dates

local dates_drop = {
	items = {
		{items = { "date_palm:date" }},
		{items = { "date_palm:date" }},
		{items = { "date_palm:date" }},
		{items = { "date_palm:date" }},
		{items = { "date_palm:date" }, rarity = 2 },
		{items = { "date_palm:date" }, rarity = 2 },
		{items = { "date_palm:date" }, rarity = 2 },
		{items = { "date_palm:date" }, rarity = 2 },
		{items = { "date_palm:date" }, rarity = 5 },
		{items = { "date_palm:date" }, rarity = 5 },
		{items = { "date_palm:date" }, rarity = 5 },
		{items = { "date_palm:date" }, rarity = 5 },
		{items = { "date_palm:date" }, rarity = 20 },
		{items = { "date_palm:date" }, rarity = 20 },
		{items = { "date_palm:date" }, rarity = 20 },
		{items = { "date_palm:date" }, rarity = 20 },
	}
}

minetest.register_node("date_palm:dates", {
	description = S("Dates"),
	tiles = {"dates.png"},
	visual_scale = 2,
	drawtype = "plantlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {fleshy = 3, dig_immediate = 3, flammable = 2,
		leafdecay = 3, leafdecay_drop = 1},
	inventory_image = "dates.png^[transformR0",
	wield_image = "dates.png^[transformR90",
	sounds = default.node_sound_defaults(),
	drop = dates_drop,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.3, -0.3, 0.3, 3.5, 0.3}
	},

})

--
-- Craftitems
--

minetest.register_craftitem("date_palm:date", {
	description = S("Date"),
	inventory_image = "date.png",
	on_use = minetest.item_eat(1),
})

minetest.register_craftitem("date_palm:date_nut_snack", {
	description = S("Date & nut snack"),
	inventory_image = "date_nut_snack.png",
	on_use = minetest.item_eat(4),
})

minetest.register_craftitem("date_palm:date_nut_batter", {
	description = S("Date-nut cake batter"),
	inventory_image = "date_nut_batter.png",
})

minetest.register_craftitem("date_palm:date_nut_cake", {
	description = S("Date-nut cake"),
	inventory_image = "date_nut_cake.png",
	on_use = minetest.item_eat(32),
})

minetest.register_craftitem("date_palm:date_nut_bar", {
	description = S("Date-nut energy bar"),
	inventory_image = "date_nut_bar.png",
	on_use = minetest.item_eat(4),
})

--[[
minetest.register_craft({
	type = "shapeless",
	output = "date_palm:date_nut_snack",
	recipe = {
		"date_palm:date",
		"date_palm:date",
		"date_palm:date",
		"date_palm:spruce_nuts",
		"date_palm:cedar_nuts",
		"date_palm:fir_nuts",
	}
})

-- The date-nut cake is an exceptional food item due to its highly
-- concentrated nature (32 food units). Because of that, it requires
-- many different ingredients, and, starting from the base ingredients
-- found or harvested in nature, it requires many steps to prepare.
local flour
if minetest.registered_nodes["farming:flour"] then
	flour = "farming:flour"
else
	flour = "date_palm:acorn_muffin_batter"
end
minetest.register_craft({
	type = "shapeless",
	output = "date_palm:date_nut_batter",
	recipe = {
		"date_palm:date_nut_snack",
		"date_palm:date_nut_snack",
		"date_palm:date_nut_snack",
		"date_palm:coconut_milk",
		"date_palm:date_nut_snack",
		"date_palm:raw_coconut",
		"date_palm:coconut_milk",
		flour,
		"date_palm:raw_coconut",
	},
	replacements = {
		{ "moretrees:coconut_milk", "vessels:drinking_glass 2" }
	}
})

minetest.register_craft({
	type = "cooking",
	output = "moretrees:date_nut_cake",
	recipe = "moretrees:date_nut_batter",
})

minetest.register_craft({
	type = "shapeless",
	output = "moretrees:date_nut_bar 8",
	recipe = {"moretrees:date_nut_cake"},
})

]]

--
-- Recipes
--

minetest.register_craft({
	output = "date_palm:wood 4",
	recipe = {{"date_palm:trunk"}}
})

minetest.register_craft({
	type = "fuel",
	recipe = "date_palm:trunk",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "date_palm:wood",
	burntime = 7,
})

default.register_leafdecay({
	trunks = {"date_palm:trunk"},
	leaves = {"date_palm:leaves", "date_palm:dates"},
	radius = 5,
})

-- Fence
if minetest.settings:get_bool("cool_fences", true) then
	local fence = {
		description = S("Date Palm Wood Fence"),
		texture =  "date_palm_wood.png",
		material = "date_palm:wood",
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		sounds = default.node_sound_wood_defaults(),
	}
	default.register_fence("date_palm:fence", table.copy(fence))
	fence.description = S("Date Palm Fence Rail")
	default.register_fence_rail("date_palm:fence_rail", table.copy(fence))

	if minetest.get_modpath("doors") ~= nil then
		fence.description = S("Date Palm Fence Gate")
		doors.register_fencegate("date_palm:gate", table.copy(fence))
	end
end

--Stairs

if minetest.get_modpath("stairs") ~= nil then
	stairs.register_stair_and_slab(
		"date_palm_wood",
		"date_palm:wood",
		{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		{"date_palm_wood.png"},
		S("Date Palm Stair"),
		S("Date Palm Slab"),
		default.node_sound_wood_defaults()
	)
end

-- stairsplus/moreblocks
if minetest.get_modpath("moreblocks") then
	stairsplus:register_all("date_palm", "wood", "date_palm:wood", {
		description = S("Date Palm"),
		tiles = {"date_palm_wood.png"},
		groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
		sounds = default.node_sound_wood_defaults(),
	})
end

if minetest.get_modpath("bonemeal") ~= nil then
	bonemeal:add_sapling({
		{"date_palm:sapling", grow_new_date_palm_tree, "soil"},
        {"date_palm:sapling", grow_new_date_palm_tree, "sand"},
	})
end

--[[
-- Support for obsidianmese capitator, when i manage to change its API to allow external additions. i made chenges, but they don't work :)
if minetest.get_modpath("obsidianmese") ~= nil then
	obsidianmese:add_trees({
        {"date_palm:trunk"},
    })
end
]]

-- Support for flowerpot
if minetest.global_exists("flowerpot") then
	flowerpot.register_node("date_palm:sapling")
end
