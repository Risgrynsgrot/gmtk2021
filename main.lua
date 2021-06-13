function love.load()
    local RailPiece = {
        myStartX = 0,
        myStartY = 0,
        myEndX = 0,
        myEndY = 0,
        myX = 0,
        myY = 0,
        myImage = nil,
        myConnection = nil
    }
    RailPiece.__index = RailPiece_in
    RailPiece.place = function(self, connection, x, y)
        x = x or 0
        y = y or 0
        self.myX = x + self.myStartX
        self.myY = y + self.myStartY
        if(connection ~= nil) then
            self.myX = self.myX + connection.myX + connection.myEndX
            self.myY = self.myY + connection.myY + connection.myEndY
            self.myConnection = connection
        end
    end
    RailPiece.draw = function(self)
        print(string.format("rail position: %d, %d", self.myX, self.myY))
        love.graphics.draw(self.myImage, self.myX, self.myY)
    end

    print(RailPiece.place)

    Player = {
        mySpeed = 300,
        myX = 0,
        myY = 0,
        myXSize = 100,
        myYSize = 100,
        update = function(self, dt)
            local up = boolToNumber(love.keyboard.isDown("w"))
            local down = boolToNumber(love.keyboard.isDown("s"))
            local left = boolToNumber(love.keyboard.isDown("a"))
            local right = boolToNumber(love.keyboard.isDown("d"))
            local xDir = right - left
            local yDir = down - up

            self.myX = self.myX + xDir * self.mySpeed * dt
            self.myY = self.myY + yDir * self.mySpeed * dt
        end,
        draw = function(self)
            love.graphics.rectangle("fill", self.myX, self.myY, self.myXSize, self.myYSize)
        end
    }
    Player.__index = Player

    rng = love.math.newRandomGenerator()
    myPlayer = Player

    straightImage = love.graphics.newImage("straight.png")
    rightDownImage = love.graphics.newImage("rightdown.png")
    rightDownImageWidth, rightDownImageHeight = rightDownImage:getDimensions()
    straightImageWidth, rightDownImageHeight = straightImage:getDimensions()


    rightDownRail = setmetatable({}, RailPiece)
    print(rightDownRail.place)
    rightDownRail.myImage = rightDownImage
    rightDownRail.myStartX = rightDownImageWidth
    rightDownRail.myStartY = rightDownImageHeight / 2
    rightDownRail.myEndX = rightDownImageWidth / 2
    rightDownRail.myEndY = rightDownImageHeight

    straightRail = setmetatable({}, RailPiece)
    print(straightRail.place)
    straightRail.myImage = straightImage
    straightRail.myStartX = straightImageWidth / 2
    straightRail.myStartY = 0
    straightRail.myEndX = straightImageWidth / 2
    straightRail.myEndY = straightImageHeight
    print("rail types")
    print(rightDownRail)
    print(straightRail)

    railTypes = {}
    railTypes[1] = straightRail
    railTypes[2] = rightDownRail
    railTypes.count = 2
    print("rail functions")
    print(railTypes[1].place)
    print(railTypes[2].place)

    rails = {}
    rails.count = 100

    for i=1, rails.count do
        rails[i] = getRandomRail()
        if i == 1 then
            print(rails[i].place)
            rails[i]:place(rails[i - 1], 300, 300)
        else
            print(rails[i].place)
            rails[i]:place(rails[i - 1])
        end
    end
end

function getRandomRail()
    print("getrandomrail")
    local index = rng:random(1, railTypes.count)
    print(index)
    local result = railTypes[index]
    return result
end

function love.update(dt)
    myPlayer:update(dt)
end
function love.draw()
    myPlayer:draw()
    love.graphics.print("Hello World", 400, 300)

    for i=1,rails.count do
        rails[i]:draw()
    end
end

function boolToNumber(value)
    return value and 1 or 0
end


