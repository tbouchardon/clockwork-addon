function Clockwork:initLatitude()
    -- Clockwork.log.debug("function Clockwork.initLatitude(")

    self.coord_lati_1 = self:createDot("coord_lati_1", 13, -8)
    self.coord_lati_2 = self:createDot("coord_lati_2", 12, -8)
    self.coord_lati_4 = self:createDot("coord_lati_4", 11, -8)
    self.coord_lati_8 = self:createDot("coord_lati_8", 10, -8)
    self.coord_lati_16 = self:createDot("coord_lati_16", 9, -8)
    self.coord_lati_32 = self:createDot("coord_lati_32", 8, -8)
    self.coord_lati_64 = self:createDot("coord_lati_64", 7, -8)
    self.coord_lati_128 = self:createDot("coord_lati_128", 6, -8)
    self.coord_lati_256 = self:createDot("coord_lati_256", 5, -8)
    self.coord_lati_512 = self:createDot("coord_lati_512", 4, -8)
    self.coord_lati_1024 = self:createDot("coord_lati_1024", 3, -8)
    self.coord_lati_2048 = self:createDot("coord_lati_2048", 2, -8)

    self.coord_lati_4096 = self:createDot("coord_lati_4096", 13, -7)
    self.coord_lati_8192 = self:createDot("coord_lati_8192", 12, -7)
    self.coord_lati_16384 = self:createDot("coord_lati_16384", 11, -7)
    self.coord_lati_32768 = self:createDot("coord_lati_32768", 10, -7)
    self.coord_lati_65536 = self:createDot("coord_lati_65536", 9, -7)
    self.coord_lati_131072 = self:createDot("coord_lati_131072", 8, -7)
    self.coord_lati_262144 = self:createDot("coord_lati_262144", 7, -7)
    self.coord_lati_524288 = self:createDot("coord_lati_524288", 6, -7)
end

function Clockwork:initLongitude()
    -- Clockwork.log.debug("function Clockwork.initLongitude(")

    self.coord_long_1 = self:createDot("coord_long_1", 13, -11)
    self.coord_long_2 = self:createDot("coord_long_2", 12, -11)
    self.coord_long_4 = self:createDot("coord_long_4", 11, -11)
    self.coord_long_8 = self:createDot("coord_long_8", 10, -11)
    self.coord_long_16 = self:createDot("coord_long_16", 9, -11)
    self.coord_long_32 = self:createDot("coord_long_32", 8, -11)
    self.coord_long_64 = self:createDot("coord_long_64", 7, -11)
    self.coord_long_128 = self:createDot("coord_long_128", 6, -11)
    self.coord_long_256 = self:createDot("coord_long_256", 5, -11)
    self.coord_long_512 = self:createDot("coord_long_512", 4, -11)
    self.coord_long_1024 = self:createDot("coord_long_1024", 3, -11)
    self.coord_long_2048 = self:createDot("coord_long_2048", 2, -11)

    self.coord_long_4096 = self:createDot("coord_long_4096", 13, -10)
    self.coord_long_8192 = self:createDot("coord_long_8192", 12, -10)
    self.coord_long_16384 = self:createDot("coord_long_16384", 11, -10)
    self.coord_long_32768 = self:createDot("coord_long_32768", 10, -10)
    self.coord_long_65536 = self:createDot("coord_long_65536", 9, -10)
    self.coord_long_131072 = self:createDot("coord_long_131072", 8, -10)
    self.coord_long_262144 = self:createDot("coord_long_262144", 7, -10)
    self.coord_long_524288 = self:createDot("coord_long_524288", 6, -10)
end

function Clockwork:initCoords()
    -- Clockwork.log.debug("function Clockwork.initCoords(")

    self:initLatitude()
    self:initLongitude()
end

function Clockwork:updateLatitude(coordinates)
    -- Clockwork.log.debug("function Clockwork.updateLatitude(" .. tostring(coordinates))

    if coordinates - 524288 >= 0 then
        coordinates = coordinates - 524288;
        self.coord_lati_524288.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_lati_524288.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 262144 >= 0 then
        coordinates = coordinates - 262144;
        self.coord_lati_262144.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_lati_262144.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 131072 >= 0 then
        coordinates = coordinates - 131072;
        self.coord_lati_131072.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_lati_131072.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 65536 >= 0 then
        coordinates = coordinates - 65536;
        self.coord_lati_65536.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_lati_65536.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 32768 >= 0 then
        coordinates = coordinates - 32768;
        self.coord_lati_32768.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_lati_32768.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 16384 >= 0 then
        coordinates = coordinates - 16384;
        self.coord_lati_16384.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_lati_16384.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 8192 >= 0 then
        coordinates = coordinates - 8192;
        self.coord_lati_8192.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_lati_8192.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 4096 >= 0 then
        coordinates = coordinates - 4096;
        self.coord_lati_4096.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_lati_4096.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 2048 >= 0 then
        coordinates = coordinates - 2048;
        self.coord_lati_2048.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_lati_2048.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 1024 >= 0 then
        coordinates = coordinates - 1024;
        self.coord_lati_1024.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_lati_1024.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 512 >= 0 then
        coordinates = coordinates - 512;
        self.coord_lati_512.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_lati_512.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 256 >= 0 then
        coordinates = coordinates - 256;
        self.coord_lati_256.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_lati_256.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 128 >= 0 then
        coordinates = coordinates - 128;
        self.coord_lati_128.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_lati_128.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 64 >= 0 then
        coordinates = coordinates - 64;
        self.coord_lati_64.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_lati_64.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 32 >= 0 then
        coordinates = coordinates - 32;
        self.coord_lati_32.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_lati_32.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 16 >= 0 then
        coordinates = coordinates - 16;
        self.coord_lati_16.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_lati_16.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 8 >= 0 then
        coordinates = coordinates - 8;
        self.coord_lati_8.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_lati_8.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 4 >= 0 then
        coordinates = coordinates - 4;
        self.coord_lati_4.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_lati_4.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 2 >= 0 then
        coordinates = coordinates - 2;
        self.coord_lati_2.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_lati_2.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 1 >= 0 then
        coordinates = coordinates - 1;
        self.coord_lati_1.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_lati_1.texture:SetColorTexture(0, 0, 0, 1)
    end
end

function Clockwork:updateLongitude(coordinates)
    -- Clockwork.log.debug("function Clockwork.updateLongitude(" .. tostring(coordinates))

    if coordinates - 524288 >= 0 then
        coordinates = coordinates - 524288;
        self.coord_long_524288.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_long_524288.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 262144 >= 0 then
        coordinates = coordinates - 262144;
        self.coord_long_262144.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_long_262144.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 131072 >= 0 then
        coordinates = coordinates - 131072;
        self.coord_long_131072.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_long_131072.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 65536 >= 0 then
        coordinates = coordinates - 65536;
        self.coord_long_65536.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_long_65536.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 32768 >= 0 then
        coordinates = coordinates - 32768;
        self.coord_long_32768.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_long_32768.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 16384 >= 0 then
        coordinates = coordinates - 16384;
        self.coord_long_16384.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_long_16384.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 8192 >= 0 then
        coordinates = coordinates - 8192;
        self.coord_long_8192.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_long_8192.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 4096 >= 0 then
        coordinates = coordinates - 4096;
        self.coord_long_4096.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_long_4096.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 2048 >= 0 then
        coordinates = coordinates - 2048;
        self.coord_long_2048.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_long_2048.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 1024 >= 0 then
        coordinates = coordinates - 1024;
        self.coord_long_1024.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_long_1024.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 512 >= 0 then
        coordinates = coordinates - 512;
        self.coord_long_512.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_long_512.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 256 >= 0 then
        coordinates = coordinates - 256;
        self.coord_long_256.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_long_256.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 128 >= 0 then
        coordinates = coordinates - 128;
        self.coord_long_128.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_long_128.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 64 >= 0 then
        coordinates = coordinates - 64;
        self.coord_long_64.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_long_64.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 32 >= 0 then
        coordinates = coordinates - 32;
        self.coord_long_32.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_long_32.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 16 >= 0 then
        coordinates = coordinates - 16;
        self.coord_long_16.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_long_16.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 8 >= 0 then
        coordinates = coordinates - 8;
        self.coord_long_8.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_long_8.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 4 >= 0 then
        coordinates = coordinates - 4;
        self.coord_long_4.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_long_4.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 2 >= 0 then
        coordinates = coordinates - 2;
        self.coord_long_2.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_long_2.texture:SetColorTexture(0, 0, 0, 1)
    end

    if coordinates - 1 >= 0 then
        coordinates = coordinates - 1;
        self.coord_long_1.texture:SetColorTexture(1, 1, 1, 1)
    else
        self.coord_long_1.texture:SetColorTexture(0, 0, 0, 1)
    end
end

function Clockwork:updatePositionCoordinates()
    -- Clockwork.log.debug("function Clockwork.updatePositionCoordinates(")

    --Clockwork.log.debug("Clockwork.updatePositionCoordinates()")
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
        posX = self.player.position.posX
        posY = self.player.position.posY
    end

    --Clockwork.log.debug(posX)
    --Clockwork.log.debug(posY)

    posX = posX * 1000000
    posY = posY * 1000000

    self.player.isMoving = self.player.position.posX ~= posX or self.player.position.posY ~= posY

    self.player.position.posX = posX
    self.player.position.posY = posY

    self:updateLatitude(posX)
    self:updateLongitude(posY)
end

function Clockwork:updatePositionFromCoordinates(coordinates)
    -- Clockwork.log.debug("function Clockwork.updatePositionFromCoordinates(" .. tostring(coordinates))

    local posX = string.sub(coordinates, 1, 2) .. string.sub(coordinates, 4, 5) .. "00"
    local posY = string.sub(coordinates, 7, 8) .. string.sub(coordinates, 10, 11) .. "00"

    self:updateLatitude(tonumber(posX))
    self:updateLongitude(tonumber(posY))
end
