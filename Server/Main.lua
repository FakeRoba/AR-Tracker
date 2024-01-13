local TrackingSystem = {}

IsJobOnConfig = function(Job)
    for k, v in pairs(SAR.Settings["Jobs"]) do
        if k == Job then
            return true
        end
    end

    return false
end

function GetIdentity(source)
	local identifier = ESX.GetPlayerFromId(source).identifier

    local response = MySQL.query.await('SELECT firstname, lastname FROM users WHERE identifier = ?', {
        identifier
    })

    if response and response[1] and response[1]['firstname'] ~= nil then

        local data = {
            firstname	= response[1]['firstname'],
            lastname	= response[1]['lastname'],
        }

        return data
    end
end

AddEventHandler('esx:setJob', function(source, job, lastJob)
    job = job.name
    lastJob = lastJob.name
    if job == lastJob then
        return
    end

    TrackingSystem[source].Job = job

    if not IsJobOnConfig(job) then
        if TrackingSystem[source].Tracker then
            TrackingSystem[source].Tracker = false

            for k, v in pairs(TrackingSystem) do
                TriggerClientEvent("AR-Tracker:RemoveTrack", k, source, true)
            end
        end

        return
    end

    local AlreadyOnTrack = TrackingSystem[source].Tracker

    if not AlreadyOnTrack and SAR.Settings.AutomaticTrackOn[job] then
        TrackingSystem[source].Tracker = true
    end

    if not AlreadyOnTrack and TrackingSystem[source].Tracker then
        for k, v in pairs(TrackingSystem) do
            TriggerClientEvent("AR-Tracker:AddTrack", k, source, TrackingSystem[source])
        end
    end
end)

RegisterCommand("trackon", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not IsJobOnConfig(xPlayer.job.name) or TrackingSystem[source].Tracker then return end

    TrackingSystem[source].Tracker = true

    for k, v in pairs(TrackingSystem) do
        TriggerClientEvent("AR-Tracker:AddTrack", k, source, TrackingSystem[source])
    end

end)

RegisterCommand("trackoff", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not IsJobOnConfig(xPlayer.job.name) or not TrackingSystem[source].Tracker then return end

    TrackingSystem[source].Tracker = false
    TrackingSystem[source].Job = xPlayer.job.name

    for k, v in pairs(TrackingSystem) do
        TriggerClientEvent("AR-Tracker:RemoveTrack", k, source, true)
    end
end)

RegisterNetEvent("AR-Tracker:PlayerJoined", function()
    local Source = source
    if TrackingSystem[Source] then return end

    local Identity = nil

    repeat
        Identity = GetIdentity(Source)
        if not Identity then
            Wait(4000)
        end
    until Identity

    local xPlayer = nil

    repeat
        xPlayer = ESX.GetPlayerFromId(Source)
        Wait(1100)
    until xPlayer and xPlayer.job and xPlayer.job.name

    TrackingSystem[Source] = {Job = xPlayer.job.name, name = Identity.firstname, lastname = Identity.lastname, Tracker = false}

    if SAR.Settings.AutomaticTrackOn[xPlayer.job.name] then
        TrackingSystem[Source].Tracker = true
    end

    TriggerClientEvent("AR-Tracker:GiveTrackList", Source, TrackingSystem)

    for k, v in pairs(TrackingSystem) do
        TriggerClientEvent("AR-Tracker:AddTrack", k, Source, TrackingSystem[Source])
    end
end)

AddEventHandler('playerDropped', function()
    local Source = source
    if not TrackingSystem[Source] then return end

    TrackingSystem[Source] = nil

    for k, v in pairs(TrackingSystem) do
        TriggerClientEvent("AR-Tracker:RemoveTrack", k, Source)
    end
end)


ESX.RegisterServerCallback("AR-Tracker:GetSettings", function(src, cb)
    return cb(SAR.Settings)
end)
