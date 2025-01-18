local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local targetPlaceId = 115433517319326

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
    while wait(1) do
        if not enabled then continue end
        
        local placeId = game.PlaceId
        if placeId ~= targetPlaceId then
            gui.status.Text = "Wrong game, teleporting..."
            TeleportService:Teleport(targetPlaceId, Players.LocalPlayer)
            wait(5)
            continue
        end
        
        for i = 20, 1, -1 do
            if not enabled then break end
            gui.status.Text = "Auto Rejoin: " .. i .. "s"
            wait(1)
        end
        
        if enabled then
            gui.status.Text = "Rejoining..."
            pcall(function()
                if game.JobId and #game.JobId > 0 then
                    TeleportService:TeleportToPlaceInstance(targetPlaceId, game.JobId, Players.LocalPlayer)
                else
                    TeleportService:Teleport(targetPlaceId, Players.LocalPlayer)
                end
            end)
            wait(5)
        end
    end
end

-- Auto-restart on rejoin
if syn then
    syn.queue_on_teleport([[
        wait(5)
        loadstring(game:HttpGet('https://raw.githubusercontent.com/safsafwqe/auto_rejoin/main/auto_rejoin.lua'))()
    ]])
elseif queue_on_teleport then
    queue_on_teleport([[
        wait(5)
        loadstring(game:HttpGet('https://raw.githubusercontent.com/safsafwqe/auto_rejoin/main/auto_rejoin.lua'))()
    ]])
end

-- Start the auto-rejoin
startAutoRejoin()
