minetest.register_node("mine_test_mod_tutorial:decowood", {
	tiles = {"tutorial_decowood.png"},
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
})

minetest.register_chatcommand("foo", {
	privs = {
		interact = true
	},
	func = function(name, param)
		return true, "You(" .. name .. ") said " .. param .. "!"
	end
})