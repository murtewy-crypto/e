local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

local killCount = 0
local lastKillTime = 0
local killMessages = {[1]="-1 easy kill", [2]="-2 medium kill", [3]="-3 hard kill", [4]="-4 RAMPAGE", [5]="-5 MONSTERS KILL"}

local function say(msg)
    local event = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if event then event.SayMessageRequest:FireServer(msg, "All") end
end

-- Переменная, чтобы не запускать проверку убийств дважды
local connectionActive = false

local function trackKills()
    if connectionActive then return end
    connectionActive = true
    
    local function monitor(pl)
        pl.CharacterAdded:Connect(function(char)
            local hum = char:WaitForChild("Humanoid", 5)
            if hum then
                hum.Died:Connect(function()
                    if not _G.GazanActive then return end
                    local tag = hum:FindFirstChild("creator")
                    if tag and tag.Value == lp then
                        local now = tick()
                        if now - lastKillTime > 6 then killCount = 1 else killCount = killCount + 1 end
                        lastKillTime = now
                        say(killMessages[killCount] or ("-"..killCount.." GODLIKE!"))
                    end
                end)
            end
        end)
    end

    for _, p in pairs(Players:GetPlayers()) do if p ~= lp then monitor(p) end end
    Players.PlayerAdded:Connect(monitor)
end

local Toggle = Tab:CreateToggle({
   Name = "Safe Load + AutoToxic",
   CurrentValue = false,
   Flag = "SafeGazan",
   Callback = function(Value)
      _G.GazanActive = Value
      if Value then
         -- Безопасная загрузка через pcall
         task.spawn(function()
            local s, e = pcall(function()
               loadstring(game:HttpGet("https://raw.githubusercontent.com"))()
            end)
            if not s then warn("Script Error: "..e) end
         end)
         trackKills()
      end
   end,
})
