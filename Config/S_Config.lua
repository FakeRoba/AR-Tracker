SAR = {}

SAR.Settings = {

    TranslateJob = {
        ["police"] = "Poliisi",
        ["ambulance"] = "Ensihoito",
        ["asianajaja"] = "Asianajaja"
    },

    ["Jobs"] = {
        ["police"] = {
            ["police"] = "true", -- Trackon
            ["ambulance"] = "true", -- Trackon
        },
        ["ambulance"] = {
            ["ambulance"] = "true", -- Trackon
            ["police"] = "true", -- Trackon
        },
        ["asianajaja"] = {
            ["asianajaja"] = "true", -- Trackon
        },
    },

    ["AutomaticTrackOn"] = {
        ["police"] = true,
        ["ambulance"] = true,
    },
}