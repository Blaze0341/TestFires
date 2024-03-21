Config = {}

-- Metadata
Config.Version = "1.0"
Config.Creator = "Blaze"


-- Job configuration
Config.FirefighterJob = "ambulance"

-- Message configuration
Config.Message = "QBCore" -- Default Alert: QBCore, ps-dispatch, or none
Config.AlertMessage = "A fire has been reported at %s. Please respond immediately."

Config.FireSpawnIntervalMinutes = 20  -- New fire spawns every 20 minutes

-- Number of flames per fire configuration
Config.NumFlamesPerFire = 1  -- Default number of flames per fire

-- Fire configurations
Config.Fires = {
    {
        type = "forest",
        locations = {
            {
                name = "Forest Area 1",
                areas = {
                    {
                        name = "Forest Area 1A",
                        coords = vector3(100.0, 200.0, 30.0)
                        flames = {
                            min = 1,
                            max = 2  -- Randomly spawn between 1 and 2 flames
                            scale = 1.0  -- Scale of flames
                        }
                    },
                    {
                        name = "Forest Area 1B",
                        coords = vector3(150.0, 250.0, 30.0)
                        flames = {
                            min = 1,
                            max = 2  -- Randomly spawn between 1 and 2 flames
                            scale = 1.0  -- Scale of flames
                        }
                    }
                },
                enabled = true
            },
            {
                name = "Forest Area 2",
                areas = {
                    {
                        name = "Forest Area 2A",
                        coords = vector3(300.0, 400.0, 30.0)
                        flames = {
                            min = 1,
                            max = 2  -- Randomly spawn between 1 and 2 flames
                            scale = 1.0  -- Scale of flames
                        }
                    },
                    {
                        name = "Forest Area 2B",
                        coords = vector3(350.0, 450.0, 30.0)
                        flames = {
                            min = 1,
                            max = 2  -- Randomly spawn between 1 and 2 flames
                            scale = 1.0  -- Scale of flames
                        }
                    }
                },
                enabled = false
            }
        }
    },
    {
        type = "building",
        locations = {
            {
                name = "City Buildings",
                areas = {
                    {
                        name = "Building Area 1",
                        coords = vector3(200.0, 300.0, 30.0)
                        flames = {
                            min = 1,
                            max = 2  -- Randomly spawn between 1 and 2 flames
                            scale = 1.0  -- Scale of flames
                        }
                    },
                    {
                        name = "Building Area 2",
                        coords = vector3(250.0, 350.0, 30.0)
                        flames = {
                            min = 1,
                            max = 2  -- Randomly spawn between 1 and 2 flames
                            scale = 1.0  -- Scale of flames
                        }
                    }
                },
                enabled = true
            }
        }
    }
}


