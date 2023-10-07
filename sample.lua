-- HALF-PROTO
local function CREATE_ATTACHMENT(CONTEXT_NAME, INPUT_STATE, RAYCAST_POSITION:Vector3) end
local workspace = script.Parent
local VPF = workspace.Parent
local UIS = game:GetService("UserInputService")
local CS = game:GetService("ContextActionService")
local PR = game:GetService("Players")
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

local POS_SCALE = (WPC:WorldToViewportPoint(Vector3.new(1,1,-5)) - WPC:WorldToViewportPoint(Vector3.new(0,0,-5))).X


CREATE_ATTACHMENT = function(CONTEXT_NAME, INPUT_STATE, RAYCAST_POSITION:Vector3)
	if INPUT_STATE ~= Enum.UserInputState.Begin then return end
	local moz = UIS:GetMouseLocation()
	RAYCAST_POSITION = Vector3.new(VPF.AbsolutePosition.X + VPF.AbsoluteSize.X/2 - moz.X,VPF.AbsolutePosition.Y + VPF.AbsoluteSize.Y/2 - moz.Y,0)
	if moz.X < VPF.AbsolutePosition.X then warn("Leftist.") return end
	if moz.Y < VPF.AbsolutePosition.Y then warn("Go down.") return end
	
	-- ScreenPointToRay => ViewportPointToRay
	--warn(WPC:ViewportPointToRay(-RAYCAST_POSITION.X,-RAYCAST_POSITION.Y,5))
	
	local SP_RAY = WPC:ViewportPointToRay(-RAYCAST_POSITION.X,-RAYCAST_POSITION.Y,5)
	local RAY_ORIGIN,RAY_DIRECTION = SP_RAY.Origin * Vector3.new(POS_SCALE,POS_SCALE,0) - Vector3.new(0,0,7), SP_RAY.Direction*Vector3.new(POS_SCALE,POS_SCALE,0) - Vector3.new(0,0,7)

	local rayCastResult = workspace:Raycast(Vector3.new(),RAY_ORIGIN,params)
	if rayCastResult then
		local normalizedPosition = rayCastResult.Position - rayCastResult.Instance.Position
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


	--warn(rayCastResult)

end

CS:BindAction("CAST_RAY",CREATE_ATTACHMENT,false,Enum.KeyCode.R)

