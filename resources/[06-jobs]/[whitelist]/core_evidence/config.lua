Config = {

-- IMPORTANT! To configure report text navigate to /html/script.js and find the text you want to replace

EvidenceReportInformationBullet = "firstname, lastname, id, sex", -- The information displayd from users table in mysql in the evidence report (ONLY CHANGE IF YOU KNOW WHAT ARE YOU DOING)
EvidenceReportInformationFingerprint = "firstname, lastname, id, sex", -- The information displayd from users table in mysql in the evidence report (ONLY CHANGE IF YOU KNOW WHAT ARE YOU DOING)
EvidenceReportInformationBlood = "firstname, lastname, id, sex", -- The information displayd from users table in mysql in the evidence report (ONLY CHANGE IF YOU KNOW WHAT ARE YOU DOING)

ShowBloodSplatsOnGround = false, -- Show blood on the ground when player is shot
PlayClipboardAnimation = true, -- Play clipboard animation when reading report

JobRequired = 'pj', -- The job needed to use evidence system
JobGradeRequired = 0, -- The MINIMUM job grade required to use evidence system (If you use 0 all job grades can use the system)

CloseReportKey = 'BACKSPACE', -- The key used to close the report
PickupEvidenceKey = 'E', -- The key used to pick up evidence

EvidenceAlanysisLocation = vector3(486.82,-984.72,30.69), -- The place where the evidence will be analyzed and report generated
EvidenceAlanysisLocation2 = vector3(-1094.75,-830.01,10.28), -- The place where the evidence will be analyzed and report generated
TimeToAnalyze = 10000, -- Time in miliseconds to analyze the given evidence
TimeToFindFingerprints = 3000, -- Time in miliseconds to find fingerprints in a car

--UPDATE V2
RainRemovesEvidence = true, -- Removes evidence when it starts raining!
TimeBeforeCrimsCanDestory = 300, -- Seconds before Criminals can destroy evidence (300 is the time when evidence coolsdown and shows up as WARM)
EvidenceStorageLocation = vector3(482.1736, -984.658, 30.689), -- The place where all evidence are being archived! You can view old evidence or delete it
EvidenceStorageLocation2 = vector3(122.8611, -768.568, 242.15),
--
Text = {

	--UPDATE V2
	['not_in_vehicle'] = 'Para o utilizar, é necessário estar num veículo!',
	['remove_evidence'] = 'Destruir provas [~r~E~w~]',
	['cooldown_before_pickup'] = 'As provas estão demasiado quentes para serem destruidas',
	['evidence_removed'] = 'Prova Destruida!',
	['open_evidence_archive'] = '[~b~E~w~] Ver Arquivos de provas',
	['evidence_archive'] = 'Arquivo de provas',
	['view'] = 'Abrir',
	['delete'] = 'Deletar',
	['report_list'] = 'Prova #',
	['evidence_deleted_from_archive'] = 'Provas eliminadas do arquivo!',
	--

	['evidence_colleted'] = 'Prova #{number} recolhida!',
	['no_more_space'] = 'Só podes carregar 3 amostras',
	['analyze_evidence'] = '[~b~E~w~] Analisar as amostras',
	['evidence_being_analyzed'] = 'As provas estão a ser analisadas! Aguarda',
	['evidence_being_analyzed_hologram'] = '~b~As provas estão a ser analisadas',
	['read_evidence_report'] = '[~b~E~w~] Ler Relatório',
	['analyzing_car'] = 'O carro está a ser analisado! Aguarda',
	['pick_up_evidence_text'] = '[~r~E~w~] Recolher Provas ',
	['no_fingerprints_found'] = 'Não foram encontradas impressões digitais!',
	['no_evidence_to_analyze'] = "Sem provas para analisar!",
	['shell_hologram'] = '~w~Cartuxos de ~b~ {guncategory}',
	['blood_hologram'] = '~r~Amostra de Sangue',

	['blood_after_0_minutes'] = 'Estado: ~r~FRESCO',
	['blood_after_5_minutes'] = 'Estado: ~y~RECENTE',
	['blood_after_10_minutes'] = 'Estado: ~b~ANTIGO',

	['shell_after_0_minutes'] = 'Estado: ~r~QUENTE',
	['shell_after_5_minutes'] = 'Estado: ~y~TÉPIDO',
	['shell_after_10_minutes'] = 'Estado: ~b~FRIO',


	['submachine_category'] = 'SMG',
	['pistol_category'] = 'Pistola',
	['shotgun_category'] = 'Shotgun',
	['assault_category'] = 'Rifle',
	['lightmachine_category'] = 'SMG',
	['sniper_category'] = 'Snipper',
	['heavy_category'] = 'Arma Pesada'


}
	

}

function SendTextMessage(msg)
	exports['okokNotify']:Alert("INFO", msg, 5000, 'info')
end