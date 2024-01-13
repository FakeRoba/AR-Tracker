SAR = {}

SAR.Settings = {

    TranslateJob = {
        ["police"] = "Poliisi",
        ["ambulance"] = "Ensihoito",
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
    },

    ["AutomaticTrackOn"] = {
        ["police"] = true,
        ["ambulance"] = true,
    },
}