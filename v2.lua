local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

-- Create GUI for status and control
local function createStatusGui()
    local gui = Instance.new("ScreenGui")
    local main = Instance.new("Frame")
    local status = Instance.new("TextLabel")
    local toggle = Instance.new("TextButton")
    
    gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    main.Name = "RejoinStatus"
    main.Size = UDim2.new(0, 200, 0, 70)
    main.Position = UDim2.new(0, 10, 0, 10)
    main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    main.BorderColor3 = Color3.fromRGB(60, 60, 60)
    main.Parent = gui
    
    status.Size = UDim2.new(1, -10, 0, 25)
    status.Position = UDim2.new(0, 5, 0, 5)
    status.BackgroundTransparency = 1
    status.TextColor3 = Color3.fromRGB(255, 255, 255)
    status.Text = "Auto Rejoin: Ready"
    status.Parent = main
    
    toggle.Size = UDim2.new(1, -10, 0, 25)
    toggle.Position = UDim2.new(0, 5, 0, 35)
    toggle.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Text = "Enabled"
    toggle.Parent = main
    
    return {
        status = status,
        toggle = toggle
    }
end

-- Main rejoin function
local function startAutoRejoin()
    local enabled = true
    local gui = createStatusGui()
    
    -- Toggle button handler
    gui.toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        gui.toggle.BackgroundColor3 = enabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(120, 0, 0)
        gui.toggle.Text = enabled and "Enabled" or "Disabled"
        gui.status.Text = enabled and "Auto Rejoin: Ready" or "Auto Rejoin: Paused"
    end)
    
    -- Auto rejoin loop
    while true do
        if enabled then
            gui.status.Text = "Rejoining in 15 seconds..."
            wait(15) -- Wait 15 seconds before rejoining
            
            gui.status.Text = "Rejoining..."
            pcall(function()
                if game.JobId and #game.JobId > 0 then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
                else
                    TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
                end
            end)
        end
        wait(1)  -- Small delay before the next check to avoid blocking the script
    end
end

-- Auto-restart on rejoin
if syn then
    syn.queue_on_teleport([[
        wait(5)
        loadstring(game:HttpGet('https://raw.githubusercontent.com/safsafwqe/auto_rejoin/main/v2.lua'))()
    ]])
elseif queue_on_teleport then
    queue_on_teleport([[
        wait(5)
        loadstring(game:HttpGet('https://raw.githubusercontent.com/safsafwqe/auto_rejoin/main/v2.lua'))()
    ]])
end

-- Start the auto-rejoin process
startAutoRejoin()
