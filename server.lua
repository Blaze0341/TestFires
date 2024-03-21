-- Initialize QBCore
local QBCore = exports['qb-core']:GetCoreObject()


-- Function to check if at least one firefighter is online
function IsFirefighterOnline()
    for _, playerId in ipairs(GetPlayers()) do
        local player = QBCore.Functions.GetPlayer(playerId)
        if player ~= nil and player.job.name == Config.FirefighterJob then
            return true
        end
    end
    return false
end

-- Function to spawn fires
function SpawnFires()
    -- Check if at least one firefighter is online
    if IsFirefighterOnline() then
        for _, fireType in ipairs(Config.Fires) do
            for _, location in ipairs(fireType.locations) do
                if location.enabled then
                    for _, area in ipairs(location.areas) do
                        -- Spawn multiple flames at area coordinates
                        for i = 1, Config.NumFlamesPerFire do
                            TriggerClientEvent('fire:spawn', -1, area.coords, area.flames.scale)
                        end
                    end
                end
            end
        end
    end
end

-- Event handler to trigger fire spawn
Citizen.CreateThread(function()
    while true do
        -- Spawn fires if at least one firefighter is online
        SpawnFires()
        -- Wait for some time before checking again (e.g., every 20 minutes)
        Citizen.Wait(Config.FireSpawnIntervalMinutes * 60 * 1000)
    end
end)


-- Event handler to trigger fire spawn
-- Function to start fires
function StartFires()
    -- Check if fires are already active
    if not Config.FiresActive then
        Config.FiresActive = true
        -- Spawn fires
        SpawnFires()
        -- Notify players that fires have been started
        QBCore.Functions.Notify("Fires have been started by an administrator.", "error")
    else
        -- Notify players that fires are already active
        QBCore.Functions.Notify("Fires are already active.", "error")
    end
end

-- Function to stop fires
function StopFires()
    -- Check if fires are active
    if Config.FiresActive then
        Config.FiresActive = false
        -- Notify players that fires have been stopped
        QBCore.Functions.Notify("Fires have been stopped by an administrator.", "error")
    else
        -- Notify players that fires are not active
        QBCore.Functions.Notify("Fires are not currently active.", "error")
    end
end

-- Command to start fires
RegisterCommand('startfires', function(source, args, rawCommand)
    -- Check if player has permission to start fires
    -- Example: if IsPlayerAceAllowed(source, "resource.startfires") then
        StartFires()
    -- else
        -- Notify player that they don't have permission
    -- end
end, false)

-- Command to stop fires
RegisterCommand('stopfires', function(source, args, rawCommand)
    -- Check if player has permission to stop fires
    -- Example: if IsPlayerAceAllowed(source, "resource.stopfires") then
        StopFires()
    -- else
        -- Notify player that they don't have permission
    -- end
end, false)

-- Function to spawn fires
function SpawnFiresNearPlayer(playerId, numFlames, scale)
    local playerPed = GetPlayerPed(playerId)
    local playerCoords = GetEntityCoords(playerPed)
    local distance = 50.0  -- Maximum distance to spawn fire from player

    -- Calculate a random offset within the specified distance
    local offsetX = math.random(-distance, distance)
    local offsetY = math.random(-distance, distance)
    local spawnCoords = vector3(playerCoords.x + offsetX, playerCoords.y + offsetY, playerCoords.z)

    -- Trigger the event to spawn the fire with the specified number of flames and scale
    TriggerClientEvent('fire:spawn', -1, spawnCoords, numFlames, scale)
end

-- Command to start a fire near the player
RegisterCommand('fire', function(source, args, rawCommand)
    local playerId = source
    local numFlames = tonumber(args[1]) or Config.NumFlamesPerFire
    local scale = tonumber(args[2]) or 1.0

    -- Ensure the number of flames and scale are within valid ranges
    numFlames = math.max(1, math.min(numFlames, Config.MaxFlamesPerFire))
    scale = math.max(0.1, math.min(scale, 10.0))

    -- Spawn fires near the player with the specified number of flames and scale
    SpawnFiresNearPlayer(playerId, numFlames, scale)
end, false)

-- Function to check if the player has the firefighter job
function HasFirefighterJob(playerId)
    local player = QBCore.Functions.GetPlayer(playerId)
    return player ~= nil and player.job.name == Config.FirefighterJob
end

-- Function to reduce the fire's intensity over time
function ReduceFireIntensity(coords)
    local intensityReductionRate = 0.05  -- Rate at which fire intensity reduces per tick
    local minIntensity = 0.0  -- Minimum fire intensity

    local fireIntensity = GetFireIntensityAtCoord(coords)  -- Get current fire intensity at coordinates

    if fireIntensity > minIntensity then
        -- Reduce fire intensity
        fireIntensity = math.max(minIntensity, fireIntensity - intensityReductionRate)

        -- Update fire intensity
        SetFireIntensityAtCoord(coords, fireIntensity)
    end
end

-- Event handler to start extinguishing fire
RegisterNetEvent('fire:extinguishStart')
AddEventHandler('fire:extinguishStart', function(coords)
    local playerId = source

    -- Check if the player has the firefighter job
    if HasFirefighterJob(playerId) then
        -- Start reducing fire intensity for the player
        local interval = 1000  -- Interval in milliseconds
        local extinguishingTimer = setInterval(interval, function()
            ReduceFireIntensity(coords)
        end)

        -- Store timer for the player
        extinguishingEffects[playerId] = extinguishingTimer
    else
        -- Notify the player if they lack the required job
        QBCore.Functions.Notify("You need to be a firefighter to use a fire extinguisher.", "error")
    end
end)

-- Event handler to stop extinguishing fire
RegisterNetEvent('fire:extinguishStop')
AddEventHandler('fire:extinguishStop', function()
    local playerId = source

    -- Clear extinguishing timer for the player
    local extinguishingTimer = extinguishingEffects[playerId]
    if extinguishingTimer then
        clearInterval(extinguishingTimer)
        extinguishingEffects[playerId] = nil
    end
end)
