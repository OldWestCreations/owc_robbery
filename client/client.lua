local VORPcore = {}

Citizen.CreateThread(function()
    TriggerEvent("getCore", function(core)
        VORPcore = core
    end)
end)

local T = Translation.Langs[Lang] 
local robbedPeds = {}

function GIVEANIM(npc)
    local dict = 'script_rc@chrb@ig1_visit_clerk'
    local anim = 'arthur_gives_money_player'

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
    end  

    if DoesEntityExist(npc) and not IsEntityDead(npc) then
        ClearPedTasks(npc)
        TaskStandStill(npc, 3000)
        FreezeEntityPosition(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        SetEntityInvincible(npc, true)

        TaskPlayAnim(npc, dict, anim, 8.0, 8.0, 2500, 50, 0, false, false, false)
        Citizen.Wait(2500)

        FreezeEntityPosition(npc, false)
        SetBlockingOfNonTemporaryEvents(npc, false)
        SetEntityInvincible(npc, false)
    end
end

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId())

        if aiming and DoesEntityExist(targetPed) and not IsPedAPlayer(targetPed) then
            if IsPedArmed(playerPed, 4) then 
                local pedModel = GetEntityModel(targetPed)

                if NetworkGetEntityIsNetworked(targetPed) then
                    local pedID = NetworkGetNetworkIdFromEntity(targetPed)
                    TriggerServerEvent("npcrobbery:attemptRobbery", pedID, pedModel)
                else
                    print("^3Warning: Target NPC is not networked. Robbery not possible.^7")
                end
            end
        end
        Citizen.Wait(500)
    end
end)

RegisterNetEvent("npcrobbery:startRobbery")
AddEventHandler("npcrobbery:startRobbery", function(pedID)
    local targetPed = NetworkGetEntityFromNetworkId(pedID)
    local playerPed = PlayerPedId()

    if DoesEntityExist(targetPed) then
        ClearPedTasksImmediately(targetPed)
        SetBlockingOfNonTemporaryEvents(targetPed, true)
        SetEntityAsMissionEntity(targetPed, true, true)
        SetPedCanRagdoll(targetPed, false)
        SetPedFleeAttributes(targetPed, 0, false)
        SetPedCombatAttributes(targetPed, 17, true)

        TaskTurnPedToFaceEntity(targetPed, playerPed, 1000)
        Citizen.Wait(1000)
        FreezeEntityPosition(targetPed, true)
        TaskHandsUp(targetPed, Config.surrenderDuration, playerPed, -1, true)

        Citizen.Wait(Config.surrenderDuration)
        ClearPedTasks(targetPed)
        Citizen.Wait(500)

        GIVEANIM(targetPed)
        TriggerServerEvent("npcrobbery:giveLoot", GetEntityCoords(targetPed))

        Citizen.Wait(3000)
        FreezeEntityPosition(targetPed, false)
        SetBlockingOfNonTemporaryEvents(targetPed, false)
        SetPedCanRagdoll(targetPed, true)
        TaskWanderStandard(targetPed, 10.0, 10)
    end
end)
