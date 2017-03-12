minetest.register_chatcommand("whereami", {
    privs = { interact = true },
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        local p = player:getpos()
        return true, p["x"] .. "," .. p["y"] .. "," .. p["z"]
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
  local lines = {}
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


minetest.register_chatcommand("placemap", {
    privs = { interact = true },
    func = function(name, param)
      local file = minetest.get_modpath("mine_test_mod_tutorial") .. '/map.txt'
      local lines = lines_from(file)

      local player = minetest.get_player_by_name(name)
      local pos = player:getpos()
      local stone = {name="default:stone", param1=0}
      local air = {name="air", param1=0}
      local door = {name="my_castle_doors:door6_locked"}
      local door_h = {name="doors:door_steel_b_1"}
      local door_v = {name="doors:door_steel_t_1"}

      local height = tonumber(lines[1])

      local function get_local_height(ix, iz, height, lines)
        local local_height = height
        local north = string.sub(lines[ix-1], iz, iz)
        local south = string.sub(lines[ix+1], iz, iz)
        local west = string.sub(lines[ix], iz-1, iz-1)
        local east = string.sub(lines[ix], iz+1, iz+1)

        if north ~= '.' then
          local_height = local_height-1
        end
        if south ~= '.' then
          local_height = local_height-1
        end
        if west ~= '.' then
          local_height = local_height-1
        end
        if east ~= '.' then
          local_height = local_height-1
        end
        return local_height
      end

      for ix=3, table.maxn(lines)-1, 1
      do
        for iz=2, string.len(lines[ix])-1, 1
        do
          local char = string.sub(lines[ix], iz, iz)
          local local_height = height
          if char == '.' then
            local_height = get_local_height(ix, iz, height, lines)
          end

          for iy=0, height+1, 1
          do
            if iy == 0 or iy > height or char == "#" then
              minetest.set_node({x=pos["x"]+ix, y=pos["y"]+iy, z=pos["z"]+iz}, stone)
            elseif char == "-" or char == "|" then
              -- door placement doesn't work like this, so just make doorways low
              -- if iy == 1 then
              --   minetest.set_node({x=pos["x"]+ix, y=pos["y"]+iy, z=pos["z"]+iz}, door_h)
              if iy > 2 then
                minetest.set_node({x=pos["x"]+ix, y=pos["y"]+iy, z=pos["z"]+iz}, stone)
              else
                minetest.set_node({x=pos["x"]+ix, y=pos["y"]+iy, z=pos["z"]+iz}, air)
              end
            else
              if iy < local_height then
                minetest.set_node({x=pos["x"]+ix, y=pos["y"]+iy, z=pos["z"]+iz}, air)
              else
                minetest.set_node({x=pos["x"]+ix, y=pos["y"]+iy, z=pos["z"]+iz}, stone)
              end
            end
          end
        end
      end
      return true, "map imported"
    end
})
