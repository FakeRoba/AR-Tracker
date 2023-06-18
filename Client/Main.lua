local ESX = exports["es_extended"]:getSharedObject()

local Config = nil
local TrackingList = nil
local Blips = {}

TranslateJob = function(Job)
    return Config.TranslateJob[Job] or Job
end

RefreshBlip = function(Source, Settings)
    local Blip = nil

    if not DoesBlipExist(Blips[Source]) then
        Blip = AddBlipForEntity(GetPlayerPed(GetPlayerFromServerId(Source)))
    else
        Blip = Blips[Source]
    end

    SetBlipSprite(Blip, Settings.sprite)
    SetBlipColour(Blip, Settings.color)
    SetBlipScale(Blip, Settings.scale)
    SetBlipDisplay(Blip, Settings.display)
    SetBlipCategory(Blip, Settings.category)
    SetBlipShowCone(Blip, Settings.cone)
    ShowCrewIndicatorOnBlip(Blip, Settings.indicator)
    SetBlipFlashes(Blip, Settings.sirenFlashing)
    SetBlipAsShortRange(Blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(AR.Settings["TrackerName"](TrackingList[Source].name, TrackingList[Source].lastname, TranslateJob(TrackingList[Source].Job)))
    EndTextCommandSetBlipName(Blip)

    Blips[Source] = Blip

    Citizen.CreateThread(function()
        while IsVehicleSirenOn(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(Source)))) do
            Wait(50)
        end
        SetBlipFlashes(Blip, false)
    end)

end

RegisterNetEvent("AR-Tracker:AddTrack", function(Source, Data)
    TrackingList[Source] = Data
end)

RegisterNetEvent("AR-Tracker:RemoveTrack", function(Source, track)
    TrackingList[Source].Tracker = false

    for k, v in pairs(Blips) do
        if tonumber(k) == tonumber(Source) then
            RemoveBlip(v)
            if not track then
                TrackingList[Source] = nil
            end
        end
    end

    if GetPlayerServerId(PlayerId()) == Source then
        for k, v in pairs(Blips) do
            RemoveBlip(v)
        end
    end
end)

RegisterNetEvent("AR-Tracker:GiveTrackList", function(List)
    while not Config do
        Wait(1100)
    end

    TrackingList = List
end)

RegisterNetEvent('esx:setJob', function(job)
    if ESX.PlayerData.job == job then
        return
    end

	ESX.PlayerData.job = job
    ExecuteCommand("trackoff")
end)

Citizen.CreateThread(function()
    TriggerServerEvent("AR-Tracker:PlayerJoined")

    while not ESX do
        Wait(1100)
    end

    ESX.PlayerData = ESX.GetPlayerData()

    ESX.TriggerServerCallback("AR-Tracker:GetSettings", function(Settings)
        Config = Settings
    end)

    while not Config or not TrackingList do
        Wait(1100)
    end

    while true do
        local CurrentPedID = GetPlayerServerId(PlayerId())
        local Jobs = Config["Jobs"][TrackingList[CurrentPedID].Job]

        if Jobs and TrackingList[CurrentPedID].Tracker then

            for k, v in pairs(TrackingList) do

                if (Jobs[v.Job] == "true" and v.Tracker) or (Jobs[v.Job] == "false") and AR.Settings["blip"][v.Job] then
                    local Settings = AR.Settings["blip"][v.Job](GetPlayerPed(GetPlayerFromServerId(k)))

                    if Settings then
                        RefreshBlip(k, Settings)
                    end

                end

            end

        end

        Citizen.Wait(1100)
    end
end)