function LoadCommunityService()
    local self = {}

    self.ServiceExtensionOnEscape = 8

    self.ServiceLocation = {x =  1680.22, y = 2513.13, z = 45.56}
    self.ReleaseLocation = {x = 427.33, y = -979.51, z = 30.2}

    self.ServiceLocations = {
        { type = "cleaning",  coords = vector3(1679.8, 2503.9, 45.56)   },
        { type = "cleaning",  coords = vector3(1677.91, 2501.49, 45.56) },
        { type = "cleaning",  coords = vector3(1675.25, 2503.82, 45.56) },
        { type = "cleaning",  coords = vector3(1672.88, 2506.02, 45.56) },
        { type = "cleaning",  coords = vector3(1670.46, 2508.2, 45.56)  },
        { type = "cleaning",  coords = vector3(1668.72, 2509.89, 45.56) },
        { type = "cleaning",  coords = vector3(1670.74, 2512.4, 45.56)  },
        { type = "cleaning",  coords = vector3(1672.72, 2517.75, 45.56) },
        { type = "gardening", coords = vector3(1667.86, 2517.64, 45.56) },
        { type = "gardening", coords = vector3(1663.68, 2520.92, 45.56) },
        { type = "gardening", coords = vector3(1660.08, 2517.46, 45.56) },
        { type = "gardening", coords = vector3(1656.36, 2512.46, 45.56) },
        { type = "gardening", coords = vector3(1658.4, 2506.67, 45.56)  }
    }

    --[[self.Uniforms = {
        prison_wear = {
            male = {
                ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                ['torso_1']  = 421, ['torso_2']  = 0,
                ['arms']     = 0,
                ['pants_1']  = 0,   ['pants_2']  = 7,
                ['shoes_1']  = 15,  ['shoes_2']  = 1,
            },
            female = {
                ['tshirt_1'] = 15,   ['tshirt_2'] = 0,
                ['torso_1']  = 447,  ['torso_2']  = 0,
                ['arms']     = 0,
                ['pants_1'] = 3,     ['pants_2']  = 15,
                ['shoes_1']  = 3,    ['shoes_2']  = 0,
            }
        }
    }]]

    return self
end