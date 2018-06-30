-- realcompass 1.1
-- This fork written by David_G (kestral246@gmail.com)
-- My changes are CC0 (No rights reserved)
-- textures:  original compass textures: CC BY-SA by Echo (I added 45deg versions)
-- Changes:
--      only points north
--      reverted back to 12 directions--I couldn't get the 16-direction version's animations to look as good.
--      changed crafting recipe so it can be used in parallel with other compass versions.

-- based on compassgps 2.7 and compass 0.5
--
--Original code by Echo, PilzAdam, and TeTpaAka is WTFPL.
--Original code by Kilarin (Donald Hines) is CC0 (No rights reserved).
--fixed bug that caused compass to jump around in inventory

local activewidth=8 --until I can find some way to get it from minetest

minetest.register_globalstep(function(dtime)
    local players  = minetest.get_connected_players()
    for i,player in ipairs(players) do

        local gotacompass=false
        local wielded=false
        local activeinv=nil
        local stackidx=0
        --first check to see if the user has a compass, because if they don't
        --there is no reason to waste time calculating bookmarks or spawnpoints.
        local wielded_item = player:get_wielded_item():get_name()
        if string.sub(wielded_item, 0, 12) == "realcompass:" then
            --if the player is wielding a compass, change the wielded image
            wielded=true
            stackidx=player:get_wield_index()
            gotacompass=true
        else
            --check to see if compass is in active inventory
            if player:get_inventory() then
                --is there a way to only check the activewidth items instead of entire list?
                --problem being that arrays are not sorted in lua
                for i,stack in ipairs(player:get_inventory():get_list("main")) do
                    if i<=activewidth and string.sub(stack:get_name(), 0, 12) == "realcompass:" then
                        activeinv=stack  --store the stack so we can update it later with new image
                        stackidx=i --store the index so we can add image at correct location
                        gotacompass=true
                        break
                    end --if i<=activewidth
                end --for loop
            end -- get_inventory
        end --if wielded else

        --dont mess with the rest of this if they don't have a compass
    --update to remove legacy get_look_yaw function
        if gotacompass then
            local dir = player:get_look_horizontal()
            local angle_relative = math.deg(dir)
            local compass_image = math.floor((angle_relative/30) + 0.5)%12

            --update compass image to point at target
            if wielded then
                player:set_wielded_item("realcompass:"..compass_image)
            elseif activeinv then
                player:get_inventory():set_stack("main",stackidx,"realcompass:"..compass_image)
            end --if wielded elsif activin
        end --if gotacompass
    end --for i,player in ipairs(players)
end) -- register_globalstep

local images = {
        "realcompass_0.png",
        "realcompass_1.png",
        "realcompass_2.png",
        "realcompass_3.png",
        "realcompass_4.png",
        "realcompass_5.png",
        "realcompass_6.png",
        "realcompass_7.png",
        "realcompass_8.png",
        "realcompass_9.png",
        "realcompass_10.png",
        "realcompass_11.png",
}

local i
for i,img in ipairs(images) do
        local inv = 1
        if i == 1 then
                inv = 0
        end
        minetest.register_tool("realcompass:"..(i-1), {
                description = "Real Compass",
                inventory_image = img,
                wield_image = img,
                groups = {not_in_creative_inventory=inv}
        })
end

minetest.register_craft({
        output = 'realcompass:1',
        recipe = {
                {'', 'default:steel_ingot', ''},
                {'default:copper_ingot', 'default:mese_crystal_fragment', 'default:copper_ingot'},
                {'', 'default:copper_ingot', ''}
        }
})

