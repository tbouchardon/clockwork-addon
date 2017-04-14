function ksuto.initLatitude()

    -- ksuto.printDebug("function ksuto.initLatitude(")

    ksuto.coord_lati_1 = ksuto.createDot("coord_lati_1", 13, -8)
    ksuto.coord_lati_2 = ksuto.createDot("coord_lati_2", 12, -8)
    ksuto.coord_lati_4 = ksuto.createDot("coord_lati_4", 11, -8)
    ksuto.coord_lati_8 = ksuto.createDot("coord_lati_8", 10, -8)
    ksuto.coord_lati_16 = ksuto.createDot("coord_lati_16", 9, -8)
    ksuto.coord_lati_32 = ksuto.createDot("coord_lati_32", 8, -8)
    ksuto.coord_lati_64 = ksuto.createDot("coord_lati_64", 7, -8)
    ksuto.coord_lati_128 = ksuto.createDot("coord_lati_128", 6, -8)
    ksuto.coord_lati_256 = ksuto.createDot("coord_lati_256", 5, -8)
    ksuto.coord_lati_512 = ksuto.createDot("coord_lati_512", 4, -8)
    ksuto.coord_lati_1024 = ksuto.createDot("coord_lati_1024", 3, -8)
    ksuto.coord_lati_2048 = ksuto.createDot("coord_lati_2048", 2, -8)

    ksuto.coord_lati_4096 = ksuto.createDot("coord_lati_4096", 13, -7)
    ksuto.coord_lati_8192 = ksuto.createDot("coord_lati_8192", 12, -7)
    ksuto.coord_lati_16384 = ksuto.createDot("coord_lati_16384", 11, -7)
    ksuto.coord_lati_32768 = ksuto.createDot("coord_lati_32768", 10, -7)
    ksuto.coord_lati_65536 = ksuto.createDot("coord_lati_65536", 9, -7)
    ksuto.coord_lati_131072 = ksuto.createDot("coord_lati_131072", 8, -7)
    ksuto.coord_lati_262144 = ksuto.createDot("coord_lati_262144", 7, -7)
    ksuto.coord_lati_524288 = ksuto.createDot("coord_lati_524288", 6, -7)
end

function ksuto.initLongitude()

    -- ksuto.printDebug("function ksuto.initLongitude(")

    ksuto.coord_long_1 = ksuto.createDot("coord_long_1", 13, -11)
    ksuto.coord_long_2 = ksuto.createDot("coord_long_2", 12, -11)
    ksuto.coord_long_4 = ksuto.createDot("coord_long_4", 11, -11)
    ksuto.coord_long_8 = ksuto.createDot("coord_long_8", 10, -11)
    ksuto.coord_long_16 = ksuto.createDot("coord_long_16", 9, -11)
    ksuto.coord_long_32 = ksuto.createDot("coord_long_32", 8, -11)
    ksuto.coord_long_64 = ksuto.createDot("coord_long_64", 7, -11)
    ksuto.coord_long_128 = ksuto.createDot("coord_long_128", 6, -11)
    ksuto.coord_long_256 = ksuto.createDot("coord_long_256", 5, -11)
    ksuto.coord_long_512 = ksuto.createDot("coord_long_512", 4, -11)
    ksuto.coord_long_1024 = ksuto.createDot("coord_long_1024", 3, -11)
    ksuto.coord_long_2048 = ksuto.createDot("coord_long_2048", 2, -11)

    ksuto.coord_long_4096 = ksuto.createDot("coord_long_4096", 13, -10)
    ksuto.coord_long_8192 = ksuto.createDot("coord_long_8192", 12, -10)
    ksuto.coord_long_16384 = ksuto.createDot("coord_long_16384", 11, -10)
    ksuto.coord_long_32768 = ksuto.createDot("coord_long_32768", 10, -10)
    ksuto.coord_long_65536 = ksuto.createDot("coord_long_65536", 9, -10)
    ksuto.coord_long_131072 = ksuto.createDot("coord_long_131072", 8, -10)
    ksuto.coord_long_262144 = ksuto.createDot("coord_long_262144", 7, -10)
    ksuto.coord_long_524288 = ksuto.createDot("coord_long_524288", 6, -10)
end

function ksuto.initCoords()

    -- ksuto.printDebug("function ksuto.initCoords(")

    ksuto.initLatitude()
    ksuto.initLongitude()
end

function ksuto.updateLatitude(coordinates)

    -- ksuto.printDebug("function ksuto.updateLatitude(" .. tostring(coordinates))

    if coordinates - 524288 >= 0 then
        coordinates = coordinates - 524288;
        ksuto.coord_lati_524288.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_lati_524288.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 262144 >= 0 then
        coordinates = coordinates - 262144;
        ksuto.coord_lati_262144.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_lati_262144.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 131072 >= 0 then
        coordinates = coordinates - 131072;
        ksuto.coord_lati_131072.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_lati_131072.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 65536 >= 0 then
        coordinates = coordinates - 65536;
        ksuto.coord_lati_65536.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_lati_65536.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 32768 >= 0 then
        coordinates = coordinates - 32768;
        ksuto.coord_lati_32768.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_lati_32768.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 16384 >= 0 then
        coordinates = coordinates - 16384;
        ksuto.coord_lati_16384.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_lati_16384.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 8192 >= 0 then
        coordinates = coordinates - 8192;
        ksuto.coord_lati_8192.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_lati_8192.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 4096 >= 0 then
        coordinates = coordinates - 4096;
        ksuto.coord_lati_4096.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_lati_4096.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 2048 >= 0 then
        coordinates = coordinates - 2048;
        ksuto.coord_lati_2048.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_lati_2048.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 1024 >= 0 then
        coordinates = coordinates - 1024;
        ksuto.coord_lati_1024.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_lati_1024.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 512 >= 0 then
        coordinates = coordinates - 512;
        ksuto.coord_lati_512.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_lati_512.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 256 >= 0 then
        coordinates = coordinates - 256;
        ksuto.coord_lati_256.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_lati_256.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 128 >= 0 then
        coordinates = coordinates - 128;
        ksuto.coord_lati_128.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_lati_128.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 64 >= 0 then
        coordinates = coordinates - 64;
        ksuto.coord_lati_64.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_lati_64.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 32 >= 0 then
        coordinates = coordinates - 32;
        ksuto.coord_lati_32.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_lati_32.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 16 >= 0 then
        coordinates = coordinates - 16;
        ksuto.coord_lati_16.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_lati_16.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 8 >= 0 then
        coordinates = coordinates - 8;
        ksuto.coord_lati_8.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_lati_8.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 4 >= 0 then
        coordinates = coordinates - 4;
        ksuto.coord_lati_4.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_lati_4.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 2 >= 0 then
        coordinates = coordinates - 2;
        ksuto.coord_lati_2.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_lati_2.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 1 >= 0 then
        coordinates = coordinates - 1;
        ksuto.coord_lati_1.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_lati_1.texture:SetTexture(0, 0, 0, 1)
    end
end

function ksuto.updateLongitude(coordinates)

    -- ksuto.printDebug("function ksuto.updateLongitude(" .. tostring(coordinates))

    if coordinates - 524288 >= 0 then
        coordinates = coordinates - 524288;
        ksuto.coord_long_524288.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_long_524288.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 262144 >= 0 then
        coordinates = coordinates - 262144;
        ksuto.coord_long_262144.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_long_262144.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 131072 >= 0 then
        coordinates = coordinates - 131072;
        ksuto.coord_long_131072.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_long_131072.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 65536 >= 0 then
        coordinates = coordinates - 65536;
        ksuto.coord_long_65536.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_long_65536.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 32768 >= 0 then
        coordinates = coordinates - 32768;
        ksuto.coord_long_32768.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_long_32768.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 16384 >= 0 then
        coordinates = coordinates - 16384;
        ksuto.coord_long_16384.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_long_16384.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 8192 >= 0 then
        coordinates = coordinates - 8192;
        ksuto.coord_long_8192.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_long_8192.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 4096 >= 0 then
        coordinates = coordinates - 4096;
        ksuto.coord_long_4096.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_long_4096.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 2048 >= 0 then
        coordinates = coordinates - 2048;
        ksuto.coord_long_2048.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_long_2048.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 1024 >= 0 then
        coordinates = coordinates - 1024;
        ksuto.coord_long_1024.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_long_1024.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 512 >= 0 then
        coordinates = coordinates - 512;
        ksuto.coord_long_512.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_long_512.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 256 >= 0 then
        coordinates = coordinates - 256;
        ksuto.coord_long_256.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_long_256.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 128 >= 0 then
        coordinates = coordinates - 128;
        ksuto.coord_long_128.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_long_128.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 64 >= 0 then
        coordinates = coordinates - 64;
        ksuto.coord_long_64.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_long_64.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 32 >= 0 then
        coordinates = coordinates - 32;
        ksuto.coord_long_32.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_long_32.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 16 >= 0 then
        coordinates = coordinates - 16;
        ksuto.coord_long_16.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_long_16.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 8 >= 0 then
        coordinates = coordinates - 8;
        ksuto.coord_long_8.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_long_8.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 4 >= 0 then
        coordinates = coordinates - 4;
        ksuto.coord_long_4.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_long_4.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 2 >= 0 then
        coordinates = coordinates - 2;
        ksuto.coord_long_2.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_long_2.texture:SetTexture(0, 0, 0, 1)
    end

    if coordinates - 1 >= 0 then
        coordinates = coordinates - 1;
        ksuto.coord_long_1.texture:SetTexture(1, 1, 1, 1)
    else ksuto.coord_long_1.texture:SetTexture(0, 0, 0, 1)
    end
end

function ksuto.updatePositionCoordinates()

    -- ksuto.printDebug("function ksuto.updatePositionCoordinates(")

    --ksuto.printDebug("ksuto.updatePositionCoordinates()")

    local posX, posY = GetPlayerMapPosition("player");

    posX = posX * 1000000
    posY = posY * 1000000

    ksuto.updateLatitude(posX)
    ksuto.updateLongitude(posY)
end

function ksuto.updatePositionFromCoordinates(coordinates)

    -- ksuto.printDebug("function ksuto.updatePositionFromCoordinates(" .. tostring(coordinates))

    local posX = string.sub(coordinates, 1, 2) .. string.sub(coordinates, 4, 5) .. "00"
    local posY = string.sub(coordinates, 7, 8) .. string.sub(coordinates, 10, 11) .. "00"

    posX = tonumber(posX)
    posY = tonumber(posY)

    ksuto.updateLatitude(posX)
    ksuto.updateLongitude(posY)
end