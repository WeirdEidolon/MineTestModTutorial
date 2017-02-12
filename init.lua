minetest.register_node("mine_test_mod_tutorial:decowood", {
	tiles = {"tutorial_decowood.png"},
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
})

minetest.register_chatcommand("foo", {
    privs = { interact = true },
    func = function(name, param)
        return true, "You(" .. name .. ") said " .. param .. "!"
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

minetest.register_chatcommand("dirtbox", {
    privs = { interact = true },
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        local p = player:getpos()
        local dirt = {name="default:dirt"}
        
        for ix=-10,10,1
        do
            minetest.set_node({x=p["x"]+ix, y=p["y"]-10, z=p["z"]-10}, dirt)
            minetest.set_node({x=p["x"]+ix, y=p["y"]-10, z=p["z"]+10}, dirt)
            minetest.set_node({x=p["x"]+ix, y=p["y"]+10, z=p["z"]-10}, dirt)
            minetest.set_node({x=p["x"]+ix, y=p["y"]+10, z=p["z"]+10}, dirt)
            
            minetest.set_node({x=p["x"]-10, y=p["y"]+ix, z=p["z"]-10}, dirt)
            minetest.set_node({x=p["x"]-10, y=p["y"]+ix, z=p["z"]+10}, dirt)
            minetest.set_node({x=p["x"]+10, y=p["y"]+ix, z=p["z"]-10}, dirt)
            minetest.set_node({x=p["x"]+10, y=p["y"]+ix, z=p["z"]+10}, dirt)
            
            minetest.set_node({x=p["x"]-10, y=p["y"]-10, z=p["z"]+ix}, dirt)
            minetest.set_node({x=p["x"]-10, y=p["y"]+10, z=p["z"]+ix}, dirt)
            minetest.set_node({x=p["x"]+10, y=p["y"]-10, z=p["z"]+ix}, dirt)
            minetest.set_node({x=p["x"]+10, y=p["y"]+10, z=p["z"]+ix}, dirt)
        end
        
        return true, "put dirt"
    end
})


-- http://lua-users.org/wiki/FileInputOutput

-- see if the file exists
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function lines_from(file)
  if not file_exists(file) then return {} end
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end



minetest.register_chatcommand("readtest", {
    privs = { interact = true },
    func = function(name, param)
        -- tests the functions above
        local file = minetest.get_modpath("mine_test_mod_tutorial") .. '/test.txt'
        local lines = lines_from(file)

        -- print all line numbers and their contents
        for k,v in pairs(lines) do
          print('line[' .. k .. ']', v)
        end
        
        return true, "read test.txt"
    end
})
