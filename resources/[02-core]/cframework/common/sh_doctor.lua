function LoadDoctor()
    local self = {}

    self.doctorModel = `s_m_m_doctor_01`
    self.nurseModel = `s_f_y_scrubs_01`
    self.maxEmsForDoctor = 100
    self.priceBase = 5000
    self.priceWithEms = 10000
    self.emsThreshold = 2
    self.holdTime = 5000

    self.locations = {
        {
            doctor = vector4(-816.34, -1237.86, 6.35, 55.09), -- Hospital Cidade
            bed = vector4(-806.56, -1228.95, 8.26, 317.64),
            nursePed = vector4(-806.49, -1227.07, 6.34, 180.94),
            nursePed2 = vector4(-804.76, -1228.67, 6.34, 103.66),
            medicPed = vector4(-807.48, -1228.63, 6.34, 231.23),
        },
        {
            doctor = vector4(1673.81, 3668.03, 35.34, 208.80), -- Hospital Sandy Shores (erro)
            bed = vector4(1676.12, 3647.24, 36.34, 29.07),
            nursePed = vector4(1677.03, 3648.43, 34.34, 154.30),
            nursePed2 = vector4(1675.80, 3649.88, 34.34, 174.96),
            medicPed = vector4(1675.03, 3647.03, 34.34, 302.73),
        },
        {
            doctor = vector4(1102.27, 2724.66, 38.71, 183.91), -- Hospital Sandy Shores 2 (erro)
            bed = vector4(1122.67, 2729.32, 39.39, 80.76),
            nursePed = vector4(1120.62, 2728.06, 37.71, 310.18),
            nursePed2 = vector4(1120.70, 2730.38, 37.71, 241.45),
            medicPed = vector4(1122.52, 2728.41, 37.71, 355.12),
        },
        {
            doctor = vector4(-251.82, 6337.23, 32.45, 224.62), -- Hospital Paleto Bay (erro)
            bed = vector4(-244.25, 6317.57, 33.45, 45.09),
            nursePed = vector4(-249.96, 6314.93, 31.45, 261.49),
            nursePed2 = vector4(-247.00, 6315.52, 31.45, 148.95),
            medicPed = vector4(-248.66, 6313.85, 31.42, 314.18),
        },
        {
            doctor = vector4(-533.21, 7378.84, 12.84, 317.79), -- Hospital Roxwood
            bed = vector4(-530.45, 7383.32, 8.45, 48.96),
            nursePed = vector4(-531.19, 7385.48, 7.52, 175.23),
            nursePed2 = vector4(-533.26, 7383.92, 7.52, 288.93),
            medicPed = vector4(-531.38, 7382.88, 7.52, 327.33),
        },
        {
            doctor = vector4(4964.59, -5101.83, 2.96, 166.39), -- Hospital Cayo
            bed = vector4(4949.61, -5097.48, 4.00, 245.25),
            nursePed = vector4(4949.61, -5098.57, 3.06, 17.97),
            nursePed2 = vector4(4951.68, -5097.24, 3.06, 107.48),
            medicPed = vector4(4950.13, -5096.71, 3.06, 163.25),
        },
    }

    return self
end