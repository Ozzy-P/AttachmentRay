local workspace = script.Parent

local filter = {}
for _,v in pairs(workspace["REDACTED"]:GetChildren()) do
	if v:IsA("MeshPart") then
		table.insert(filter,v)
	end
end

local params = RaycastParams.new()

params.FilterType = Enum.RaycastFilterType.Include
params.FilterDescendantsInstances = filter

local rayCastResult = workspace:Raycast(Vector3.new(0,1,0),Vector3.new(0,1,-20),params)

if rayCastResult then
	local normalizedPosition = rayCastResult.Instance.Position - rayCastResult.Position
	local attachment = Instance.new("Attachment")
	attachment.CFrame = CFrame.new() + normalizedPosition
	attachment.Parent = rayCastResult.Instance
	attachment.Name = "RAYCAST-ATTACHMENT"
end
