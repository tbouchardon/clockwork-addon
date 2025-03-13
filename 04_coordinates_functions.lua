function Clockwork.initLatitude()
    -- Clockwork.printDebug("function Clockwork.initLatitude(")

    Clockwork.coord_lati_1 = Clockwork.createDot("coord_lati_1", 13, -8)
    Clockwork.coord_lati_2 = Clockwork.createDot("coord_lati_2", 12, -8)
    Clockwork.coord_lati_4 = Clockwork.createDot("coord_lati_4", 11, -8)
    Clockwork.coord_lati_8 = Clockwork.createDot("coord_lati_8", 10, -8)
    Clockwork.coord_lati_16 = Clockwork.createDot("coord_lati_16", 9, -8)
    Clockwork.coord_lati_32 = Clockwork.createDot("coord_lati_32", 8, -8)
    Clockwork.coord_lati_64 = Clockwork.createDot("coord_lati_64", 7, -8)
    Clockwork.coord_lati_128 = Clockwork.createDot("coord_lati_128", 6, -8)
    Clockwork.coord_lati_256 = Clockwork.createDot("coord_lati_256", 5, -8)
    Clockwork.coord_lati_512 = Clockwork.createDot("coord_lati_512", 4, -8)
    Clockwork.coord_lati_1024 = Clockwork.createDot("coord_lati_1024", 3, -8)
    Clockwork.coord_lati_2048 = Clockwork.createDot("coord_lati_2048", 2, -8)

    Clockwork.coord_lati_4096 = Clockwork.createDot("coord_lati_4096", 13, -7)
    Clockwork.coord_lati_8192 = Clockwork.createDot("coord_lati_8192", 12, -7)
    Clockwork.coord_lati_16384 = Clockwork.createDot("coord_lati_16384", 11, -7)
    Clockwork.coord_lati_32768 = Clockwork.createDot("coord_lati_32768", 10, -7)
    Clockwork.coord_lati_65536 = Clockwork.createDot("coord_lati_65536", 9, -7)
    Clockwork.coord_lati_131072 = Clockwork.createDot("coord_lati_131072", 8, -7)
    Clockwork.coord_lati_262144 = Clockwork.createDot("coord_lati_262144", 7, -7)
    Clockwork.coord_lati_524288 = Clockwork.createDot("coord_lati_524288", 6, -7)
end

function Clockwork.initLongitude()
    -- Clockwork.printDebug("function Clockwork.initLongitude(")

    Clockwork.coord_long_1 = Clockwork.createDot("coord_long_1", 13, -11)
    Clockwork.coord_long_2 = Clockwork.createDot("coord_long_2", 12, -11)
    Clockwork.coord_long_4 = Clockwork.createDot("coord_long_4", 11, -11)
    Clockwork.coord_long_8 = Clockwork.createDot("coord_long_8", 10, -11)
    Clockwork.coord_long_16 = Clockwork.createDot("coord_long_16", 9, -11)
    Clockwork.coord_long_32 = Clockwork.createDot("coord_long_32", 8, -11)
    Clockwork.coord_long_64 = Clockwork.createDot("coord_long_64", 7, -11)
    Clockwork.coord_long_128 = Clockwork.createDot("coord_long_128", 6, -11)
    Clockwork.coord_long_256 = Clockwork.createDot("coord_long_256", 5, -11)
    Clockwork.coord_long_512 = Clockwork.createDot("coord_long_512", 4, -11)
    Clockwork.coord_long_1024 = Clockwork.createDot("coord_long_1024", 3, -11)
    Clockwork.coord_long_2048 = Clockwork.createDot("coord_long_2048", 2, -11)

    Clockwork.coord_long_4096 = Clockwork.createDot("coord_long_4096", 13, -10)
    Clockwork.coord_long_8192 = Clockwork.createDot("coord_long_8192", 12, -10)
    Clockwork.coord_long_16384 = Clockwork.createDot("coord_long_16384", 11, -10)
    Clockwork.coord_long_32768 = Clockwork.createDot("coord_long_32768", 10, -10)
    Clockwork.coord_long_65536 = Clockwork.createDot("coord_long_65536", 9, -10)
    Clockwork.coord_long_131072 = Clockwork.createDot("coord_long_131072", 8, -10)
    Clockwork.coord_long_262144 = Clockwork.createDot("coord_long_262144", 7, -10)
    Clockwork.coord_long_524288 = Clockwork.createDot("coord_long_524288", 6, -10)
end

function Clockwork.initCoords()
    -- Clockwork.printDebug("function Clockwork.initCoords(")

    Clockwork.initLatitude()
    Clockwork.initLongitude()
end

function Clockwork.updateLatitude(coordinates)
    -- Clockwork.printDebug("function Clockwork.updateLatitude(" .. tostring(coordinates))

    if coordinates - 524288 >= 0 then
        coordinates = coordinates - 524288;
        Clockwork.coord_lati_524288.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_lati_524288.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 262144 >= 0 then
        coordinates = coordinates - 262144;
        Clockwork.coord_lati_262144.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_lati_262144.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 131072 >= 0 then
        coordinates = coordinates - 131072;
        Clockwork.coord_lati_131072.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_lati_131072.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 65536 >= 0 then
        coordinates = coordinates - 65536;
        Clockwork.coord_lati_65536.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_lati_65536.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 32768 >= 0 then
        coordinates = coordinates - 32768;
        Clockwork.coord_lati_32768.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_lati_32768.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 16384 >= 0 then
        coordinates = coordinates - 16384;
        Clockwork.coord_lati_16384.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_lati_16384.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 8192 >= 0 then
        coordinates = coordinates - 8192;
        Clockwork.coord_lati_8192.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_lati_8192.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 4096 >= 0 then
        coordinates = coordinates - 4096;
        Clockwork.coord_lati_4096.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_lati_4096.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 2048 >= 0 then
        coordinates = coordinates - 2048;
        Clockwork.coord_lati_2048.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_lati_2048.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 1024 >= 0 then
        coordinates = coordinates - 1024;
        Clockwork.coord_lati_1024.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_lati_1024.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 512 >= 0 then
        coordinates = coordinates - 512;
        Clockwork.coord_lati_512.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_lati_512.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 256 >= 0 then
        coordinates = coordinates - 256;
        Clockwork.coord_lati_256.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_lati_256.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 128 >= 0 then
        coordinates = coordinates - 128;
        Clockwork.coord_lati_128.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_lati_128.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 64 >= 0 then
        coordinates = coordinates - 64;
        Clockwork.coord_lati_64.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_lati_64.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 32 >= 0 then
        coordinates = coordinates - 32;
        Clockwork.coord_lati_32.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_lati_32.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 16 >= 0 then
        coordinates = coordinates - 16;
        Clockwork.coord_lati_16.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_lati_16.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 8 >= 0 then
        coordinates = coordinates - 8;
        Clockwork.coord_lati_8.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_lati_8.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 4 >= 0 then
        coordinates = coordinates - 4;
        Clockwork.coord_lati_4.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_lati_4.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 2 >= 0 then
        coordinates = coordinates - 2;
        Clockwork.coord_lati_2.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_lati_2.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 1 >= 0 then
        coordinates = coordinates - 1;
        Clockwork.coord_lati_1.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_lati_1.texture:SetColorTexture(0, 0, 0, 1)
    end
end

function Clockwork.updateLongitude(coordinates)
    -- Clockwork.printDebug("function Clockwork.updateLongitude(" .. tostring(coordinates))

    if coordinates - 524288 >= 0 then
        coordinates = coordinates - 524288;
        Clockwork.coord_long_524288.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_long_524288.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 262144 >= 0 then
        coordinates = coordinates - 262144;
        Clockwork.coord_long_262144.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_long_262144.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 131072 >= 0 then
        coordinates = coordinates - 131072;
        Clockwork.coord_long_131072.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_long_131072.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 65536 >= 0 then
        coordinates = coordinates - 65536;
        Clockwork.coord_long_65536.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_long_65536.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 32768 >= 0 then
        coordinates = coordinates - 32768;
        Clockwork.coord_long_32768.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_long_32768.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 16384 >= 0 then
        coordinates = coordinates - 16384;
        Clockwork.coord_long_16384.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_long_16384.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 8192 >= 0 then
        coordinates = coordinates - 8192;
        Clockwork.coord_long_8192.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_long_8192.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 4096 >= 0 then
        coordinates = coordinates - 4096;
        Clockwork.coord_long_4096.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_long_4096.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 2048 >= 0 then
        coordinates = coordinates - 2048;
        Clockwork.coord_long_2048.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_long_2048.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 1024 >= 0 then
        coordinates = coordinates - 1024;
        Clockwork.coord_long_1024.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_long_1024.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 512 >= 0 then
        coordinates = coordinates - 512;
        Clockwork.coord_long_512.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_long_512.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 256 >= 0 then
        coordinates = coordinates - 256;
        Clockwork.coord_long_256.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_long_256.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 128 >= 0 then
        coordinates = coordinates - 128;
        Clockwork.coord_long_128.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_long_128.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 64 >= 0 then
        coordinates = coordinates - 64;
        Clockwork.coord_long_64.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_long_64.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 32 >= 0 then
        coordinates = coordinates - 32;
        Clockwork.coord_long_32.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_long_32.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 16 >= 0 then
        coordinates = coordinates - 16;
        Clockwork.coord_long_16.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_long_16.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 8 >= 0 then
        coordinates = coordinates - 8;
        Clockwork.coord_long_8.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_long_8.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 4 >= 0 then
        coordinates = coordinates - 4;
        Clockwork.coord_long_4.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_long_4.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 2 >= 0 then
        coordinates = coordinates - 2;
        Clockwork.coord_long_2.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_long_2.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 1 >= 0 then
        coordinates = coordinates - 1;
        Clockwork.coord_long_1.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.coord_long_1.texture:SetColorTexture(0, 0, 0, 1)
    end
end

function Clockwork.updatePositionCoordinates()
    -- Clockwork.printDebug("function Clockwork.updatePositionCoordinates(")

    --Clockwork.printDebug("Clockwork.updatePositionCoordinates()")
    local map = C_Map.GetBestMapForUnit("player")
    if map == nil then
        return
    end
    local position = C_Map.GetPlayerMapPosition(map, "player");

    local posX
    local posY

    if (position ~= nil) then
        posX = tostring(position["x"])
        posY = tostring(position["y"])
    else
        posX = Clockwork.player.position.posX
        posY = Clockwork.player.position.posY
    end

    --Clockwork.printDebug(posX)
    --Clockwork.printDebug(posY)

    posX = posX * 1000000
    posY = posY * 1000000

    Clockwork.player.isMoving = Clockwork.player.position.posX ~= posX or Clockwork.player.position.posY ~= posY

    Clockwork.player.position.posX = posX
    Clockwork.player.position.posY = posY

    Clockwork.updateLatitude(posX)
    Clockwork.updateLongitude(posY)
end

function Clockwork.updatePositionFromCoordinates(coordinates)
    -- Clockwork.printDebug("function Clockwork.updatePositionFromCoordinates(" .. tostring(coordinates))

    local posX = string.sub(coordinates, 1, 2) .. string.sub(coordinates, 4, 5) .. "00"
    local posY = string.sub(coordinates, 7, 8) .. string.sub(coordinates, 10, 11) .. "00"

    Clockwork.updateLatitude(tonumber(posX))
    Clockwork.updateLongitude(tonumber(posY))
end
