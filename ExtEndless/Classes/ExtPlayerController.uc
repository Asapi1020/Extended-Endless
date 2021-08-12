// ===========================================
//  ExtPlayerController
// ===========================================
//  For the ready system and outbreak events
// ===========================================

class ExtPlayerController extends KFPlayerController_WeeklySurvival;

var bool bIsReadyForNextWave;

var array<PerkInfo> OriginalPerkList;

/* Coliseum */
function ColiseumAdjust(){
	local int i;
	local KFPerk_Berserker Zerk;

	Zerk = spawn(class'KFPerk_Berserker');

	OriginalPerkList[0] = PerkList[0];
	for(i=1; i<10; i++){
		OriginalPerkList[i] = PerkList[i];
		PerkList[i] = PerkList[0];
	}
	Zerk.OnWaveStart();
}

function ColiseumReset(){
	local int i;
	for(i=1; i<10; i++){
		PerkList[i] = OriginalPerkList[i];
	}
}

DefaultProperties
{
	bIsReadyForNextWave = false
}