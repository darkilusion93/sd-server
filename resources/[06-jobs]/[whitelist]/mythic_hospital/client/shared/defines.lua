
-- General
isInHospitalBed = false

-- Hospital
bedOccupying = nil
bedObject = nil
bedOccupyingData = nil
currentTp = nil
usedHiddenRev = false

-- Wound
isBleeding = 0
bleedTickTimer, advanceBleedTimer = 0, 0
fadeOutTimer, blackoutTimer = 0, 0

onPainKiller = 0
wasOnPainKillers = false

onDrugs = 0
wasOnDrugs = false

legCount = 0
armcount = 0
headCount = 0

playerHealth = nil
playerArmour = nil

limbNotifId = 'MHOS_LIMBS'
bleedNotifId = 'MHOS_BLEED'
bleedMoveNotifId = 'MHOS_BLEEDMOVE'

BodyParts = {
    ['HEAD'] = { label = 'Cabeça', causeLimp = false, isDamaged = false, severity = 0 },
    ['NECK'] = { label = 'Pescoço', causeLimp = false, isDamaged = false, severity = 0 },
    ['SPINE'] = { label = 'Espinha', causeLimp = true, isDamaged = false, severity = 0 },
    ['UPPER_BODY'] = { label = 'Peito', causeLimp = false, isDamaged = false, severity = 0 },
    ['LOWER_BODY'] = { label = 'Barriga', causeLimp = true, isDamaged = false, severity = 0 },
    ['LARM'] = { label = 'Braço Esquerdo', causeLimp = false, isDamaged = false, severity = 0 },
    ['LHAND'] = { label = 'Mão Esquerda', causeLimp = false, isDamaged = false, severity = 0 },
    ['LFINGER'] = { label = 'Dedos da Mão Esquerda', causeLimp = false, isDamaged = false, severity = 0 },
    ['LLEG'] = { label = 'Perna Esquerda', causeLimp = true, isDamaged = false, severity = 0 },
    ['LFOOT'] = { label = 'Pé Esquerdo', causeLimp = true, isDamaged = false, severity = 0 },
    ['RARM'] = { label = 'Braço Direito', causeLimp = false, isDamaged = false, severity = 0 },
    ['RHAND'] = { label = 'Mão Direita', causeLimp = false, isDamaged = false, severity = 0 },
    ['RFINGER'] = { label = 'Dedos da Mão Direita', causeLimp = false, isDamaged = false, severity = 0 },
    ['RLEG'] = { label = 'Perna Direita', causeLimp = true, isDamaged = false, severity = 0 },
    ['RFOOT'] = { label = 'Pé Direito', causeLimp = true, isDamaged = false, severity = 0 },
}

injured = {}