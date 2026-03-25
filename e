local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

local killCount = 0
local lastKillTime = 0
local killMessages = {
    [1] = "-1 easy kill",
    [2] = "-2 medium kill",
    [3] = "-3 hard kill",
    [4] = "-4 RAMPAGE",
    [5] = "-5 MONSTERS KILL"
}

-- Функция отправки сообщения в чат
local function say(msg)
    local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") and ReplicatedStorage.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
    if chatRemote then
        chatRemote:FireServer(msg, "All")
    end
end

local function onKill()
    local now = tick()
    
    -- Если прошло больше 6 секунд, сбрасываем счетчик
    if now - lastKillTime > 6 then
        killCount = 1
    else
        killCount = killCount + 1
    end
    
    lastKillTime = now
    
    -- Берем сообщение из списка или пишем дефолтное, если больше 5 киллов
    local message = killMessages[killCount] or ("-" .. killCount .. " UNSTOPPABLE!")
    say(message)
end

-- Логика отслеживания убийства (через Humanoid.Died)
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid")
        hum.Died:Connect(function()
            -- Проверяем, что убили именно МЫ (работает, если в игре есть CreatorTag)
            local tag = hum:FindFirstChild("creator")
            if tag and tag.Value == lp then
                onKill()
            end
        end)
    end)
end)
