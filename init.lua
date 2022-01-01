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
	minetest.place_schematic({x = pos.x-6, y = pos.y, z = pos.z-4}, modpath.."/schematics/date_palm.mts", "0", nil, false)
end

--
-- Decoration
--

if mg_name ~= "v6" and mg_name ~= "singlenode" then

	if minetest.get_modpath("rainf") then
		place_on = "rainf:meadow"
		biomes = "rainf"
		offset = 0.0005
		scale = 0.0002
	else    
		place_on = "default:sand"
		biomes = "desert_ocean"
		offset = 0.0002
		scale = 0.0002
	end

	minetest.register_decoration({
		name = "date_palm:date_palm_tree",
		deco_type = "schematic",
		place_on = "default:sand",
		sidelen = 16,
		noise_params = {
			offset = offset,
			scale = scale,
			spread = {x = 250, y = 250, z = 250},
			seed = 3462,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"sandstone_desert_ocean", "desert_ocean"},
		y_min = 1,
		y_max = 62,
		schematic = modpath.."/schematics/date_palm.mts",
		flags = "place_center_x, place_center_z, force_placement",
		rotation = "random",
	})
end

--
-- Nodes
--

minetest.register_node("date_palm:sapling", {
	description = S("Date Palm Tree Sapling"),
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
    paramtype2 = "facedir",
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
-- Craftitems
--

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
	leaves = {"date_palm:leaves"},
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
		"date_palm_trunk",
		"date_palm:trunk",
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
		description = "date_palm",
		tiles = {"date_palm_wood.png"},
		groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
		sounds = default.node_sound_wood_defaults(),
	})
end

if minetest.get_modpath("bonemeal") ~= nil then
	bonemeal:add_sapling({
		{"date_palm:sapling", grow_new_date_palm_tree, "sand"},
        {"date_palm:sapling", grow_new_date_palm_tree, "soil"},
	})
end


-- Support for flowerpot
if minetest.global_exists("flowerpot") then
	flowerpot.register_node("date_palm:sapling")
end
