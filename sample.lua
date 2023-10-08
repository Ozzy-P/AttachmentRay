-- HALF-PROTO
local function CREATE_ATTACHMENT(CONTEXT_NAME, INPUT_STATE, RAYCAST_POSITION:Vector3) end
local function CHANGE_LIMB(CONTEXT_NAME, INPUT_STATE, RAYCAST_POSITION:Vector3) end
local workspace = script.Parent
local VPF = workspace.Parent
local UIS = game:GetService("UserInputService")
local CS = game:GetService("ContextActionService")
local PR = game:GetService("Players")
local GUI = game:GetService("GuiService")
local IK = require(script.IKC)
local LP = PR.LocalPlayer
local TARGET_VIEWPORT = workspace["FembOwOy"]

local filter = {}
for _,v in pairs(TARGET_VIEWPORT:GetChildren()) do
	if v:IsA("MeshPart") then
		table.insert(filter,v)
	end
end

local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Include
params.FilterDescendantsInstances = filter

local WPC = Instance.new("Camera")
local IK_RIG = IK:CreateRig(LP.Character, LP.Character:WaitForChild("LeftHand"), LP.Character.LeftUpperArm)

WPC.Parent = workspace.Parent
VPF.CurrentCamera = WPC
WPC.CFrame = CFrame.new() + Vector3.new(0,0,0)--CFrame.new(0, 20, 20, 1, 0, 0, 0, 0.707106709, 0.707106829, 0, -0.707106829, 0.707106709)

local POS_SCALE = (WPC:WorldToViewportPoint(Vector3.new(1,1,TARGET_VIEWPORT.PrimaryPart.Position.Z)) - WPC:WorldToViewportPoint(Vector3.new(0,0,TARGET_VIEWPORT.PrimaryPart.Position.Z))).X*2
local UI_INSET = GUI:GetGuiInset().Y

local function GET_RAY()
	local moz = UIS:GetMouseLocation()
	local RAYCAST_POSITION = Vector3.new(VPF.AbsolutePosition.X + VPF.AbsoluteSize.X/2 - moz.X,VPF.AbsolutePosition.Y + VPF.AbsoluteSize.Y/2 - moz.Y + UI_INSET,0)
	if moz.X < VPF.AbsolutePosition.X or moz.X > VPF.AbsolutePosition.X + VPF.AbsoluteSize.X then warn("Politically charged, eh?") return end
	if moz.Y < VPF.AbsolutePosition.Y or moz.Y > VPF.AbsolutePosition.Y + VPF.AbsoluteSize.Y*1.5 then warn("Not a centrist I take it?") return end
	return WPC:ViewportPointToRay(-RAYCAST_POSITION.X,-RAYCAST_POSITION.Y,0)
end

CREATE_ATTACHMENT = function(CONTEXT_NAME, INPUT_STATE, RAYCAST_POSITION:Vector3)
	if INPUT_STATE ~= Enum.UserInputState.Begin then return end
	
	local SP_RAY = GET_RAY()
	local RAY_ORIGIN,RAY_DIRECTION = SP_RAY.Origin * Vector3.new(POS_SCALE,POS_SCALE,POS_SCALE) + Vector3.new(0,0,TARGET_VIEWPORT.PrimaryPart.Position.Z), SP_RAY.Direction*Vector3.new(POS_SCALE,POS_SCALE,POS_SCALE) + Vector3.new(0,0,TARGET_VIEWPORT.PrimaryPart.Position.Z)

	local rayCastResult = workspace:Raycast(Vector3.new(),RAY_ORIGIN,params)
	if rayCastResult then
		local normalizedPosition = (rayCastResult.Position*Vector3.new(-1,1,-1)) - (rayCastResult.Instance.Position*Vector3.new(-1,1,-1))
		IK_RIG:SetAttachment(CFrame.new() + normalizedPosition,game.Workspace.FembOwOys[rayCastResult.Instance.Name])
	end
end

CHANGE_LIMB = function(CONTEXT_NAME, INPUT_STATE, RAYCAST_POSITION:Vector3)
	if INPUT_STATE ~= Enum.UserInputState.Begin then return end
	-- ScreenPointToRay => ViewportPointToRay
	--warn(WPC:ViewportPointToRay(-RAYCAST_POSITION.X,-RAYCAST_POSITION.Y,5))

	local SP_RAY = GET_RAY()
	local RAY_ORIGIN,RAY_DIRECTION = SP_RAY.Origin * Vector3.new(POS_SCALE,POS_SCALE,POS_SCALE) + Vector3.new(0,0,TARGET_VIEWPORT.PrimaryPart.Position.Z), SP_RAY.Direction*Vector3.new(POS_SCALE,POS_SCALE,POS_SCALE) + Vector3.new(0,0,TARGET_VIEWPORT.PrimaryPart.Position.Z)

	local rayCastResult = workspace:Raycast(Vector3.new(),RAY_ORIGIN,params)
	if rayCastResult then
		IK_RIG:SetLimb(rayCastResult.Instance)
	end
end

CS:BindAction("CHANGE_LIMB",CHANGE_LIMB,false,Enum.KeyCode.C)

VPF.MouseMoved:Connect(function(x,y)
	local newPos = UDim2.new(0,x-VPF.AbsolutePosition.X,0,y-VPF.AbsolutePosition.Y-UI_INSET)
	VPF.Frame.Position = newPos
	CREATE_ATTACHMENT("MOD_ATTACHMENT",Enum.UserInputState.Begin)
end)

