local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

-- Настройки сообщений
local killCount = 0
local lastKillTime = 0
local killMessages = {
    [1] = "-1 easy kill",
    [2] = "-2 medium kill",
    [3] = "-3 hard kill",
    [4] = "-4 RAMPAGE",
    [5] = "-5 MONSTERS KILL"
}

-- Функция отправки в чат Prison Life
local function say(msg)
    local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") and ReplicatedStorage.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
    if chatRemote then
        chatRemote:FireServer(msg, "All")
    end
end

-- Создаем Тугл
local Toggle = Tab:CreateToggle({
   Name = "Activate E-Script + AutoToxic",
   CurrentValue = false,
   Flag = "E_Script_Toggle",
   Callback = function(Value)
      _G.GazanActive = Value
      
      if Value then
         -- Загружаем твой скрипт по новой ссылке
         loadstring(game:HttpGet("https://raw.githubusercontent.com"))()
         
         -- Функция для отслеживания смертей (обновляется при каждом включении)
         local function setupPlayer(pl)
            pl.CharacterAdded:Connect(function(char)
               local hum = char:WaitForChild("Humanoid")
               hum.Died:Connect(function()
                  if not _G.GazanActive then return end
                  
                  -- Проверка, что убили мы (через CreatorTag)
                  local tag = hum:FindFirstChild("creator")
                  if tag and tag.Value == lp then
                     local now = tick()
                     
                     -- Сброс счетчика через 6 секунд
                     if now - lastKillTime > 6 then
                        killCount = 1
                     else
                        killCount = killCount + 1
                     end
                     
                     lastKillTime = now
                     local finalMsg = killMessages[killCount] or ("-" .. killCount .. " GODLIKE KILL!")
                     say(finalMsg)
                  end
               end)
            end)
         end

         -- Вешаем проверку на всех игроков
         for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp then setupPlayer(p) end
         end
         Players.PlayerAdded:Connect(setupPlayer)
      end
   end,
})
