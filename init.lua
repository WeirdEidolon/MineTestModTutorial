minetest.register_node("mine_test_mod_tutorial:decowood", {
	tiles = {"tutorial_decowood.png"},
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
})

minetest.register_chatcommand("foo", {
    privs = { interact = true },
    func = function(name, param)
        return true, "You(" .. arg[0] .. ") said " .. param .. "!"
    end
})

minetest.register_chatcommand("whereami", {
    privs = { interact = true },
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        local p = player:getpos()
        return true, p["x"] .. "," .. p["y"] .. "," .. p["z"]
    end
})
