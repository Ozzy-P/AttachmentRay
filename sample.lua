-- HALF-PROTO
local function CREATE_ATTACHMENT(CONTEXT_NAME, INPUT_STATE, RAYCAST_POSITION:Vector3) end
local workspace = script.Parent
local VPF = workspace.Parent
local UIS = game:GetService("UserInputService")
local CS = game:GetService("ContextActionService")
local PR = game:GetService("Players")
local GUI = game:GetService("GuiService")
local LP = PR.LocalPlayer

local filter = {}
for _,v in pairs(workspace["FembOwOy"]:GetChildren()) do
	if v:IsA("MeshPart") then
		table.insert(filter,v)
	end
end

local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Include
params.FilterDescendantsInstances = filter


local WPC = Instance.new("Camera")
WPC.Parent = workspace.Parent
VPF.CurrentCamera = WPC
WPC.CFrame = CFrame.new() + Vector3.new(0,0,0)--CFrame.new(0, 20, 20, 1, 0, 0, 0, 0.707106709, 0.707106829, 0, -0.707106829, 0.707106709)

local POS_SCALE = (WPC:WorldToViewportPoint(Vector3.new(1,1,-5)) - WPC:WorldToViewportPoint(Vector3.new(0,0,-5))).X*2
local UI_INSET = GUI:GetGuiInset().Y

CREATE_ATTACHMENT = function(CONTEXT_NAME, INPUT_STATE, RAYCAST_POSITION:Vector3)
	if INPUT_STATE ~= Enum.UserInputState.Begin then return end
	local moz = UIS:GetMouseLocation()
	RAYCAST_POSITION = Vector3.new(VPF.AbsolutePosition.X + VPF.AbsoluteSize.X/2 - moz.X,VPF.AbsolutePosition.Y + VPF.AbsoluteSize.Y/2 - moz.Y + UI_INSET,0)
	if moz.X < VPF.AbsolutePosition.X or moz.X > VPF.AbsolutePosition.X + VPF.AbsoluteSize.X then warn("Politically charged, eh?") return end
	if moz.Y < VPF.AbsolutePosition.Y or moz.Y > VPF.AbsolutePosition.Y + VPF.AbsoluteSize.Y*1.5 then warn("Not a centrist I take it?") return end
	
	-- ScreenPointToRay => ViewportPointToRay
	--warn(WPC:ViewportPointToRay(-RAYCAST_POSITION.X,-RAYCAST_POSITION.Y,5))
	
	local SP_RAY = WPC:ViewportPointToRay(-RAYCAST_POSITION.X,-RAYCAST_POSITION.Y,0)
	local RAY_ORIGIN,RAY_DIRECTION = SP_RAY.Origin * Vector3.new(POS_SCALE,POS_SCALE,POS_SCALE) - Vector3.new(0,0,5.5), SP_RAY.Direction*Vector3.new(POS_SCALE,POS_SCALE,POS_SCALE) - Vector3.new(0,0,5.5)

	local rayCastResult = workspace:Raycast(Vector3.new(),RAY_ORIGIN,params)
	if rayCastResult then
		local normalizedPosition = (rayCastResult.Position*Vector3.new(-1,1,-1)) - (rayCastResult.Instance.Position*Vector3.new(-1,1,-1))
		local AP = Instance.new("Part")
		AP.Size = Vector3.new(0.15,0.15,0.15)
		AP.CFrame = CFrame.new() + (rayCastResult.Position + Vector3.new(0,0,.25))
		AP.Anchored = true
		AP.Parent = workspace
		local attachment = Instance.new("Attachment")
		attachment.CFrame = CFrame.new() + normalizedPosition
		attachment.Parent = rayCastResult.Instance
		attachment.Name = "RAYCAST-ATTACHMENT"
		
		local characterATAT = attachment:Clone()
		characterATAT.Parent = LP.Character[rayCastResult.Instance.Name] or LP.CharacterAdded:Wait():WaitForChild(rayCastResult.Instance.Name)
		characterATAT.Visible = true
	end
end

CS:BindAction("CAST_RAY",CREATE_ATTACHMENT,false,Enum.KeyCode.R)



--[[
VPF.MouseMoved:Connect(function(x,y)
	warn(x-VPF.AbsolutePosition.X,y-VPF.AbsolutePosition.Y)
	local newPos = UDim2.new(0,x-VPF.AbsolutePosition.X,0,y-VPF.AbsolutePosition.Y-UI_INSET)
	VPF.Frame.Position = newPos
end)
--]]
