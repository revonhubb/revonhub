-- Revon Hub Modern RGB + Dash Slider (NO BLUR + ROUND RGB TOGGLE)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local connection
local scriptEnabled = false
local DashPower = 60 -- başlangıç

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RevonHub_RGB"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- >>> BLUR TAMAMEN SİLİNDİ <<<

-- Main Frame (büyütüldü, hitbox toggle sığacak)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 230) -- önce 170 idi
MainFrame.Position = UDim2.new(0.2, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

-- Glow Shadow
local Shadow = Instance.new("ImageLabel", MainFrame)
Shadow.Size = UDim2.new(1, 40, 1, 40)
Shadow.Position = UDim2.new(0, -20, 0, -20)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageTransparency = 0.75

-- Top Bar
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
TopBar.BackgroundTransparency = 0.2
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 16)

-- Title
local Title = Instance.new("TextLabel", TopBar)
Title.Text = "Revon Hub"
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- X Butonu (şeffaf)
local Close = Instance.new("TextButton", TopBar)
Close.Size = UDim2.new(0, 28, 0, 28)
Close.Position = UDim2.new(1, -32, 0.5, -14)
Close.BackgroundTransparency = 1
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 16
Close.TextColor3 = Color3.fromRGB(220,220,220)

Close.MouseEnter:Connect(function()
	Close.TextColor3 = Color3.fromRGB(255,120,120)
end)

Close.MouseLeave:Connect(function()
	Close.TextColor3 = Color3.fromRGB(220,220,220)
end)

Close.MouseButton1Click:Connect(function()
	ScreenGui.Enabled = false
end)

-- >>> ROUND RGB TOGGLE BUTTON <<<
local Toggle = Instance.new("TextButton", MainFrame)
Toggle.Size = UDim2.new(0, 160, 0, 45)
Toggle.Position = UDim2.new(0.5, -80, 0.33, -10)
Toggle.BackgroundColor3 = Color3.fromRGB(255,0,0)
Toggle.Text = "Revon Hub: OFF"
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 15
Toggle.TextColor3 = Color3.fromRGB(255,255,255)

local toggleCorner = Instance.new("UICorner", Toggle)
toggleCorner.CornerRadius = UDim.new(1, 0)   -- OVAL / PİLL SHAPE

-- RGB Animate
spawn(function()
	local hue = 0
	while true do
		hue = (hue + 0.004) % 1
		if scriptEnabled then
			Toggle.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
		end
		Shadow.ImageColor3 = Color3.fromHSV(hue, 1, 1)
		task.wait()
	end
end)


-- DASH
local function Dash()
	if not scriptEnabled then return end
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	hrp.Velocity = hrp.CFrame.LookVector * DashPower
end

UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.LeftShift then
		Dash()
	end
end)

-- ANTI COOLDOWN
local function enableNoDash()
	LocalPlayer:SetAttribute("NoDashCooldown", true)

	if not connection then
		connection = RunService.Heartbeat:Connect(function()
			if not scriptEnabled then return end
			local char = LocalPlayer.Character
			if not char then return end

			LocalPlayer:SetAttribute("NoDashCooldown", true)

			if char:GetAttribute("Dashed") then
				char:SetAttribute("Dashed", false)
			end

			if char:FindFirstChild("Effects") then
				for _, ef in pairs(char.Effects:GetChildren()) do
					if ef.Name == "Stun" or ef.Name == "FullStun" or ef.Name == "Blocking" or ef.Name == "HitProgress" or ef.Name == "NoDash" then
						ef:Destroy()
					end
				end
			end
		end)
	end
end

-- Toggle
Toggle.MouseButton1Click:Connect(function()
	scriptEnabled = not scriptEnabled

	if scriptEnabled then
		Toggle.Text = "Revon Hub: ON"
		enableNoDash()
	else
		Toggle.Text = "Revon Hub: OFF"
		LocalPlayer:SetAttribute("NoDashCooldown", false)
		if connection then connection:Disconnect() end
	end
end)

-- >>> RGB OVAL HITBOX TOGGLE <<<

local HitboxToggle = Instance.new("TextButton", MainFrame)
HitboxToggle.Size = UDim2.new(0, 160, 0, 45)
HitboxToggle.Position = UDim2.new(0.5, -80, 0.8, -22) -- slider altına hizalandı
HitboxToggle.BackgroundColor3 = Color3.fromRGB(255,0,0)
HitboxToggle.Text = "Hitboxes: OFF"
HitboxToggle.Font = Enum.Font.GothamBold
HitboxToggle.TextSize = 15
HitboxToggle.TextColor3 = Color3.fromRGB(255,255,255)

local hitboxCorner = Instance.new("UICorner", HitboxToggle)
hitboxCorner.CornerRadius = UDim.new(1,0)  -- Oval / Pill Shape

local hitboxesEnabled = false

-- RGB Animate for Hitbox Toggle
spawn(function()
	local hue = 0
	while true do
		hue = (hue + 0.004) % 1
		if hitboxesEnabled then
			HitboxToggle.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
		end
		task.wait()
	end
end)

local HighlightFolder = Instance.new("Folder")
HighlightFolder.Name = "RevonHitboxes"
HighlightFolder.Parent = workspace

local function createHitbox(player)
	if not player.Character then return end
	local char = player.Character

	for _, part in pairs(char:GetChildren()) do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			local cross = Instance.new("BillboardGui")
			cross.Size = UDim2.new(0, 20, 0, 20)
			cross.Adornee = part
			cross.AlwaysOnTop = true
			cross.Name = "HitboxCross"
			cross.Parent = HighlightFolder

			local line1 = Instance.new("Frame", cross)
			line1.Size = UDim2.new(1, 0, 0, 2)
			line1.Position = UDim2.new(0, 0, 0.5, -1)
			line1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			line1.BackgroundTransparency = 0.5

			local line2 = Instance.new("Frame", cross)
			line2.Size = UDim2.new(0, 2, 1, 0)
			line2.Position = UDim2.new(0.5, -1, 0, 0)
			line2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			line2.BackgroundTransparency = 0.5
		end
	end
end

local function removeHitboxes()
	for _, v in pairs(HighlightFolder:GetChildren()) do
		v:Destroy()
	end
end

HitboxToggle.MouseButton1Click:Connect(function()
	hitboxesEnabled = not hitboxesEnabled
	if hitboxesEnabled then
		HitboxToggle.Text = "Hitboxes: ON"
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				createHitbox(player)
			end
		end
	else
		HitboxToggle.Text = "Hitboxes: OFF"
		removeHitboxes()
	end
end)

-- Yeni oyuncular için
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		if hitboxesEnabled and player ~= LocalPlayer then
			createHitbox(player)
		end
	end)
end)

-- Mevcut oyuncular için
for _, player in pairs(Players:GetPlayers()) do
	if player ~= LocalPlayer then
		player.CharacterAdded:Connect(function()
			if hitboxesEnabled then
				createHitbox(player)
			end
		end)
	end
end

print("REVON HUB UPDATED — NO BLUR + RGB OVAL TOGGLE + HITBOX")
