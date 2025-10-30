-- Create a ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create a TextButton
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Toggle Exploit"
toggleButton.Parent = screenGui

-- Define the toggle variable
local isToggled = false

-- Function to toggle the exploit on and off
local function toggleExploit()
    isToggled = not isToggled
    if isToggled then
        print("Exploit toggled ON")
        toggleButton.Text = "Exploit ON"
    else
        print("Exploit toggled OFF")
        toggleButton.Text = "Exploit OFF"
    end
end

-- Connect the toggle function to the button click event
toggleButton.MouseButton1Click:Connect(toggleExploit)

-- List of coin containers to target
local coinContainers = {
    "Mansion2.CoinContainer",
    "Biolab.CoinContainer",
    "Factory.CoinContainer",
    "Hospital3.CoinContainer",
    "Bank2.CoinContainer",
    "House2.CoinContainer",
    "Milbase.CoinContainer",
    "Office3.CoinContainer",
    "Police station.CoinContainer",
    "ResearchFacility.CoinContainer",
    "Workplace.CoinContainer",
    "Christmas InItaly.CoinContainer",
    "Skilodge.CoinContainer",
    "Icecastle.CoinContainer",
    "Trainstation.CoinContainer",
    "Logcabin.CoinContainer",
    "Workshop.CoinContainer",
    "Spaceship.CoinContainer",
    "Vampirescastle.CoinContainer",
    "Barninfection.CoinContainer",
    "Mineshaft.CoinContainer",
    "Farmhouse.CoinContainer",
    "Manor.CoinContainer",
    "Yacht.CoinContainer",
    "Beachresort.CoinContainer"
}

-- Function to glide the character to a target position
local function glideToPosition(targetPosition, duration)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local startPosition = humanoidRootPart.Position
    local startTime = tick()

    local function interpolate(t)
        local elapsedTime = tick() - startTime
        local alpha = math.clamp(elapsedTime / duration, 0, 1)
        local newPosition = startPosition:Lerp(targetPosition, alpha)
        humanoidRootPart.Position = newPosition
    end

    while tick() - startTime < duration do
        interpolate()
        wait()
    end
    humanoidRootPart.Position = targetPosition
end

-- Main loop to move the character
local function moveCharacter()
    if isToggled then
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        -- Variable to store the nearest part and its distance
        local nearestPart = nil
        local shortestDistance = math.huge

        -- Iterate through all specified coin containers
        for _, containerPath in ipairs(coinContainers) do
            local parts
            local success, err = pcall(function()
                parts = workspace:WaitForChild(containerPath):GetChildren()
            end)
            if success then
                for _, part in ipairs(parts) do
                    if part.Name == "Coin_Server" and part:IsA("BasePart") then
                        local distance = (humanoidRootPart.Position - part.Position).magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            nearestPart = part
                        end
                    end
                end
            else
                warn("Failed to access container: " .. containerPath .. " - " .. err)
            end
        end

        -- Glide the character to the nearest part
        if nearestPart then
            glideToPosition(nearestPart.Position, 1) -- Glide duration of 1 second
        end
    end
end

-- Run the main loop every frame
game:GetService("RunService").RenderStepped:Connect(moveCharacter)
