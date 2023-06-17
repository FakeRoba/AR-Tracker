AR = {}

AR.Settings = {
    TrackerName = function(Name, Lastname, Job)
        return string.format("%s - %s | %s", Name, Lastname, Job)
    end, -- Result in map (example): "Roba - Molotov | Asianajaja"

    ["blip"] = {

        ["police"] = function(Ped)
            if GetEntityHealth(Ped) <= 0 or IsEntityDead(Ped) then
                return {
                    sprite = 303,
                    scale = 0.7,
                    color = 1,
                    display = 6,
                    category = 2,
                    cone = false,
                    indicator = false,
                }
            elseif IsPedOnAnyBike(Ped) then
                return {
                    sprite = 348,
                    scale = 1.0,
                    color = 3,
                    display = 6,
                    category = 2,
                    cone = false,
                    indicator = false,
                    sirenFlashing = true,
                    flashInterval = 250,
                }
            elseif IsPedInAnyHeli(Ped) then
                return {
                    sprite = 15,
                    scale = 1.0,
                    color = 3,
                    display = 6,
                    category = 2,
                    cone = false,
                    indicator = false,
                }
            elseif IsPedInAnyBoat(Ped) then
                return {
                    sprite = 427,
                    scale = 1.0,
                    color = 3,
                    display = 6,
                    category = 2,
                    cone = false,
                    indicator = false,
                }
            elseif IsPedInAnyVehicle(Ped) then
                return {
                    sprite = 227,
                    scale = 1.0,
                    color = 3,
                    display = 6,
                    category = 2,
                    cone = false,
                    indicator = false,
                    sirenFlashing = true,
                    flashInterval = 550,
                }
            elseif (IsPedSprinting(Ped) or IsPedRunning(Ped) or IsPedWalking(Ped) or IsPedStill(Ped)) then
                return {
                    sprite = 1,
                    scale = 0.5,
                    color = 3,
                    display = 6,
                    category = 2,
                    cone = true,
                    indicator = false
                }
            end

            return false
        end,

        ["gang123"] = function(Ped)
            return {
                sprite = 1,
                scale = 0.5,
                color = 3,
                display = 6,
                category = 2,
                cone = true,
                indicator = false
            }
        end,

    }
}