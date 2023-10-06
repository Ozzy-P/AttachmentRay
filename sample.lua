-- HALF-PROTO
local function CREATE_ATTACHMENT(CONTEXT_NAME, INPUT_STATE, RAYCAST_POSITION:Vector3) end
local workspace = script.Parent
local VPF = workspace.Parent
local UIS = game:GetService("UserInputService")
local CS = game:GetService("ContextActionService")

local filter = {}
for _,v in pairs(workspace["REDACTED"]:GetChildren()) do
	if v:IsA("MeshPart") then
		table.insert(filter,v)
	end
end

local params = RaycastParams.new()

params.FilterType = Enum.RaycastFilterType.Include
params.FilterDescendantsInstances = filter


CREATE_ATTACHMENT = function(CONTEXT_NAME, INPUT_STATE, RAYCAST_POSITION:Vector3)
	if INPUT_STATE ~= Enum.UserInputState.End then return end
	local moz = UIS:GetMouseLocation()
	if moz.X < VPF.AbsolutePosition.X then warn("Left.") return end
	if moz.Y < VPF.AbsolutePosition.Y then warn("Up.") return end
	--local rayCastResult = workspace:Raycast(Vector3.new(RAYCAST_POSITION.X,RAYCAST_POSITION.Y,0),Vector3.new(RAYCAST_POSITION.X,RAYCAST_POSITION.Y,-20),params)
	--local rayCastResult = workspace:Raycast(Vector3.new(0,1,0),Vector3.new(0,1,-20),params)

	if rayCastResult then
		local normalizedPosition = rayCastResult.Instance.Position - rayCastResult.Position
		local attachment = Instance.new("Attachment")
		attachment.CFrame = CFrame.new() + normalizedPosition
		attachment.Parent = rayCastResult.Instance
		attachment.Name = "RAYCAST-ATTACHMENT"
	end
end

CS:BindAction("CAST_RAY",CREATE_ATTACHMENT,false,Enum.KeyCode.R)

