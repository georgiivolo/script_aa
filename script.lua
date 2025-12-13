local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local AldoUser = getgenv().AldoUser or LocalPlayer.Name
print("Script: User identified as " .. AldoUser)

-- (Keep your services and variables here...)
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

pcall(function()
    if _G.AimESP_RS_CONN and _G.AimESP_RS_CONN.Connected then _G.AimESP_RS_CONN:Disconnect() end
    if _G.AimESP_CACHE_CONNECTIONS then
        for _, c in pairs(_G.AimESP_CACHE_CONNECTIONS) do c:Disconnect() end; _G.AimESP_CACHE_CONNECTIONS = nil
    end
    if _G.AimESP_FOV_CIRCLE then _G.AimESP_FOV_CIRCLE:Remove() end
    if _G.AimESP_DrawingCache then
        for _, t in pairs(_G.AimESP_DrawingCache) do for i, v in pairs(t) do v:Remove() end end; _G.AimESP_DrawingCache = nil
    end
    if _G.AimESP_Originals then
        pcall(function() game:GetService("Lighting").Ambient = _G.AimESP_Originals.Ambient end)
        pcall(function() game:GetService("Lighting").Brightness = _G.AimESP_Originals.Brightness end)
        pcall(function() game:GetService("Lighting").GlobalShadows = _G.AimESP_Originals.GlobalShadows end)
        pcall(function() workspace.CurrentCamera.FieldOfView = _G.AimESP_Originals.Fov end)
    end
    pcall(function()
        local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui and playerGui:FindFirstChild("AimESP_UI") then playerGui:FindFirstChild("AimESP_UI"):Destroy() end
        if playerGui and playerGui:FindFirstChild("KeyAuthScreenGui") then
            playerGui:FindFirstChild("KeyAuthScreenGui")
                :Destroy()
        end
        local coreGui = game:GetService("CoreGui")
        if coreGui and coreGui:FindFirstChild("AimESP_UI") then coreGui:FindFirstChild("AimESP_UI"):Destroy() end
        if coreGui and coreGui:FindFirstChild("KeyAuthScreenGui") then
            coreGui:FindFirstChild("KeyAuthScreenGui")
                :Destroy()
        end
    end)
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local KeySystem = {}
KeySystem.KeyVerified = false

local DiscordLink = "https://discord.gg/E65ED5PQqS"

function KeySystem:CreateUI()
    local KeyAuthScreenGui = Instance.new("ScreenGui")
    KeyAuthScreenGui.Name = "KeyAuthScreenGui"
    KeyAuthScreenGui.ResetOnSpawn = false
    KeyAuthScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    KeyAuthScreenGui.Parent = game:GetService("CoreGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 350, 0, 220)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = KeyAuthScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(80, 80, 85)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Title.Text = "AldoAimV4 - Key Authentication"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Parent = MainFrame
    local titleCorner = Instance.new("UICorner", Title); titleCorner.CornerRadius = UDim.new(0, 8)

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -40, 0, 35)
    KeyInput.Position = UDim2.new(0.5, 0, 0.40, 0)
    KeyInput.AnchorPoint = Vector2.new(0.5, 0.5)
    KeyInput.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    KeyInput.PlaceholderText = "Enter Key..."
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.TextSize = 14
    KeyInput.TextColor3 = Color3.fromRGB(220, 220, 220)
    KeyInput.Parent = MainFrame
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 6)

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -40, 0, 20)
    StatusLabel.Position = UDim2.new(0.5, 0, 0.58, 0)
    StatusLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = ""
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 14
    StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    StatusLabel.Parent = MainFrame

    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Size = UDim2.new(0.5, -30, 0, 40)
    SubmitButton.Position = UDim2.new(0.75, 0, 0.82, 0)
    SubmitButton.AnchorPoint = Vector2.new(0.5, 0.5)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
    SubmitButton.Text = "Verify"
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.TextSize = 16
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitButton.Parent = MainFrame
    Instance.new("UICorner", SubmitButton).CornerRadius = UDim.new(0, 6)

    local GetKeyButton = Instance.new("TextButton")
    GetKeyButton.Size = UDim2.new(0.5, -30, 0, 40)
    GetKeyButton.Position = UDim2.new(0.25, 0, 0.82, 0)
    GetKeyButton.AnchorPoint = Vector2.new(0.5, 0.5)
    GetKeyButton.BackgroundColor3 = Color3.fromRGB(80, 80, 160)
    GetKeyButton.Text = "Get Key"
    GetKeyButton.Font = Enum.Font.GothamBold
    GetKeyButton.TextSize = 16
    GetKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetKeyButton.Parent = MainFrame
    Instance.new("UICorner", GetKeyButton).CornerRadius = UDim.new(0, 6)

    local LocalUsername = LocalPlayer and LocalPlayer.Name or "Unknown"
    SubmitButton.MouseButton1Click:Connect(function()
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        StatusLabel.Text = "Checking..."

        -- 1. Grab inputs and clean them
        local enteredKey = KeyInput.Text:gsub("%s+", "")
        local cleanUsername = AldoUser:gsub(" ", "%%20") -- Fixes spaces in names

        -- 2. Construct the URL
        local url = "https://aldoaim.pythonanywhere.com/api/check-key/?key=" ..
            enteredKey .. "&username=" .. cleanUsername

        -- 3. Define the Request Function (Handles Ngrok Headers)
        local httpRequest = (syn and syn.request) or (http and http.request) or http_request or
            (fluxus and fluxus.request) or request
        local isValid = false

        -- 4. Send the Request (if supported)
        if httpRequest then
            local ok, response = pcall(function()
                return httpRequest({
                    Url = url,
                    Method = "GET",
                    Headers = {
                        ["ngrok-skip-browser-warning"] = "true",
                        ["User-Agent"] = "Roblox/AldoScript"
                    }
                })
            end)

            if ok and response and response.Body then
                local decodeOk, decoded = pcall(function()
                    return HttpService:JSONDecode(response.Body)
                end)
                if decodeOk and decoded then
                    if tostring(decoded.valid) == "true" or tostring(decoded.success) == "true" then
                        isValid = true
                    end
                end
            end
        end

        -- 6. Final Decision
        if isValid then
            StatusLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
            StatusLabel.Text = "Success! Loading..."
            task.wait(0.1)

            -- Mark Verified
            KeySystem.KeyVerified = true

            -- Destroy Key UI
            if KeyAuthScreenGui then KeyAuthScreenGui:Destroy() end

            -- Show main GUI if present
            if MainFrame then
                MainFrame.Visible = true
            elseif _G.MainFrame then
                _G.MainFrame.Visible = true
            end
        else
            StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            StatusLabel.Text = "Invalid Key"
            task.wait(2)
            StatusLabel.Text = ""
        end
    end)

    -- Helper function for the fallback (Don't worry about this part, just copy it all)
    function handleResponse(body)
        -- This is just here to make the fallback code work if request() doesn't exist
        local HttpService = game:GetService("HttpService")
        local decodeOk, decoded = pcall(function() return HttpService:JSONDecode(body) end)
        if decodeOk and decoded and decoded.valid == true then
            StatusLabel.TextColor3 = Color3.fromRGB(80, 255, 80); StatusLabel.Text = "Success!"; task.wait(0.1); KeySystem.KeyVerified = true; KeyAuthScreenGui
                :Destroy()
        else
            StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80); StatusLabel.Text = "Invalid Key"; task.wait(2); StatusLabel.Text =
            ""
        end
    end

    GetKeyButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(DiscordLink)
            StatusLabel.TextColor3 = Color3.fromRGB(80, 180, 255)
            StatusLabel.Text = "Discord Link Copied!"
            task.wait(2)
            StatusLabel.Text = ""
        else
            StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            StatusLabel.Text = "Clipboard not available."
            task.wait(2)
            StatusLabel.Text = ""
        end
    end)
end

KeySystem:CreateUI()

repeat task.wait() until KeySystem.KeyVerified == true

if KeySystem.KeyVerified then
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local HttpService = game:GetService("HttpService")
    local Lighting = game:GetService("Lighting")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Camera = workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer
    local Vim = game:GetService("VirtualInputManager")

    local settings = {
        aimbotEnabled = true,
        aimMethod = "Camera",
        fovCircle = true,
        aimRadius = 150,
        smoothness = 0.10,
        aimPart = "Head",
        hitboxExpanderEnabled = false,
        hitboxSize = 15,
        hitboxTransparency = 1,
        flyEnabled = false,
        flySpeed = 75,
        espEnabled = true,
        boxESP = true,
        skelESP = false,
        healthBar = true,
        infoESP = true,
        espVisibleColor = Color3.fromRGB(0, 255, 180),
        espOccludedColor = Color3.fromRGB(255, 80, 80),
        targetPlayers = true,
        noclipEnabled = false,
        fullBright = true,
        killAllClick = true,
        espTracers = false,
        espTracerOrigin = "Bottom Center",
        keybinds = {
            toggleGUI = Enum.KeyCode.RightControl,
            toggleFly = Enum.KeyCode.N,
            aimbotKey = Enum.UserInputType.MouseButton2,
            loopKillKey = Enum.KeyCode.H,
            killAllKey = Enum.KeyCode.F
        }
    }

    local WeaponsFolder = ReplicatedStorage:FindFirstChild("Weapons")
    local weaponChildConn = nil
    local weaponCacheReady = false
    local OriginalWeaponData = {}
    local gunModSettings = {
        infiniteAmmo = false,
        fastFire = false,
        fireRate = 0.05,
        noRecoil = false,
        allAuto = false,
        noSpread = false
    }

    local function ensureWeaponsFolder()
        if WeaponsFolder then return true end
        WeaponsFolder = ReplicatedStorage:FindFirstChild("Weapons") or ReplicatedStorage:WaitForChild("Weapons", 2)
        return WeaponsFolder ~= nil
    end

    local function backupSingleWeapon(weapon)
        if weapon and not OriginalWeaponData[weapon] then
            OriginalWeaponData[weapon] = {}
            for _, prop in ipairs(weapon:GetChildren()) do
                if prop:IsA("ValueBase") then
                    OriginalWeaponData[weapon][prop.Name] = prop.Value
                end
            end
        end
    end

    local function applyGunModsToWeapon(weapon)
        if not weapon or not OriginalWeaponData[weapon] then return end
        if gunModSettings.infiniteAmmo then
            if not weapon:FindFirstChild("Infinite") then Instance.new("Folder", weapon).Name = "Infinite" end
        else
            if weapon:FindFirstChild("Infinite") then weapon.Infinite:Destroy() end
        end
        if weapon:FindFirstChild("FireRate") then
            weapon.FireRate.Value = gunModSettings.fastFire and gunModSettings.fireRate or
                OriginalWeaponData[weapon].FireRate
        end
        if weapon:FindFirstChild("RecoilControl") then
            weapon.RecoilControl.Value = gunModSettings.noRecoil and 0 or OriginalWeaponData[weapon].RecoilControl
        end
        if weapon:FindFirstChild("Auto") then
            weapon.Auto.Value = gunModSettings.allAuto or OriginalWeaponData[weapon].Auto
        end
        if weapon:FindFirstChild("Spread") then
            weapon.Spread.Value = gunModSettings.noSpread and 0 or OriginalWeaponData[weapon].Spread
        end
    end

    local function ensureWeaponCache()
        if weaponCacheReady then return true end
        if not ensureWeaponsFolder() then return false end
        weaponCacheReady = true
        for _, weapon in ipairs(WeaponsFolder:GetChildren()) do
            backupSingleWeapon(weapon)
        end
        weaponChildConn = WeaponsFolder.ChildAdded:Connect(function(weapon)
            task.defer(function()
                backupSingleWeapon(weapon)
                applyGunModsToWeapon(weapon)
            end)
        end)
        return true
    end

    local function updateAllWeaponMods()
        if not ensureWeaponCache() then return end
        for _, weapon in ipairs(WeaponsFolder:GetChildren()) do
            applyGunModsToWeapon(weapon)
        end
    end

    local function restoreAllWeaponData()
        if not weaponCacheReady then return end
        for weapon, data in pairs(OriginalWeaponData) do
            pcall(function()
                for propName, origValue in pairs(data) do
                    if weapon and weapon:FindFirstChild(propName) then
                        weapon[propName].Value = origValue
                    end
                end
                if weapon and weapon:FindFirstChild("Infinite") then
                    weapon.Infinite:Destroy()
                end
            end)
        end
        if weaponChildConn and weaponChildConn.Connected then
            weaponChildConn:Disconnect()
            weaponChildConn = nil
        end
    end

    local isAimbotKeyPressed = false
    local targetModel = nil
    local listeningForKeybind = nil
    local updateCounter = 0
    local characterCache = {}
    local lastPlayerIndex = 0

    _G.AimESP_Originals = {
        Fov = Camera.FieldOfView,
        Ambient = Lighting.Ambient,
        Brightness = Lighting.Brightness,
        GlobalShadows =
            Lighting.GlobalShadows
    }

    local function isEnemy(plr)
        if not plr or plr == LocalPlayer then return false end
        local myTeam, theirTeam = LocalPlayer.Team, plr.Team
        if not myTeam then return true end
        if not theirTeam then return false end
        return myTeam.TeamColor ~= theirTeam.TeamColor
    end

    local function isValidTarget(model)
        if not (model and model:IsA("Model") and model.Parent == workspace) then return false end
        if model:FindFirstChildOfClass("ForceField") then return false end

        local hum = model:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false end

        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetHrp = model:FindFirstChild("HumanoidRootPart")
        if not myHrp or not targetHrp then return false end
        if targetHrp.Position.Magnitude < 20 then return false end
        if math.abs(myHrp.Position.Y - targetHrp.Position.Y) > 500 then return false end

        local groundParams = RaycastParams.new()
        groundParams.FilterType = Enum.RaycastFilterType.Exclude
        groundParams.FilterDescendantsInstances = { model }
        local groundCast = workspace:Raycast(targetHrp.Position, Vector3.new(0, -15, 0), groundParams)
        if not groundCast and hum.MoveDirection.Magnitude == 0 then return false end

        local upParams = RaycastParams.new()
        upParams.FilterType = Enum.RaycastFilterType.Exclude
        upParams.FilterDescendantsInstances = { model }
        local upCast = workspace:Raycast(targetHrp.Position, Vector3.new(0, 5, 0), upParams)
        if upCast and (upCast.Position - targetHrp.Position).Magnitude < 1 then return false end

        local plr = Players:GetPlayerFromCharacter(model)
        if plr then
            if not settings.targetPlayers or not isEnemy(plr) or plr == LocalPlayer then return false end
        end

        return true
    end

    local hrp, humanoid = nil, nil
    local flyLV, flyAO, flyAttachment = nil, nil, nil

    local function enableFly()
        if not hrp or not humanoid or flyLV then return end
        flyAttachment = Instance.new("Attachment", hrp)
        flyLV = Instance.new("LinearVelocity", hrp); flyLV.Attachment0 = flyAttachment; flyLV.MaxForce = math.huge
        flyLV.VectorVelocity = Vector3.new(0, 0, 0); flyLV.RelativeTo = Enum.ActuatorRelativeTo.World
        flyAO = Instance.new("AlignOrientation", hrp); flyAO.Attachment0 = flyAttachment
        flyAO.Mode = Enum.OrientationAlignmentMode.OneAttachment; flyAO.Responsiveness = 200; flyAO.MaxTorque = math
            .huge
        humanoid.PlatformStand = true
        local anim = hrp.Parent and hrp.Parent:FindFirstChild("Animate")
        if anim then pcall(function() anim.Disabled = true end) end
    end

    local function disableFly()
        if flyLV then
            flyLV:Destroy(); flyLV = nil
        end
        if flyAO then
            flyAO:Destroy(); flyAO = nil
        end
        if flyAttachment then
            flyAttachment:Destroy(); flyAttachment = nil
        end
        if humanoid then humanoid.PlatformStand = false end
        local anim = hrp and hrp.Parent and hrp.Parent:FindFirstChild("Animate")
        if anim then pcall(function() anim.Disabled = false end) end
    end

    local function setFlyEnabled(v)
        settings.flyEnabled = v and true or false
        if settings.flyEnabled then enableFly() else disableFly() end
    end

    local noclipConnection = nil
    local function setNoclipEnabled(enabled)
        settings.noclipEnabled = enabled
        if noclipConnection then
            noclipConnection:Disconnect(); noclipConnection = nil
        end
        local char = LocalPlayer.Character; if not char then return end
        if enabled then
            noclipConnection = RunService.Stepped:Connect(function()
                if not settings.noclipEnabled or not LocalPlayer.Character then
                    if noclipConnection then
                        noclipConnection:Disconnect(); noclipConnection = nil
                    end
                    return
                end
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
            end)
        else
            for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end
        end
    end

    local function setFullBright(enabled)
        settings.fullBright = enabled
        if enabled then
            Lighting.Ambient = Color3.fromRGB(180, 180, 180)
            Lighting.Brightness = 2; Lighting.GlobalShadows = false
        else
            Lighting.Ambient = _G.AimESP_Originals.Ambient
            Lighting.Brightness = _G.AimESP_Originals.Brightness
            Lighting.GlobalShadows = _G.AimESP_Originals.GlobalShadows
        end
    end

    local function setLocalPlayerViewModel(char)
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then part.LocalTransparencyModifier = 0.8 end end
    end

    local function onCharacterAdded(char)
        hrp = char:WaitForChild("HumanoidRootPart", 5); humanoid = char:WaitForChild("Humanoid", 5)
        if settings.flyEnabled then
            disableFly(); enableFly()
        else
            disableFly()
        end
        if settings.noclipEnabled then setNoclipEnabled(true) end
        if humanoid then
            humanoid.Died:Connect(function()
                disableFly(); if noclipConnection then
                    noclipConnection:Disconnect(); noclipConnection = nil
                end
            end)
        end
        setLocalPlayerViewModel(char)
    end

    if LocalPlayer.Character then onCharacterAdded(LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
    LocalPlayer.CharacterAppearanceLoaded:Connect(setLocalPlayerViewModel)

    local function isAlive(hum) return hum and hum.Health and hum.Health > 0 end
    local fovCircle = Drawing.new("Circle"); fovCircle.Color = Color3.fromRGB(255, 64, 64); fovCircle.Thickness = 2; fovCircle.Filled = false; fovCircle.NumSides = 64; fovCircle.Radius =
        settings.aimRadius; fovCircle.Visible = settings.fovCircle; fovCircle.Position = Vector2.new(
        Camera.ViewportSize.X /
        2, Camera.ViewportSize.Y / 2)
    _G.AimESP_FOV_CIRCLE = fovCircle

    pcall(function()
        if fovCircle and fovCircle.Canvas then
            for _, v in ipairs(fovCircle.Canvas:GetChildren()) do
                if v:IsA("Frame") and v.Size == UDim2.fromScale(1, 1) then
                    v.BackgroundTransparency = 1
                end
            end
        end
    end)

    local function screenPoint(v3)
        local v2, on = Camera:WorldToViewportPoint(v3); return Vector2.new(v2.X, v2.Y), on, v2.Z
    end

    local function hasLineOfSight(model)
        local myChar = LocalPlayer.Character; if not (myChar and model) then return false end
        local theirTargetPart = model:FindFirstChild(settings.aimPart) or model:FindFirstChild("Head") or
            model:FindFirstChild("HumanoidRootPart")
        if not theirTargetPart then return false end
        local origin = Camera.CFrame.Position; local direction = theirTargetPart.Position - origin
        local params = RaycastParams.new(); params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = { myChar }; params.IgnoreWater = true
        local result = workspace:Raycast(origin, direction, params)
        if not result then return true end
        if result.Instance:IsDescendantOf(model) then return true end
        if result.Instance:IsA("BasePart") and result.Instance.Transparency >= 0.5 then return true end
        return false
    end

    local isKillAllRunning = false
    local isLoopKillActive = false
    local loopKillConnection = nil
    local lastLoopKillTarget = nil
    local lastLoopKillTime = 0

    -- This is the "Kill All" function that runs once when you press the key.
    local function killAllTask()
        if isKillAllRunning then return end
        isKillAllRunning = true

        local myChar = LocalPlayer.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then
            isKillAllRunning = false
            return
        end

        local originalCFrame = myHrp.CFrame

        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            local targetChar = targetPlayer.Character

            -- This is the crucial check. isValidTarget already ignores players with ForceFields.
            if isValidTarget(targetChar) then
                local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
                if targetHrp then
                    myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 2) -- Teleport behind them
                    task.wait()                                           -- Allow physics to update

                    if settings.killAllClick then
                        -- Simulate a mouse click to fire your weapon
                        Vim:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, true, Camera:GetRenderCFrame(), false,
                            game)
                        Vim:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, false, Camera:GetRenderCFrame(), false,
                            game)
                    end
                    task.wait()
                end
            end
        end

        myHrp.CFrame = originalCFrame -- Teleport back to where you started
        isKillAllRunning = false
    end

    -- This is the task for "Loop Kill" that finds and attacks one target at a time.
    local function loopKillTask()
        local myChar = LocalPlayer.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        -- Stop if character is dead or the loop is turned off
        if not (myChar and myHrp and isLoopKillActive) then
            if loopKillConnection then
                loopKillConnection:Disconnect(); loopKillConnection = nil; isLoopKillActive = false
            end
            return
        end

        if tick() - lastLoopKillTime < 0.3 then return end -- Cooldown between kills

        local bestTarget = nil
        local closestDist = math.huge
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if isValidTarget(targetPlayer.Character) and targetPlayer.Character ~= lastLoopKillTarget then
                local targetHrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetHrp then
                    local dist = (myHrp.Position - targetHrp.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        bestTarget = targetPlayer.Character
                    end
                end
            end
        end

        if bestTarget then
            local targetHrp = bestTarget:FindFirstChild("HumanoidRootPart")
            if targetHrp then
                local originalCFrame = myHrp.CFrame
                myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 3)
                task.wait()
                Vim:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, true, Camera:GetRenderCFrame(), false, game)
                task.wait(0.1)
                Vim:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, false, Camera:GetRenderCFrame(), false, game)
                lastLoopKillTarget = bestTarget
                lastLoopKillTime = tick()
                task.wait(0.2)
                myHrp.CFrame = originalCFrame
            end
        else
            lastLoopKillTarget = nil -- Reset if no valid targets were found
        end
    end

    -- This function toggles the Loop Kill on and off.
    local function toggleLoopKill()
        isLoopKillActive = not isLoopKillActive
        if isLoopKillActive then
            if loopKillConnection then loopKillConnection:Disconnect() end
            loopKillConnection = RunService.Heartbeat:Connect(loopKillTask)
        else
            if loopKillConnection then
                loopKillConnection:Disconnect()
                loopKillConnection = nil
            end
            lastLoopKillTarget = nil
        end
    end


    local MainESP = { cache = {} }
    local function newLine()
        local ln = Drawing.new("Line")
        ln.Thickness = 2
        ln.Visible = false
        return ln
    end
    local function getCache(model)
        local c = MainESP.cache[model]
        if c then return c end
        c = {
            box = Drawing.new("Square"),
            lines = {},
            healthBarBg = Drawing.new("Square"),
            healthBar = Drawing.new("Square"),
            infoText = Drawing.new("Text"),
            tracer = Drawing.new("Line")
        }
        c.box.Thickness = 2; c.box.Filled = false; c.box.Visible = false
        c.healthBarBg.Thickness = 1; c.healthBarBg.Filled = true; c.healthBarBg.Color = Color3.fromRGB(20, 20, 20); c.healthBarBg.Visible = false
        c.healthBar.Thickness = 0; c.healthBar.Filled = true; c.healthBar.Visible = false
        c.infoText.Size = 13; c.infoText.Center = true; c.infoText.Outline = true; c.infoText.Visible = false
        c.tracer.Thickness = 2; c.tracer.Visible = false
        for _ = 1, 24 do table.insert(c.lines, newLine()) end
        MainESP.cache[model] = c
        return c
    end
    local function hideCache(model)
        local c = MainESP.cache[model]; if not c then return end
        if c.box then c.box.Visible = false end; if c.healthBar then c.healthBar.Visible = false end; if c.healthBarBg then c.healthBarBg.Visible = false end; if c.infoText then c.infoText.Visible = false end; if c.tracer then c.tracer.Visible = false end
        for _, ln in ipairs(c.lines) do ln.Visible = false end
    end
    local function removeCache(model)
        local c = MainESP.cache[model]; if not c then return end
        pcall(function() c.box:Remove() end); pcall(function() c.healthBar:Remove() end); pcall(function()
            c.healthBarBg
                :Remove()
        end); pcall(function() c.infoText:Remove() end); pcall(function() c.tracer:Remove() end)
        for _, ln in ipairs(c.lines) do pcall(function() ln:Remove() end) end
        MainESP.cache[model] = nil
    end

    local function getBones(model)
        local bones = {}
        local parts = {
            Head = model:FindFirstChild("Head"),
            UpperTorso = model:FindFirstChild("UpperTorso"),
            LowerTorso = model:FindFirstChild("LowerTorso"),
            LeftUpperArm = model:FindFirstChild("LeftUpperArm"),
            RightUpperArm = model:FindFirstChild("RightUpperArm"),
            LeftUpperLeg = model:FindFirstChild("LeftUpperLeg"),
            LeftLowerLeg = model:FindFirstChild("LeftLowerLeg"),
            RightUpperLeg = model:FindFirstChild("RightUpperLeg"),
            RightLowerLeg = model:FindFirstChild("RightLowerLeg"),
        }

        if parts.Head and parts.UpperTorso then table.insert(bones, { parts.Head, parts.UpperTorso }) end
        if parts.UpperTorso and parts.LowerTorso then table.insert(bones, { parts.UpperTorso, parts.LowerTorso }) end
        if parts.UpperTorso and parts.LeftUpperArm and parts.LeftLowerArm then
            table.insert(bones, { parts.UpperTorso, parts.LeftUpperArm })
            table.insert(bones, { parts.LeftUpperArm, parts.LeftLowerArm })
        end
        if parts.LeftLowerArm and parts.LeftHand then table.insert(bones, { parts.LeftLowerArm, parts.LeftHand }) end
        if parts.UpperTorso and parts.RightUpperArm and parts.RightLowerArm then
            table.insert(bones, { parts.UpperTorso, parts.RightUpperArm })
            table.insert(bones, { parts.RightUpperArm, parts.RightLowerArm })
        end
        if parts.RightLowerArm and parts.RightHand then table.insert(bones, { parts.RightLowerArm, parts.RightHand }) end
        if parts.LowerTorso and parts.LeftUpperLeg and parts.LeftLowerLeg then
            table.insert(bones, { parts.LowerTorso, parts.LeftUpperLeg })
            table.insert(bones, { parts.LeftUpperLeg, parts.LeftLowerLeg })
        end
        if parts.LeftLowerLeg and parts.LeftFoot then table.insert(bones, { parts.LeftLowerLeg, parts.LeftFoot }) end
        if parts.LowerTorso and parts.RightUpperLeg and parts.RightLowerLeg then
            table.insert(bones, { parts.LowerTorso, parts.RightUpperLeg })
            table.insert(bones, { parts.RightUpperLeg, parts.RightLowerLeg })
        end
        if parts.RightLowerLeg and parts.RightFoot then table.insert(bones, { parts.RightLowerLeg, parts.RightFoot }) end

        return bones
    end

    local function updateESP(model)
        local hum = model:FindFirstChildOfClass("Humanoid")
        if not isAlive(hum) or not settings.espEnabled then
            hideCache(model)
            return
        end
        local cache = getCache(model)
        local isVisible = hasLineOfSight(model)
        local espColor = isVisible and settings.espVisibleColor or settings.espOccludedColor
        cache.box.Color = espColor; cache.infoText.Color = espColor; for _, ln in ipairs(cache.lines) do
            ln.Color =
                espColor
        end

        local points = {
            model:FindFirstChild("Head"), model:FindFirstChild("HumanoidRootPart"),
            model:FindFirstChild("LeftFoot"), model:FindFirstChild("RightFoot"),
            model:FindFirstChild("LeftHand"), model:FindFirstChild("RightHand")
        }

        local anyOn, minX, minY, maxX, maxY = false, math.huge, math.huge, -math.huge, -math.huge
        for _, part in ipairs(points) do
            if part and part:IsA("BasePart") then
                local sp, on = screenPoint(part.Position)
                if on then
                    anyOn = true
                    minX = math.min(minX, sp.X); minY = math.min(minY, sp.Y)
                    maxX = math.max(maxX, sp.X); maxY = math.max(maxY, sp.Y)
                end
            end
        end

        if anyOn then
            if settings.boxESP then
                cache.box.Visible = true
                cache.box.Position = Vector2.new(minX, minY)
                cache.box.Size = Vector2.new(math.max(2, maxX - minX), math.max(2, maxY - minY))
            else
                cache.box.Visible = false
            end

            if settings.healthBar then
                local boxHeight = math.max(2, maxY - minY)
                local healthPercent = hum.Health / hum.MaxHealth
                cache.healthBarBg.Visible = true; cache.healthBar.Visible = true
                cache.healthBarBg.Position = Vector2.new(minX - 6, minY); cache.healthBarBg.Size = Vector2.new(4,
                    boxHeight)
                cache.healthBar.Position = Vector2.new(minX - 6, minY + (boxHeight * (1 - healthPercent)))
                cache.healthBar.Size = Vector2.new(4, boxHeight * healthPercent)
                cache.healthBar.Color = Color3.fromHSV(0.33 * healthPercent, 1, 1)
            else
                cache.healthBarBg.Visible = false; cache.healthBar.Visible = false
            end

            if settings.infoESP then
                local player = Players:GetPlayerFromCharacter(model)
                local name = player and player.DisplayName or model.Name
                local dist = (hrp and (hrp.Position - model.HumanoidRootPart.Position).Magnitude) or 0
                cache.infoText.Visible = true
                cache.infoText.Text = string.format("%s [%.0fm]", name, dist)
                cache.infoText.Position = Vector2.new(minX + (maxX - minX) / 2, minY - 15)
            else
                cache.infoText.Visible = false
            end
            if settings.espTracers and cache.tracer then
                local tracerTarget = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head")
                if tracerTarget then
                    local tPos, tOn = screenPoint(tracerTarget.Position)
                    if tOn then
                        local origin
                        local vp = Camera.ViewportSize
                        if settings.espTracerOrigin == "Top Center" then
                            origin = Vector2.new(vp.X / 2, 0)
                        elseif settings.espTracerOrigin == "Crosshair" then
                            origin = Vector2.new(vp.X / 2, vp.Y / 2)
                        else -- Bottom Center
                            origin = Vector2.new(vp.X / 2, vp.Y)
                        end
                        cache.tracer.From = origin
                        cache.tracer.To = tPos
                        cache.tracer.Color = espColor
                        cache.tracer.Visible = true
                    else
                        cache.tracer.Visible = false
                    end
                else
                    cache.tracer.Visible = false
                end
            else
                if cache.tracer then cache.tracer.Visible = false end
            end
        else
            hideCache(model)
        end

        local used = 0
        if settings.skelESP and anyOn then
            for _, pair in ipairs(getBones(model)) do
                local a, b = pair[1], pair[2]
                if a and b and a:IsA("BasePart") then
                    local a2, aon = screenPoint(a.Position)
                    local b2, bon = screenPoint(b.Position)
                    if aon and bon then
                        used = used + 1
                        local ln = cache.lines[used] or newLine()
                        cache.lines[used] = ln
                        ln.From = a2; ln.To = b2; ln.Visible = true
                    end
                end
            end
        end
        for i = used + 1, #cache.lines do cache.lines[i].Visible = false end
    end

    workspace.ChildRemoved:Connect(function(child)
        if MainESP.cache[child] then removeCache(child) end
    end)

    local validTargets = {}
    local aimbotTarget = nil

    local function updateTargetsAndESP()
        local playerList = Players:GetPlayers()
        local playersToUpdate = 7

        for _ = 1, playersToUpdate do
            if #playerList == 0 then break end
            lastPlayerIndex = (lastPlayerIndex % #playerList) + 1
            local player = playerList[lastPlayerIndex]
            if player then
                local char = player.Character
                if char and isValidTarget(char) then
                    updateESP(char)
                    validTargets[player] = char
                else
                    if validTargets[player] then
                        hideCache(char)
                        validTargets[player] = nil
                    end
                end
            end
        end

        local bestDist = settings.aimRadius
        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        aimbotTarget = nil

        for player, char in pairs(validTargets) do
            if hasLineOfSight(char) then
                local aimPart = char:FindFirstChild(settings.aimPart) or char:FindFirstChild("Head")
                if aimPart then
                    local sp, onScreen = screenPoint(aimPart.Position)
                    if onScreen then
                        local dist = (sp - center).Magnitude
                        if dist < bestDist then
                            bestDist = dist
                            aimbotTarget = char
                        end
                    end
                end
            end
        end
    end

    local function aimAt(model)
        if not model then return end
        local targetPart = model:FindFirstChild(settings.aimPart) or model:FindFirstChild("Head"); if not targetPart then return end
        local backOffset = targetPart.CFrame * CFrame.new(0, 0, 1)
        if settings.aimMethod == "Camera" then
            local desired = CFrame.new(Camera.CFrame.Position, backOffset.Position)
            local s = tonumber(settings.smoothness) or 0
            if s <= 0 then
                Camera.CFrame = desired
            else
                Camera.CFrame = Camera.CFrame:Lerp(desired, 1 - math.clamp(s, 0.01, 0.99))
            end
        elseif settings.aimMethod == "Mouse" then
            if mousemoverel then
                local targetPos, onScreen = screenPoint(backOffset.Position)
                if onScreen then
                    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local delta = targetPos - center
                    local smoothFactor = math.clamp(settings.smoothness, 0, 1)
                    local moveX = delta.X * (1 - smoothFactor)
                    local moveY = delta.Y * (1 - smoothFactor)
                    mousemoverel(moveX, moveY)
                end
            end
        end
    end

    coroutine.resume(coroutine.create(function()
        while task.wait(0.6) do
            if settings.hitboxExpanderEnabled then
                local sizeVec = Vector3.new(settings.hitboxSize, settings.hitboxSize, settings.hitboxSize)
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local transparencyValue = not isEnemy(player) and 1 or settings.hitboxTransparency
                        pcall(function()
                            local char = player.Character
                            local parts = {
                                char:FindFirstChild("RightUpperLeg"),
                                char:FindFirstChild("LeftUpperLeg"),
                                char:FindFirstChild("HumanoidRootPart"),
                                char:FindFirstChild("HeadHB")
                            }
                            for _, part in ipairs(parts) do
                                if part then
                                    part.CanCollide = false
                                    part.Transparency = transparencyValue
                                    part.Size = sizeVec
                                end
                            end
                        end)
                    end
                end
            end
        end
    end))

    UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if listeningForKeybind then
            local newKey = input.UserInputType.Name:find("Mouse") and input.UserInputType or input.KeyCode
            settings.keybinds[listeningForKeybind.Name] = newKey
            listeningForKeybind.Text = tostring(newKey.Name)
            listeningForKeybind = nil
            return
        end
        if input.UserInputType == settings.keybinds.aimbotKey or input.KeyCode == settings.keybinds.aimbotKey then isAimbotKeyPressed = true end
        if input.KeyCode == settings.keybinds.toggleFly then setFlyEnabled(not settings.flyEnabled) end
        if input.KeyCode == settings.keybinds.toggleGUI then
            if mainGuiFrame then
                mainGuiFrame.Visible = not mainGuiFrame
                    .Visible
            end
        end
        if input.KeyCode == settings.keybinds.loopKillKey then toggleLoopKill() end
        if input.KeyCode == settings.keybinds.killAllKey then killAllTask() end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == settings.keybinds.aimbotKey or input.KeyCode == settings.keybinds.aimbotKey then isAimbotKeyPressed = false end
    end)

    local rsConn
    rsConn = RunService.RenderStepped:Connect(function()
        fovCircle.Visible = settings.fovCircle
        fovCircle.Radius = settings.aimRadius
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

        updateTargetsAndESP()

        if settings.aimbotEnabled and isAimbotKeyPressed and aimbotTarget then
            aimAt(aimbotTarget)
        end

        if settings.flyEnabled and flyLV and flyAO then
            local dir = Vector3.new()
            local cam = workspace.CurrentCamera
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
            flyLV.VectorVelocity = (dir.Magnitude > 0) and (dir.Unit * settings.flySpeed) or Vector3.new(0, 0, 0)
            flyAO.CFrame = cam.CFrame
        end
    end)
    _G.AimESP_RS_CONN = rsConn

    local function restorePlayerCharacters()
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                pcall(function()
                    local char = player.Character
                    local partsToRestore = {
                        char:FindFirstChild("RightUpperLeg"),
                        char:FindFirstChild("LeftUpperLeg"),
                        char:FindFirstChild("HumanoidRootPart"),
                        char:FindFirstChild("HeadHB")
                    }
                    for _, part in ipairs(partsToRestore) do
                        if part and part:IsA("BasePart") then
                            part.CanCollide = true
                            part.Transparency = 0
                            part.Size = Vector3.new(1, 1, 1)
                        end
                    end
                end)
            end
        end
    end

    -- =========================================================================
    --  >>> THIS IS THE REPLACEMENT UI CODE BLOCK <<<
    -- =========================================================================

    -- // --- THEME & CONFIGURATION ---
    -- quick-load palette (lighter weight than previous)
    local THEME = {
        Accent = Color3.fromRGB(0, 186, 255),
        AccentSoft = Color3.fromRGB(0, 146, 214),
        Background = Color3.fromRGB(18, 20, 26),
        Surface = Color3.fromRGB(26, 28, 36),
        Card = Color3.fromRGB(30, 32, 42),
        Muted = Color3.fromRGB(60, 64, 76),
        Text = Color3.fromRGB(235, 238, 245),
        TextMuted = Color3.fromRGB(150, 155, 170),
    }
    local FONT = Enum.Font.GothamSemibold
    local TweenService = game:GetService("TweenService")
    local TextService = game:GetService("TextService")

    -- Helper tween function (keeps the UI code concise)
    local function tween(obj, props, duration)
        if not obj or not props then return end
        local ti = TweenInfo.new(duration or 0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        TweenService:Create(obj, ti, props):Play()
    end

    -- Stubbed sound helper so missing sound assets don't crash the script
    local function playSound(_)
        -- no-op; plug in executor-specific sound logic here if desired
    end

    -- // --- MAIN UI SETUP ---
    local sg = Instance.new("ScreenGui"); sg.Name = "AimESP_UI"; sg.ResetOnSpawn = false; sg.ZIndexBehavior = Enum
        .ZIndexBehavior.Global
    local function safeParentGui(gui)
        local ok, cg = pcall(function() return game:GetService("CoreGui") end); if ok and cg then
            gui.Parent = cg
        else
            gui.Parent =
                Players.LocalPlayer:WaitForChild("PlayerGui")
        end
    end
    safeParentGui(sg)

    local UniversalTooltip = Instance.new("Frame", sg)
    UniversalTooltip.Size = UDim2.new(0, 150, 0, 30)
    UniversalTooltip.BackgroundColor3 = THEME.Background
    UniversalTooltip.BorderSizePixel = 0
    UniversalTooltip.Visible = false
    UniversalTooltip.ZIndex = 100 -- Ensure it's on top
    Instance.new("UICorner", UniversalTooltip).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", UniversalTooltip).Color = THEME.Muted

    local tooltipLabel = Instance.new("TextLabel", UniversalTooltip)
    tooltipLabel.Size = UDim2.fromScale(1, 1)
    tooltipLabel.BackgroundTransparency = 1
    tooltipLabel.Font = FONT
    tooltipLabel.TextColor3 = THEME.Text
    tooltipLabel.TextSize = 12
    tooltipLabel.TextWrapped = true
    local tooltipPadding = Instance.new("UIPadding", tooltipLabel)
    tooltipPadding.PaddingLeft = UDim.new(0, 5)
    tooltipPadding.PaddingRight = UDim.new(0, 5)
    local tooltipConnection -- For the mouse-follow connection

    local Main = Instance.new("Frame"); Main.Name = "Main"; Main.Size = UDim2.new(0, 680, 0, 460); Main.Position = UDim2
        .new(0.5, -340, 0.5, -230)
    Main.BackgroundColor3 = THEME.Background; Main.BorderSizePixel = 0; Main.ClipsDescendants = true; Main.Parent = sg
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10); local mainStroke = Instance.new("UIStroke", Main); mainStroke.Color =
        THEME.Muted; mainStroke.Thickness = 1
    local mainGuiFrame = Main

    -- // --- WINDOW MANAGEMENT ---
    local TitleBar = Instance.new("Frame", Main); TitleBar.Name = "TitleBar"; TitleBar.Size = UDim2.new(1, 0, 0, 42); TitleBar.BackgroundColor3 =
        THEME.Surface
    local Title = Instance.new("TextLabel", TitleBar); Title.Size = UDim2.new(0, 260, 1, 0); Title.Position = UDim2.new(
        0, 16, 0, 0); Title.BackgroundTransparency = 1; Title.Font = Enum.Font.GothamBold
    Title.Text = "AldoAimV4"; Title.TextColor3 = THEME.Text; Title.TextSize = 17; Title.TextXAlignment = Enum
        .TextXAlignment.Left

    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging, dragStart, startPos =
                true, input.Position, Main.Position
        end
    end)
    TitleBar.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local d = input.Position - dragStart; Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)

    local btnClose = Instance.new("TextButton", TitleBar); btnClose.Size = UDim2.new(0, 30, 0, 24); btnClose.Position =
        UDim2.new(1, -35, 0.5, -12); btnClose.BackgroundTransparency = 1
    btnClose.Font = Enum.Font.GothamBold; btnClose.Text = "X"; btnClose.TextColor3 = THEME.TextMuted; btnClose.TextSize = 18
    btnClose.MouseEnter:Connect(function() tween(btnClose, { TextColor3 = Color3.fromRGB(255, 80, 80) }, 0.1) end)
    btnClose.MouseLeave:Connect(function() tween(btnClose, { TextColor3 = THEME.TextMuted }, 0.1) end)
    btnClose.MouseButton1Click:Connect(function()
        playSound("click")
        if rsConn then rsConn:Disconnect() end; pcall(restoreAllWeaponData); pcall(restorePlayerCharacters)
        sg:Destroy()
    end)

    -- // --- LAYOUT & TABS ---
    local Sidebar = Instance.new("Frame", Main); Sidebar.Name = "Sidebar"; Sidebar.Size = UDim2.new(0, 150, 1, -42); Sidebar.Position =
        UDim2.new(0, 0, 0, 42)
    Sidebar.BackgroundColor3 = THEME.Surface; Sidebar.BorderSizePixel = 0
    Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 10)
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 4)

    local PagesContainer = Instance.new("Frame", Main); PagesContainer.Name = "PagesContainer"; PagesContainer.Size =
        UDim2.new(1, -150, 1, -42); PagesContainer.Position = UDim2.new(0, 150, 0, 42)
    PagesContainer.BackgroundTransparency = 1
    do
        local padding = Instance.new("UIPadding", PagesContainer)
        padding.PaddingTop = UDim.new(0, 15)
        padding.PaddingBottom = UDim.new(0, 15)
        padding.PaddingLeft = UDim.new(0, 15)
        padding.PaddingRight = UDim.new(0, 15)
    end

    local pages = {}; local tabButtons = {}; local activeTab = nil
    local function createPage(name)
        local page = Instance.new("ScrollingFrame", PagesContainer); page.Name = name; page.Size = UDim2.fromScale(1, 1); page.BackgroundTransparency = 1
        page.BorderSizePixel = 0; page.ScrollBarImageColor3 = THEME.Muted; page.ScrollBarThickness = 4; page.CanvasSize =
            UDim2.new()
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y; page.Visible = false; pages[name] = page
        local layout = Instance.new("UIListLayout", page); layout.Padding = UDim.new(0, 12); return page
    end
    local function setActiveTab(tab)
        if activeTab then
            tween(activeTab.Indicator, { Size = UDim2.new(0, 0, 1, 0) })
            tween(activeTab.Button, { BackgroundColor3 = THEME.Surface })
            activeTab.Page.Visible = false
        end
        tween(tab.Indicator, { Size = UDim2.new(0, 3, 1, 0) })
        tween(tab.Button, { BackgroundColor3 = THEME.Background })
        tab.Page.Visible = true
        activeTab = tab
    end
    local function createTab(name, order)
        local tabBtn = Instance.new("TextButton", Sidebar); tabBtn.Name = name; tabBtn.Size = UDim2.new(1, -12, 0, 42)
        tabBtn.Position = UDim2.new(0, 6, 0, 0)
        tabBtn.BackgroundColor3 = THEME.Surface; tabBtn.Font = FONT; tabBtn.Text = "  " .. name; tabBtn.TextColor3 =
            THEME.Text
        tabBtn.TextSize = 14; tabBtn.TextXAlignment = Enum.TextXAlignment.Left; tabBtn.LayoutOrder = order
        local indicator = Instance.new("Frame", tabBtn); indicator.Name = "Indicator"; indicator.Size = UDim2.new(0, 0, 1,
            0)
        indicator.BackgroundColor3 = THEME.Accent; indicator.BorderSizePixel = 0
        local page = createPage(name)
        local tabRecord = { Button = tabBtn, Indicator = indicator, Page = page }
        tabBtn.MouseEnter:Connect(function()
            if activeTab ~= tabRecord then tween(tabBtn, { BackgroundColor3 = THEME.Card }) end; playSound("hover")
        end)
        tabBtn.MouseLeave:Connect(function()
            if activeTab ~= tabRecord then tween(tabBtn, { BackgroundColor3 = THEME.Surface }) end
        end)
        tabBtn.MouseButton1Click:Connect(function()
            setActiveTab(tabRecord); playSound("click")
        end)
        table.insert(tabButtons, tabRecord)
        return page
    end

    local pageAim = createTab("Aimbot", 1); local pageESP = createTab("ESP", 2); local pageGunMods = createTab(
        "Gun Mods", 3); local pageMisc = createTab("Misc", 4); local pageSettings = createTab("Settings", 5)
    setActiveTab(tabButtons[1])

    -- // --- MODERN COMPONENT FACTORY ---
    local function handleTooltip(object, tooltipText)
        if not tooltipText then return end
        object.MouseEnter:Connect(function()
            playSound("hover")
            tooltipLabel.Text = tooltipText
            local textSize = TextService:GetTextSize(tooltipText, 12, FONT, Vector2.new(150, math.huge))
            UniversalTooltip.Size = UDim2.new(0, textSize.X + 10, 0, textSize.Y + 10)
            UniversalTooltip.Visible = true
            if tooltipConnection then tooltipConnection:Disconnect() end
            tooltipConnection = RunService.RenderStepped:Connect(function()
                local mousePos = UIS:GetMouseLocation()
                UniversalTooltip.Position = UDim2.fromOffset(mousePos.X + 15, mousePos.Y + 15)
            end)
        end)
        object.MouseLeave:Connect(function()
            UniversalTooltip.Visible = false
            if tooltipConnection then
                tooltipConnection:Disconnect(); tooltipConnection = nil
            end
        end)
    end
    local function createSection(parent, text)
        local l = Instance.new("TextLabel", parent)
        l.Size = UDim2.new(1, 0, 0, 22)
        l.BackgroundTransparency = 1
        l.Font = Enum.Font.GothamBold
        l.Text = text:upper()
        l.TextColor3 = THEME.TextMuted
        l.TextSize = 12
        l.TextXAlignment = Enum.TextXAlignment.Left
        return l
    end
    local function createToggle(parent, text, getVal, setVal)
        local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 28); f.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, -72, 1, 0); l.BackgroundTransparency = 1; l.Font =
            FONT
        l.Text = text; l.TextColor3 = THEME.Text; l.TextSize = 14; l.TextXAlignment = Enum.TextXAlignment.Left
        local t = Instance.new("TextButton", f); t.Size = UDim2.new(0, 48, 0, 22); t.Position = UDim2.new(1, -48, 0.5,
            -11)
        t.BackgroundColor3 = THEME.Muted; t.Text = ""; Instance.new("UICorner", t).CornerRadius = UDim.new(1, 0)
        local n = Instance.new("Frame", t); n.Size = UDim2.new(0, 18, 0, 18); n.Position = UDim2.new(0, 2, 0.5, -9); n.BackgroundColor3 =
            THEME.TextMuted; Instance.new("UICorner", n).CornerRadius = UDim.new(1, 0)
        local function u(i)
            local v = getVal(); local d = i and 0 or 0.12
            if v then
                tween(n, { Position = UDim2.new(1, -20, 0.5, -9), BackgroundColor3 = THEME.Accent }, d)
                tween(t, { BackgroundColor3 = THEME.Card }, d)
            else
                tween(n, { Position = UDim2.new(0, 2, 0.5, -9), BackgroundColor3 = THEME.TextMuted }, d)
                tween(t, { BackgroundColor3 = THEME.Muted }, d)
            end
        end
        t.MouseButton1Click:Connect(function()
            setVal(not getVal()); u(); playSound("click")
        end); u(true); t.MouseEnter:Connect(function() playSound("hover") end)
        handleTooltip(f, tooltipText)
    end
    local function createSlider(parent, text, min, max, step, getVal, setVal)
        local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 44); f.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, -64, 0, 20); l.BackgroundTransparency = 1; l.Font =
            FONT
        l.Text = text; l.TextColor3 = THEME.Text; l.TextSize = 14; l.TextXAlignment = Enum.TextXAlignment.Left
        local vL = Instance.new("TextLabel", f); vL.Size = UDim2.new(0, 56, 0, 20); vL.Position = UDim2.new(1, -56, 0, 0); vL.BackgroundTransparency = 1; vL.Font =
            Enum.Font.GothamBold
        vL.TextColor3 = THEME.Accent; vL.TextSize = 14; vL.TextXAlignment = Enum.TextXAlignment.Right
        local t = Instance.new("Frame", f); t.Size = UDim2.new(1, 0, 0, 7); t.Position = UDim2.new(0, 0, 0, 26); t.BackgroundColor3 =
            THEME.Muted; Instance.new("UICorner", t).CornerRadius = UDim.new(1, 0)
        local fl = Instance.new("Frame", t); fl.BackgroundColor3 = THEME.Accent; Instance.new("UICorner", fl).CornerRadius =
            UDim.new(1, 0)
        local iB = Instance.new("TextButton", t); iB.Size = UDim2.fromScale(1, 1); iB.BackgroundTransparency = 1; iB.ZIndex = 2
        local function u()
            local v = getVal(); local p = step < 1 and "%.2f" or "%.0f"; vL.Text = string.format(p, v); local c = (v - min) /
                (max - min); fl.Size = UDim2.new(c, 0, 1, 0)
        end
        local d = false
        local function o(i)
            local p = math.clamp((i.Position.X - t.AbsolutePosition.X) / t.AbsoluteSize.X, 0, 1); local v = min +
                (max - min) * p
            local s = math.floor(v / step + 0.5) * step; setVal(s); u()
        end
        iB.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                d = true; o(i); playSound("click")
            end
        end)
        UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
        iB.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then o(i) end end)
        iB.MouseEnter:Connect(function() playSound("hover") end); u()
        handleTooltip(f, tooltipText)
    end
    local function createChoice(parent, text, options, getVal, setVal, tooltipText)
        local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 36); f.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.5, -6, 1, 0); l.BackgroundTransparency = 1; l.Font =
            FONT
        l.Text = text; l.TextColor3 = THEME.Text; l.TextSize = 14; l.TextXAlignment = Enum.TextXAlignment.Left; l.TextTruncate =
            Enum.TextTruncate.None
        local cB = Instance.new("TextButton", f); cB.Size = UDim2.new(0.5, -6, 1, 0); cB.Position = UDim2.fromScale(0.5,
            0)
        cB.BackgroundColor3 = THEME.Muted; cB.Font = FONT; cB.Text = ""; cB.TextColor3 = THEME.Text; cB.TextSize = 14; Instance.new("UICorner", cB).CornerRadius =
            UDim.new(0, 6)
        local lB = Instance.new("TextButton", cB); lB.Size = UDim2.new(0, 22, 1, 0); lB.BackgroundTransparency = 1; lB.Font =
            FONT; lB.Text = "<"; lB.TextColor3 = THEME.TextMuted; lB.TextSize = 14
        local rB = lB:Clone(); rB.Parent = cB; rB.Position = UDim2.new(1, -22, 0, 0); rB.Text = ">";
        local tL = Instance.new("TextLabel", cB); tL.Size = UDim2.new(1, -60, 1, 0); tL.Position = UDim2.new(0, 30, 0, 0); tL.BackgroundTransparency = 1; tL.Font =
            FONT; tL.TextColor3 = THEME.Text; tL.TextSize = 14; tL.TextWrapped = false; tL.TextTruncate = Enum
            .TextTruncate
            .AtEnd; tL.TextXAlignment = Enum.TextXAlignment.Center
        local function u() tL.Text = getVal() end
        local function c(dir)
            local cur = getVal(); local i = table.find(options, cur) or 1; local nI = (i + dir - 1) % #options + 1; setVal(
                options[nI]); u(); playSound("click")
        end
        lB.MouseButton1Click:Connect(function() c(-1) end); rB.MouseButton1Click:Connect(function() c(1) end); u()
        handleTooltip(f, tooltipText)
    end

    -- // --- SETTINGS HELPERS (CONFIG / KEYBINDS) ---
    local function createButton(parent, text, height)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(1, 0, 0, height or 36)
        btn.BackgroundColor3 = THEME.Muted
        btn.Text = text
        btn.Font = FONT
        btn.TextColor3 = THEME.Text
        btn.TextSize = 14
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", btn).Color = THEME.Accent
        btn.AutoButtonColor = true
        return btn
    end

    local function serializeConfig()
        local payload = { settings = {}, gun = {} }
        for k, v in pairs(settings) do
            if k == "keybinds" then
                payload.settings.keybinds = {}
                for kb, val in pairs(v) do
                    payload.settings.keybinds[kb] = {
                        type = (val.EnumType and val.EnumType.Name) or "KeyCode",
                        name =
                            val.Name
                    }
                end
            elseif typeof(v) == "Color3" then
                payload.settings[k] = { r = v.R, g = v.G, b = v.B }
            else
                payload.settings[k] = v
            end
        end
        for k, v in pairs(gunModSettings) do payload.gun[k] = v end
        return HttpService:JSONEncode(payload)
    end

    local function applyConfig(data)
        if data.settings then
            for k, v in pairs(data.settings) do
                if k == "keybinds" and type(v) == "table" then
                    for kb, entry in pairs(v) do
                        local enumTable = Enum[entry.type] or Enum.KeyCode
                        local enumVal = enumTable and enumTable[entry.name]
                        if enumVal then settings.keybinds[kb] = enumVal end
                    end
                elseif type(v) == "table" and v.r and v.g and v.b then
                    settings[k] = Color3.new(v.r, v.g, v.b)
                else
                    settings[k] = v
                end
            end
        end
        if data.gun then
            for k, v in pairs(data.gun) do if gunModSettings[k] ~= nil then gunModSettings[k] = v end end
            updateAllWeaponMods()
        end
        setFullBright(settings.fullBright)
    end

    -- // ---  PAGES WITH YOUR FEATURES ---
    -- AIMBOT
    createToggle(pageAim, "Aimbot Enabled", function() return settings.aimbotEnabled end,
        function(v) settings.aimbotEnabled = v end, "toggles aimbot")
    createToggle(pageAim, "Show FOV Circle", function() return settings.fovCircle end,
        function(v) settings.fovCircle = v end)
    createSlider(pageAim, "FOV Radius", 50, 1000, 10, function() return settings.aimRadius end,
        function(v) settings.aimRadius = v end)
    createSlider(pageAim, "Smoothness", 0, 1, 0.01, function() return settings.smoothness end,
        function(v) settings.smoothness = v end, "1=less snappy, 2=super snappy")
    createChoice(pageAim, "Aim Part", { "Head", "UpperTorso", "HumanoidRootPart" },
        function() return settings.aimPart end, function(v) settings.aimPart = v end)
    createSection(pageAim, "HITBOX")
    createToggle(pageAim, "Hitbox Expander", function() return settings.hitboxExpanderEnabled end,
        function(v) settings.hitboxExpanderEnabled = v end, "makes enemies easier to hit")
    createSlider(pageAim, "Hitbox Size", 1, 50, 1, function() return settings.hitboxSize end,
        function(v) settings.hitboxSize = v end)

    -- ESP
    createToggle(pageESP, "ESP Enabled", function() return settings.espEnabled end,
        function(v) settings.espEnabled = v end)
    createToggle(pageESP, "Box ESP", function() return settings.boxESP end, function(v) settings.boxESP = v end)
    createToggle(pageESP, "Skeleton ESP", function() return settings.skelESP end, function(v) settings.skelESP = v end)
    createToggle(pageESP, "Health Bar", function() return settings.healthBar end, function(v) settings.healthBar = v end)
    createToggle(pageESP, "Info (Name/Dist)", function() return settings.infoESP end,
        function(v) settings.infoESP = v end)
    createToggle(pageESP, "Tracers", function() return settings.espTracers end, function(v) settings.espTracers = v end)
    createChoice(pageESP, "Tracer Origin", { "Bottom Center", "Top Center", "Crosshair" },
        function() return settings.espTracerOrigin end, function(v) settings.espTracerOrigin = v end)
    -- GUN MODS
    createToggle(pageGunMods, "Infinite Ammo", function() return gunModSettings.infiniteAmmo end,
        function(v)
            gunModSettings.infiniteAmmo = v; updateAllWeaponMods()
        end)
    createToggle(pageGunMods, "Fast Fire", function() return gunModSettings.fastFire end,
        function(v)
            gunModSettings.fastFire = v; updateAllWeaponMods()
        end)
    createToggle(pageGunMods, "No Recoil", function() return gunModSettings.noRecoil end,
        function(v)
            gunModSettings.noRecoil = v; updateAllWeaponMods()
        end)
    createSlider(pageGunMods, "Fire Rate", 0.01, 0.2, 0.01, function() return gunModSettings.fireRate end,
        function(v)
            gunModSettings.fireRate = v; if gunModSettings.fastFire then updateAllWeaponMods() end
        end)
    createToggle(pageGunMods, "All Auto", function() return gunModSettings.allAuto end,
        function(v)
            gunModSettings.allAuto = v; updateAllWeaponMods()
        end)
    createToggle(pageGunMods, "No Spread", function() return gunModSettings.noSpread end,
        function(v)
            gunModSettings.noSpread = v; updateAllWeaponMods()
        end)

    -- MISC
    createToggle(pageMisc, "Fly", function() return settings.flyEnabled end, setFlyEnabled)
    createToggle(pageMisc, "Noclip", function() return settings.noclipEnabled end, setNoclipEnabled)
    createToggle(pageMisc, "Full Bright", function() return settings.fullBright end, setFullBright)
    createSlider(pageMisc, "Fly Speed", 10, 500, 5, function() return settings.flySpeed end,
        function(v) settings.flySpeed = v end)

    -- SETTINGS TAB CONTENT
    local keybindButtons = {}

    -- small card helper for cleaner grouping
    local function createCard(parent, titleText)
        local card = Instance.new("Frame", parent)
        card.Size = UDim2.new(1, 0, 0, 0)
        card.BackgroundColor3 = THEME.Surface
        card.BorderSizePixel = 0
        local pad = Instance.new("UIPadding", card)
        pad.PaddingTop = UDim.new(0, 10); pad.PaddingBottom = UDim.new(0, 10); pad.PaddingLeft = UDim.new(0, 10); pad.PaddingRight =
            UDim.new(0, 10)
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", card).Color = THEME.Muted
        local layout = Instance.new("UIListLayout", card)
        layout.Padding = UDim.new(0, 8)
        layout.FillDirection = Enum.FillDirection.Vertical
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        createSection(card, titleText)
        return card
    end

    local configCard = createCard(pageSettings, "Config")
    configCard.AutomaticSize = Enum.AutomaticSize.Y
    local configBox = Instance.new("TextBox", configCard)
    configBox.Size = UDim2.new(1, 0, 0, 90)
    configBox.BackgroundColor3 = THEME.Card
    configBox.TextColor3 = THEME.Text
    configBox.Font = Enum.Font.Code
    configBox.TextSize = 14
    configBox.ClearTextOnFocus = false
    configBox.MultiLine = true
    configBox.TextWrapped = true
    configBox.TextXAlignment = Enum.TextXAlignment.Left
    configBox.TextYAlignment = Enum.TextYAlignment.Top
    configBox.PlaceholderText = "Paste config JSON here..."
    Instance.new("UICorner", configBox).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", configBox).Color = THEME.Muted

    local copyBtn = createButton(configCard, "Copy Config to Clipboard", 32)
    copyBtn.MouseButton1Click:Connect(function()
        if not setclipboard then return end
        local ok, enc = pcall(serializeConfig)
        if ok then pcall(function() setclipboard(enc) end) end
    end)

    local loadBtn = createButton(configCard, "Load Config from Textbox", 32)
    loadBtn.MouseButton1Click:Connect(function()
        local content = configBox.Text
        if not content or #content == 0 then return end
        local ok, decoded = pcall(function() return HttpService:JSONDecode(content) end)
        if ok and decoded then
            applyConfig(decoded)
            for kb, btn in pairs(keybindButtons) do
                btn.Text = settings.keybinds[kb].Name
            end
        end
    end)

    local keybindCard = createCard(pageSettings, "Keybinds")
    keybindCard.AutomaticSize = Enum.AutomaticSize.Y
    local function addKeybindRow(labelText, keyName)
        local row = Instance.new("Frame", keybindCard)
        row.Size = UDim2.new(1, 0, 0, 32)
        row.BackgroundTransparency = 1
        local rowLayout = Instance.new("UIListLayout", row)
        rowLayout.FillDirection = Enum.FillDirection.Horizontal
        rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        rowLayout.Padding = UDim.new(0, 8)
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.5, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = FONT
        lbl.Text = labelText
        lbl.TextColor3 = THEME.Text
        lbl.TextSize = 14
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local btn = Instance.new("TextButton", row)
        btn.Name = keyName
        btn.Size = UDim2.new(0.5, -8, 1, 0)
        btn.BackgroundColor3 = THEME.Muted
        btn.Font = FONT
        btn.TextColor3 = THEME.Text
        btn.TextSize = 14
        btn.Text = settings.keybinds[keyName].Name
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", btn).Color = THEME.Accent
        btn.MouseButton1Click:Connect(function()
            if listeningForKeybind then listeningForKeybind.Text = settings.keybinds[listeningForKeybind.Name].Name end
            listeningForKeybind = btn
            btn.Text = "..."
        end)
        keybindButtons[keyName] = btn
    end
    addKeybindRow("Toggle GUI", "toggleGUI")
    addKeybindRow("Toggle Fly", "toggleFly")
    addKeybindRow("Aimbot Key", "aimbotKey")
    addKeybindRow("Loop Kill Key", "loopKillKey")
    addKeybindRow("Kill All Key", "killAllKey")

    local presetCard = createCard(pageSettings, "Presets")
    presetCard.AutomaticSize = Enum.AutomaticSize.Y
    local presetLegit = createButton(presetCard, "Load Legit Config", 32)
    presetLegit.MouseButton1Click:Connect(function()
        applyConfig({
            settings = {
                aimbotEnabled = true,
                fovCircle = false,
                aimRadius = 80,
                smoothness = 0.5,
                espEnabled = true,
                boxESP = true,
                skelESP = false,
                healthBar = true,
                infoESP = true,
                fullBright = false,
                noclipEnabled = false
            }
        })
        for kb, btn in pairs(keybindButtons) do btn.Text = settings.keybinds[kb].Name end
    end)
    local presetRage = createButton(presetCard, "Load Rage Config", 32)
    presetRage.MouseButton1Click:Connect(function()
        applyConfig({
            settings = {
                aimbotEnabled = true,
                fovCircle = true,
                aimRadius = 300,
                smoothness = 1.0,
                espEnabled = true,
                boxESP = true,
                skelESP = true,
                healthBar = true,
                infoESP = true,
                fullBright = true,
                noclipEnabled = true
            }
        })
        for kb, btn in pairs(keybindButtons) do btn.Text = settings.keybinds[kb].Name end
    end)
    local presetAuto = createButton(presetCard, "Load AutoAim Config (vicinity)", 32)
    presetAuto.MouseButton1Click:Connect(function()
        applyConfig({
            settings = {
                aimbotEnabled = true,
                fovCircle = true,
                aimRadius = 300,
                smoothness = 0,
                espEnabled = true,
                boxESP = true,
                skelESP = false,
                healthBar = false,
                infoESP = true,
                hitboxExpanderEnabled = true,
                hitboxSize = 24,
                hitboxTransparency = 1,
                fullBright = true
            },
            gun = {
                infiniteAmmo = true, fastFire = true, fireRate = 0.01, noRecoil = true, allAuto = true, noSpread = true
            }
        })
        for kb, btn in pairs(keybindButtons) do btn.Text = settings.keybinds[kb].Name end
    end)

    _G.AimESP_CACHE_CONNECTIONS = {}
    local function onPlayerAdded(player)
        player.CharacterAdded:Connect(function(char)
            if char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid").Died:Connect(function()
                    if MainESP.cache[char] then removeCache(char) end
                end)
            end
        end)
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character.Humanoid.Died:Connect(function()
                if MainESP.cache[player.Character] then removeCache(player.Character) end
            end)
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do onPlayerAdded(player) end
    table.insert(_G.AimESP_CACHE_CONNECTIONS, Players.PlayerAdded:Connect(onPlayerAdded))
    table.insert(_G.AimESP_CACHE_CONNECTIONS, Players.PlayerRemoving:Connect(function(player)
        if player.Character and MainESP.cache[player.Character] then
            removeCache(player.Character)
        end
        validTargets[player] = nil
    end))
end
