function clockWork.initLatitude()

    -- clockWork.printDebug("function clockWork.initLatitude(")

    clockWork.coord_lati_1 = clockWork.createDot("coord_lati_1", 13, -8)
    clockWork.coord_lati_2 = clockWork.createDot("coord_lati_2", 12, -8)
    clockWork.coord_lati_4 = clockWork.createDot("coord_lati_4", 11, -8)
    clockWork.coord_lati_8 = clockWork.createDot("coord_lati_8", 10, -8)
    clockWork.coord_lati_16 = clockWork.createDot("coord_lati_16", 9, -8)
    clockWork.coord_lati_32 = clockWork.createDot("coord_lati_32", 8, -8)
    clockWork.coord_lati_64 = clockWork.createDot("coord_lati_64", 7, -8)
    clockWork.coord_lati_128 = clockWork.createDot("coord_lati_128", 6, -8)
    clockWork.coord_lati_256 = clockWork.createDot("coord_lati_256", 5, -8)
    clockWork.coord_lati_512 = clockWork.createDot("coord_lati_512", 4, -8)
    clockWork.coord_lati_1024 = clockWork.createDot("coord_lati_1024", 3, -8)
    clockWork.coord_lati_2048 = clockWork.createDot("coord_lati_2048", 2, -8)

    clockWork.coord_lati_4096 = clockWork.createDot("coord_lati_4096", 13, -7)
    clockWork.coord_lati_8192 = clockWork.createDot("coord_lati_8192", 12, -7)
    clockWork.coord_lati_16384 = clockWork.createDot("coord_lati_16384", 11, -7)
    clockWork.coord_lati_32768 = clockWork.createDot("coord_lati_32768", 10, -7)
    clockWork.coord_lati_65536 = clockWork.createDot("coord_lati_65536", 9, -7)
    clockWork.coord_lati_131072 = clockWork.createDot("coord_lati_131072", 8, -7)
    clockWork.coord_lati_262144 = clockWork.createDot("coord_lati_262144", 7, -7)
    clockWork.coord_lati_524288 = clockWork.createDot("coord_lati_524288", 6, -7)
end

function clockWork.initLongitude()

    -- clockWork.printDebug("function clockWork.initLongitude(")

    clockWork.coord_long_1 = clockWork.createDot("coord_long_1", 13, -11)
    clockWork.coord_long_2 = clockWork.createDot("coord_long_2", 12, -11)
    clockWork.coord_long_4 = clockWork.createDot("coord_long_4", 11, -11)
    clockWork.coord_long_8 = clockWork.createDot("coord_long_8", 10, -11)
    clockWork.coord_long_16 = clockWork.createDot("coord_long_16", 9, -11)
    clockWork.coord_long_32 = clockWork.createDot("coord_long_32", 8, -11)
    clockWork.coord_long_64 = clockWork.createDot("coord_long_64", 7, -11)
    clockWork.coord_long_128 = clockWork.createDot("coord_long_128", 6, -11)
    clockWork.coord_long_256 = clockWork.createDot("coord_long_256", 5, -11)
    clockWork.coord_long_512 = clockWork.createDot("coord_long_512", 4, -11)
    clockWork.coord_long_1024 = clockWork.createDot("coord_long_1024", 3, -11)
    clockWork.coord_long_2048 = clockWork.createDot("coord_long_2048", 2, -11)

    clockWork.coord_long_4096 = clockWork.createDot("coord_long_4096", 13, -10)
    clockWork.coord_long_8192 = clockWork.createDot("coord_long_8192", 12, -10)
    clockWork.coord_long_16384 = clockWork.createDot("coord_long_16384", 11, -10)
    clockWork.coord_long_32768 = clockWork.createDot("coord_long_32768", 10, -10)
    clockWork.coord_long_65536 = clockWork.createDot("coord_long_65536", 9, -10)
    clockWork.coord_long_131072 = clockWork.createDot("coord_long_131072", 8, -10)
    clockWork.coord_long_262144 = clockWork.createDot("coord_long_262144", 7, -10)
    clockWork.coord_long_524288 = clockWork.createDot("coord_long_524288", 6, -10)
end

function clockWork.initCoords()

    -- clockWork.printDebug("function clockWork.initCoords(")

    clockWork.initLatitude()
    clockWork.initLongitude()
end

function clockWork.updateLatitude(coordinates)

    -- clockWork.printDebug("function clockWork.updateLatitude(" .. tostring(coordinates))

    if coordinates - 524288 >= 0 then
        coordinates = coordinates - 524288;
        clockWork.coord_lati_524288.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_lati_524288.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 262144 >= 0 then
        coordinates = coordinates - 262144;
        clockWork.coord_lati_262144.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_lati_262144.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 131072 >= 0 then
        coordinates = coordinates - 131072;
        clockWork.coord_lati_131072.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_lati_131072.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 65536 >= 0 then
        coordinates = coordinates - 65536;
        clockWork.coord_lati_65536.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_lati_65536.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 32768 >= 0 then
        coordinates = coordinates - 32768;
        clockWork.coord_lati_32768.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_lati_32768.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 16384 >= 0 then
        coordinates = coordinates - 16384;
        clockWork.coord_lati_16384.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_lati_16384.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 8192 >= 0 then
        coordinates = coordinates - 8192;
        clockWork.coord_lati_8192.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_lati_8192.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 4096 >= 0 then
        coordinates = coordinates - 4096;
        clockWork.coord_lati_4096.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_lati_4096.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 2048 >= 0 then
        coordinates = coordinates - 2048;
        clockWork.coord_lati_2048.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_lati_2048.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 1024 >= 0 then
        coordinates = coordinates - 1024;
        clockWork.coord_lati_1024.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_lati_1024.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 512 >= 0 then
        coordinates = coordinates - 512;
        clockWork.coord_lati_512.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_lati_512.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 256 >= 0 then
        coordinates = coordinates - 256;
        clockWork.coord_lati_256.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_lati_256.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 128 >= 0 then
        coordinates = coordinates - 128;
        clockWork.coord_lati_128.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_lati_128.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 64 >= 0 then
        coordinates = coordinates - 64;
        clockWork.coord_lati_64.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_lati_64.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 32 >= 0 then
        coordinates = coordinates - 32;
        clockWork.coord_lati_32.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_lati_32.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 16 >= 0 then
        coordinates = coordinates - 16;
        clockWork.coord_lati_16.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_lati_16.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 8 >= 0 then
        coordinates = coordinates - 8;
        clockWork.coord_lati_8.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_lati_8.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 4 >= 0 then
        coordinates = coordinates - 4;
        clockWork.coord_lati_4.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_lati_4.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 2 >= 0 then
        coordinates = coordinates - 2;
        clockWork.coord_lati_2.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_lati_2.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 1 >= 0 then
        coordinates = coordinates - 1;
        clockWork.coord_lati_1.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_lati_1.texture:SetColorTexture(0, 0, 0, 1)
    end
end

function clockWork.updateLongitude(coordinates)

    -- clockWork.printDebug("function clockWork.updateLongitude(" .. tostring(coordinates))

    if coordinates - 524288 >= 0 then
        coordinates = coordinates - 524288;
        clockWork.coord_long_524288.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_long_524288.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 262144 >= 0 then
        coordinates = coordinates - 262144;
        clockWork.coord_long_262144.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_long_262144.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 131072 >= 0 then
        coordinates = coordinates - 131072;
        clockWork.coord_long_131072.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_long_131072.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 65536 >= 0 then
        coordinates = coordinates - 65536;
        clockWork.coord_long_65536.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_long_65536.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 32768 >= 0 then
        coordinates = coordinates - 32768;
        clockWork.coord_long_32768.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_long_32768.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 16384 >= 0 then
        coordinates = coordinates - 16384;
        clockWork.coord_long_16384.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_long_16384.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 8192 >= 0 then
        coordinates = coordinates - 8192;
        clockWork.coord_long_8192.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_long_8192.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 4096 >= 0 then
        coordinates = coordinates - 4096;
        clockWork.coord_long_4096.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_long_4096.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 2048 >= 0 then
        coordinates = coordinates - 2048;
        clockWork.coord_long_2048.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_long_2048.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 1024 >= 0 then
        coordinates = coordinates - 1024;
        clockWork.coord_long_1024.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_long_1024.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 512 >= 0 then
        coordinates = coordinates - 512;
        clockWork.coord_long_512.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_long_512.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 256 >= 0 then
        coordinates = coordinates - 256;
        clockWork.coord_long_256.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_long_256.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 128 >= 0 then
        coordinates = coordinates - 128;
        clockWork.coord_long_128.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_long_128.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 64 >= 0 then
        coordinates = coordinates - 64;
        clockWork.coord_long_64.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_long_64.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 32 >= 0 then
        coordinates = coordinates - 32;
        clockWork.coord_long_32.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_long_32.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 16 >= 0 then
        coordinates = coordinates - 16;
        clockWork.coord_long_16.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_long_16.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 8 >= 0 then
        coordinates = coordinates - 8;
        clockWork.coord_long_8.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_long_8.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 4 >= 0 then
        coordinates = coordinates - 4;
        clockWork.coord_long_4.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_long_4.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 2 >= 0 then
        coordinates = coordinates - 2;
        clockWork.coord_long_2.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_long_2.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 1 >= 0 then
        coordinates = coordinates - 1;
        clockWork.coord_long_1.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.coord_long_1.texture:SetColorTexture(0, 0, 0, 1)
    end
end

function clockWork.updatePositionCoordinates()

    -- clockWork.printDebug("function clockWork.updatePositionCoordinates(")

    --clockWork.printDebug("clockWork.updatePositionCoordinates()")
    local map = C_Map.GetBestMapForUnit("player")
    local position = C_Map.GetPlayerMapPosition(map, "player");

    local posX
    local posY

    if (position ~= nil) then
        posX = tostring(position["x"])
        posY = tostring(position["y"])
    else
        posX = clockWork.player.position.posX
        posY = clockWork.player.position.posY
    end

    --clockWork.printDebug(posX)
    --clockWork.printDebug(posY)

    posX = posX * 1000000
    posY = posY * 1000000

    clockWork.player.isMoving = clockWork.player.position.posX ~= posX or clockWork.player.position.posY ~= posY

    clockWork.player.position.posX = posX
    clockWork.player.position.posY = posY

    clockWork.updateLatitude(posX)
    clockWork.updateLongitude(posY)
end

function clockWork.updatePositionFromCoordinates(coordinates)

    -- clockWork.printDebug("function clockWork.updatePositionFromCoordinates(" .. tostring(coordinates))

    local posX = string.sub(coordinates, 1, 2) .. string.sub(coordinates, 4, 5) .. "00"
    local posY = string.sub(coordinates, 7, 8) .. string.sub(coordinates, 10, 11) .. "00"

    posX = tonumber(posX)
    posY = tonumber(posY)

    clockWork.updateLatitude(posX)
    clockWork.updateLongitude(posY)
end