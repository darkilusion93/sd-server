if not IsDuplicityVersion() then
    function getLocalValue(vType, vDefault)
        local kvpValue = GetResourceKvpString(vType)
        if kvpValue ~= nil then return kvpValue end
        return vDefault
    end
end

DEVELOPER_MODE = false

Config = Config or {}

Config.RepeatTimeout = 3000--3000
Config.CallRepeats = 10
Config.OpenPhone = 288


Config.BusinessAdverts = {
    ['police'] = {
        color = 'rgba(23, 99, 186, 1)',
        textcolor = '#FFFFFF',
        header = '👨‍✈️ Policia'
    },
    ['ambulance'] = {
        color = '#fcfc03',
        textcolor = '#000000',
        header = '👨🏼‍⚕️ EMS'
    },
    ['tribunal'] = {
        color = 'rgba(255, 255, 255, 1)',
        textcolor = '#000000',
        header = '🏛 Tribunal' 
    },
    ['nautica'] = {
        color = 'rgba(3, 115, 252, 1)',
        textcolor = '#FFFFFF',
        header = '🛥️ Sem Destino Nautica'
    },
    ['taxi'] = {
        color = 'rgba(3, 115, 252, 1)',
        textcolor = '#FFFFFF',
        header = '🛥️ Sea and Sky Customs'
    },
    ['ilagal4'] = {
        color = 'rgba(201, 191, 143, 1)',
        textcolor = '#000000',
        header = '🦌 Abrigo do Pastor'
    },
    ['weazelnews'] = {
        color = 'rgba(0, 127, 224, 1)',
        textcolor = '#000000',
        header = '📺 Sem Destino Play'
    },
    ['nightclub'] = {
        color = 'rgba(208, 0, 255, 1)',
        textcolor = '#ffffff',
        header = '🎵 Vanilla'
    },
    ['kiwi'] = {
        color = 'rgba(130, 21, 21, 1)',
        textcolor = '#ffffff',
        header = '🎲 Casino Atlantis'
    },
    ['governo'] = {
        color = 'rgba(255, 255, 255, 1)',
        textcolor = '#000000',
        header = '🏛 Governo'
    },
    ['oficina3'] = {
        color = 'rgba(255, 191, 0, 1)',
        textcolor = '#000000',
        header = '🚗 Los Santos Custom'
    },
    ['oficina2'] = {
        color = 'rgba(255, 0, 64, 1)',
        textcolor = '#ffffff',
        header = '🔧 Benny\'s'
    },
    ['ammu'] = {
        color = 'rgba(88, 196, 90, 1)',
        textcolor = '#ffffff',
        header = '🔫 Ammu-Nation'
    },
    ['ammu2'] = {
        color = 'rgba(88, 196, 90, 1)',
        textcolor = '#ffffff',
        header = '🔫 Ammu-Nation Sandy'
    },
    ['oficina1'] = {
        color = 'rgba(223, 120, 255, 1)',
        textcolor = '#ffffff',
        header = '🥟 6STR'
    },
    ['oficina5'] = {
        color = 'rgba(0, 255, 191, 1)',
        textcolor = '#000000',
        header = '🔧 Maré Custom'
    },
}
