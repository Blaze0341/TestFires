-- Initialize QBCore
local QBCore = exports['qb-core']:GetCoreObject()

-- Function to display fire alert
function DisplayFireAlert(location)
    if Config.Message == "QBCore" then
        QBCore.Functions.Notify(string.format(Config.AlertMessage, location), "error")
    elseif Config.Message == "ps-dispatch" then
        exports['ps-dispatch']:Fire(location)
    elseif Config.Message == "none" then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"[Fire]", string.format(Config.AlertMessage, location)}
        })
    end
end

-- Event handler for receiving fire alerts
RegisterNetEvent('fire:alert')
AddEventHandler('fire:alert', function(location)
    DisplayFireAlert(location)
end)

function SpawnFlame(coords, scale)
    -- Example logic to spawn flames using a particle system
    -- Adjust scale parameter to change the size of flames
    -- Adjust number of flames based on random range
    TriggerEvent('fire:alert',coords)
    local numFlames = math.random(1, Config.NumFlamesPerFire)
    for i = 1, numFlames do
        -- Spawn a flame with the given coordinates and scale
        TriggerEvent('fire:spawnSingleFlame', coords, scale)
    end
end

-- Event handler to spawn flames
RegisterNetEvent('fire:spawn')
AddEventHandler('fire:spawn', function(coords, scale)
    SpawnFlame(coords, scale)
end)

-- Function to spawn a flame particle effect
function SpawnFlameParticle(coords, scale)
    -- Convert vector3 coordinates to native format
    local particleCoords = vector3(coords.x, coords.y, coords.z)

    -- Start a looped particle effect at the specified coordinates
    local particleFx = "core"  -- Change this to the name of your flame particle effect
    local particleScale = scale or 1.0  -- Default scale if not provided
    local particleLooped = true  -- Loop the particle effect
    local particleRange = 0.0  -- Range for the particle effect
    local particleAxisX = 0.0  -- X-axis force
    local particleAxisY = 0.0  -- Y-axis force
    local particleAxisZ = 0.0  -- Z-axis force
    local particleRotationX = 0.0  -- X-axis rotation
    local particleRotationY = 0.0  -- Y-axis rotation
    local particleRotationZ = 0.0  -- Z-axis rotation
    local particleLockAxis = false  -- Lock the axis
    local particleEffect = StartParticleFxLoopedAtCoord(particleFx, particleCoords, particleAxisX, particleAxisY, particleAxisZ, particleRotationX, particleRotationY, particleRotationZ, particleScale, particleLooped, particleLockAxis, particleRange)
end

-- Function to start extinguishing fire
function StartExtinguishingFire(coords)
    PlayHoldingHoseAnimation()
    SpawnWaterParticleEffect(coords)
    PlaySoundEffect("extinguisher_sound")
    -- Trigger the server event to start extinguishing the fire
    TriggerServerEvent('fire:extinguishStart', coords)
end

-- Function to stop extinguishing fire
function StopExtinguishingFire()
    -- Trigger the server event to stop extinguishing the fire
    TriggerServerEvent('fire:extinguishStop')
end

-- Example: Keybind to start/stop extinguishing fire (you can adjust this to your keybind system)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        -- Check if the player is pressing the key to use the fire extinguisher
        if IsControlJustPressed(0, Keys['E']) then
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)

            -- Start extinguishing fire if close to one
            -- Example: Check if the player is close to a fire, then call StartExtinguishingFire(coords)
        elseif IsControlJustReleased(0, Keys['E']) then
            -- Stop extinguishing fire when the key is released
            StopExtinguishingFire()
        end
    end
end)

-- Function to display help text on the screen
function DisplayHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- Function to play holding hose animation
function PlayHoldingHoseAnimation()
    RequestAnimDict("amb@world_human_hang_out_street@male_a@enter")
    while not HasAnimDictLoaded("amb@world_human_hang_out_street@male_a@enter") do
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "amb@world_human_hang_out_street@male_a@enter", "enter", 8.0, 1.0, -1, 50, 0, false, false, false)
end

-- Function to spawn water particle effect
function SpawnWaterParticleEffect(coords)
    local particleName = "ent_amb_waterfall_splash"
    local scale = 1.0
    local duration = 2000  -- Duration in milliseconds

    -- Start the particle effect
    UseParticleFxAssetNextCall("core")
    local particleEffect = StartParticleFxNonLoopedAtCoord(particleName, coords.x, coords.y, coords.z + 0.5, 0.0, 0.0, 0.0, scale, false, false, false)
    Citizen.Wait(duration)
    StopParticleFxLooped(particleEffect, 0)
end

-- Function to play sound effect
function PlaySoundEffect(soundName)
    local soundId = GetSoundId()

    -- Convert sound name to hash
    local soundHash = GetHashKey(soundName)

    -- Play the sound effect
    PlaySoundFromEntity(soundId, soundName, playerPed, "DLC_HEIST_HACKING_SNAKE_SOUNDS", false, 0)

end

