RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    -- SPEED
    if hacks.WalkSpeed and hum then
        hum.WalkSpeed = 60
    else
        if hum then hum.WalkSpeed = 16 end
    end

    -- HIGH JUMP
    if hacks.HighJump and hum then
        hum.JumpPower = 120
    else
        if hum then hum.JumpPower = 50 end
    end

    -- FULLBRIGHT
    if hacks.FullBright then
        Lighting.Brightness = 5
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
    end

    -- NOCLIP
    if hacks.NoClip and char then
        for _, part in pairs(char:GetDescParts()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- FLY SIMPLES
    if hacks.Fly and root then
        root.Velocity = Vector3.new(0, 50, 0)
    end
end)
