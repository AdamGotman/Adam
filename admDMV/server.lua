local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","admDMV")
vRPC = Tunnel.getInterface("admDMV","admDMV")
vRPd = {}
Tunnel.bindInterface("admDMV",vRPd)
Proxy.addInterface("admDMV",vRPd)
-- backend u nu a fost scris de mine
local InDrive = {}

local AllCoords = {
    NormalCoords = {
        {497.00674438477,-1066.9968261719,28.629110336304, false},
        {497.35360717773,-1114.8674316406,29.299428939819, true},
        {421.68716430664,-1129.2751464844,29.414939880371, true},
        {332.31930541992,-1132.0993652344,29.457851409912, false},
        {283.76245117188,-1130.5377197266,29.425590515137, false},
        {237.27124023438,-1128.8990478516,29.305522918701, true},
        {206.42422485352,-1166.8842773438,29.356512069702, false},
        {212.75025939941,-1226.8088378906,29.361232757568, false},
        {213.09156799316,-1269.6158447266,29.354290008545, true},
        {185.74633789062,-1337.3812255859,29.322595596313, false},
        {164.74044799805,-1371.6650390625,29.349742889404, true},
        {129.5658416748,-1420.7673339844,29.341485977173, false},
        {76.106422424316,-1487.2490234375,29.341924667358, true},
        {92.74681854248,-1533.8260498047,29.33424949646, false},
        {139.82830810547,-1573.654296875,29.325805664062, false},
        {210.08546447754,-1579.4735107422,29.341779708862, false},
        {255.29835510254,-1554.6733398438,29.338182449341, false},
        {302.15502929688,-1528.8236083984,29.226493835449, true},
        {304.31378173828,-1487.1928710938,29.287857055664, false},
        {256.77880859375,-1448.0487060547,29.297597885132, false},
        {202.0924987793,-1409.859375,29.288751602173, false},
        {187.50543212891,-1371.2232666016,29.292724609375, false},
        {220.42573547363,-1328.1223144531,29.25461769104, false},
        {273.39181518555,-1317.3487548828,29.764738082886, false},
        {325.46597290039,-1321.2242431641,32.089698791504, true},
        {363.24740600586,-1302.1903076172,32.411430358887, false},
        {402.84927368164,-1264.8000488281,32.509693145752, false},
        {486.37329101562,-1261.0122070312,29.348752975464, false},
        {504.18533325195,-1215.5219726562,29.355884552002, true},
        {503.20327758789,-1146.3093261719,29.359996795654, true},
        {479.45745849609,-1119.4133300781,29.298896789551, false}
    }
}

function vRPd.startDMV(type)
    local user_id = vRP.getUserId({source})
    if vRP.getInventoryItemAmount({user_id, 'permis_car'}) >= 1 then
        return vRPclient.notify(source, {"Ai deja permisul pentru masina"})
    else
        if vRP.tryFullPayment({user_id, 1000}) then
            if type == 'car' then
                vRPC.StartSchool(source, {vec3(492.97750854492,-998.16302490234,27.774002075195), AllCoords['NormalCoords'], vec3(484.84582519531,-1102.5083007812,29.200798034668), type})
            end
            InDrive[user_id] = true
            SetPlayerRoutingBucket(source, 25)
        else
            vRPclient.notify(source, {"Nu ai destui bani!"})
        end
    end
end

function vRPd.stopCarRoute()
    local thePlayer = source
    local user_id = vRP.getUserId({thePlayer})
    if InDrive[user_id] then
        InDrive[user_id] = nil
        SetPlayerRoutingBucket(thePlayer, 0)
    end
end

function vRPd.giveDMV(veh)
    local thePlayer = source
    local user_id = vRP.getUserId({thePlayer})
    if InDrive[user_id] then
        vRP.giveInventoryItem({user_id, 'permis_car', 1, false})
        exports.oxmysql:execute("UPDATE vrp_users SET permis='1' WHERE id = @id", {id = user_id}, function()end)
        vRPclient.notify(thePlayer, {"Ai luat cu succes permisul pentru masina"})
        InDrive[user_id] = nil
        SetPlayerRoutingBucket(thePlayer, 0)
    else
        DropPlayer(source, "[admAC] DMV EXPLOIT #999")
    end
end

AddEventHandler("vRP:playerLeave", function(user_id)
    if InDrive[user_id] then
        InDrive[user_id] = nil
    end
end)

print('^1admDMV^2 was loaded with success^0')
