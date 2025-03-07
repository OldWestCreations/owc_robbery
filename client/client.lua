local robbedNPCs = {}

local animalModels = Config.AnimalModels

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local aiming, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())

        if aiming and DoesEntityExist(entity) and IsEntityAPed(entity) and not IsPedAPlayer(entity) then
            local model = GetEntityModel(entity)
            
            local isAnimal = false
            for _, animalModel in pairs(animalModels) do
                if model == GetHashKey(animalModel) then
                    isAnimal = true
                    break
                end
            end

            if not isAnimal then
                local npcNetId = NetworkGetNetworkIdFromEntity(entity)

                if IsPedArmed(playerPed, 4) then
                    if not robbedNPCs[npcNetId] then
                        robbedNPCs[npcNetId] = true
                        FreezeEntityPosition(entity, true)
                        Citizen.Wait(1500)

                        local shouldSurrender = math.random() < Config.SurrenderChance

                        if shouldSurrender then
                            TaskHandsUp(entity, 5000, playerPed, -1, true)
                            Citizen.Wait(3000)
                            TriggerServerEvent('npc:dropMoney', npcNetId, math.random(Config.MinMoney * 100, Config.MaxMoney * 100) / 100, false)
                            TriggerServerEvent('npc:playGiveAnim', npcNetId)
                        else
                            SetPedFleeAttributes(entity, 0, false)
                            SetBlockingOfNonTemporaryEvents(entity, true)
                            SetPedCombatAttributes(entity, 5, true)
                            SetPedCombatAttributes(entity, 46, true)
                            SetPedCombatAttributes(entity, 0, true)
                            SetPedCombatAbility(entity, 2) 
                            SetPedCombatMovement(entity, 1)
                            SetPedCombatRange(entity, 0)
                            SetPedSeeingRange(entity, 100.0)
                            SetPedHearingRange(entity, 100.0)
                            SetPedCanRagdoll(entity, false)   

                            if math.random() < Config.WeaponChance then
                                GiveWeaponToPed(entity, GetHashKey("WEAPON_REVOLVER_CATTLEMAN"), 6, false, true)
                                TaskCombatPed(entity, playerPed, 0, 16)
                            else
                                TaskCombatPed(entity, playerPed, 0, 1)
                            end

                            TriggerServerEvent('npc:dropMoney', npcNetId, 0, true)
                        end

                        Citizen.Wait(3000)
                        FreezeEntityPosition(entity, false)
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('npc:playGiveAnim')
AddEventHandler('npc:playGiveAnim', function(npcNetId)
    local npc = NetworkGetEntityFromNetworkId(npcNetId)
    if DoesEntityExist(npc) and not IsPedAPlayer(npc) then
        local model = GetEntityModel(npc)
        
        local isAnimal = false
        for _, animalModel in pairs(animalModels) do
            if model == GetHashKey(animalModel) then
                isAnimal = true
                break
            end
        end
        
        if not isAnimal then
            FreezeEntityPosition(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)
            SetPedCanRagdoll(npc, false)
            SetPedFleeAttributes(npc, 0, false)
            SetPedCombatAttributes(npc, 0, false)

            ClearPedTasksImmediately(npc)

            NPC_GIVEANIM(npc)
        end
    end
end)

function NPC_GIVEANIM(npc)
    RequestAnimDict(Config.GiveMoneyAnimDict)
    while not HasAnimDictLoaded(Config.GiveMoneyAnimDict) do
        Citizen.Wait(1)
    end

    TaskPlayAnim(npc, Config.GiveMoneyAnimDict, Config.GiveMoneyAnim, 4.0, 4.0, 2500, 10, 0, false, false, false, false)
end

RegisterNetEvent('npc:makeNpcFlee')
AddEventHandler('npc:makeNpcFlee', function(npcNetId)
    local npc = NetworkGetEntityFromNetworkId(npcNetId)
    
    if DoesEntityExist(npc) then
        SetPedFleeAttributes(npc, 0, true)
        SetPedFleeBehaviorOnCombatLoss(npc, true)

        TaskReactAndFleePed(npc, GetPlayerPed(-1))

        Citizen.Wait(500)

        local x, y, z = table.unpack(GetEntityCoords(npc))
        local fleeX = x + math.random(-20, 20)
        local fleeY = y + math.random(-20, 20)
        TaskGoStraightToCoord(npc, fleeX, fleeY, z, 10.0, -1, 0.0, 0.0)
    end
end)
