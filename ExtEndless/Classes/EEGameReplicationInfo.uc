// ================================================================
//  EEGameReplicationInfo
// ================================================================
//  I made this class because of new OutbreakEvent class
// ================================================================

class EEGameReplicationInfo extends KFGameReplicationInfo_Endless;

var byte EE_BOSS_WAVE;

// OutbreakEvent
simulated function bool IsWeeklyWave(out int ModIndex){
	if (CurrentWeeklyMode != INDEX_NONE){
		ModIndex = class'ExtOutbreakEvent'.static.GetOutbreakId(CurrentWeeklyMode); // Modified Line
	}
	return CurrentWeeklyMode != INDEX_NONE;
}

simulated function WaveStarted(){
	local int ModeIndex;
	ModeIndex = INDEX_NONE;
	if (CurrentSpecialMode != INDEX_NONE){
		ModeIndex = CurrentSpecialMode;
	}
	else if (CurrentWeeklyMode != INDEX_NONE){
		ModeIndex = class'ExtOutbreakEvent'.static.GetOutbreakId(CurrentWeeklyMode); // Modified Line
	}
	class'KFTraderDialogManager'.static.BroadcastEndlessStartWaveDialog(WaveNum, ModeIndex, WorldInfo);
}

// BossFrequency
/*
simulated function bool IsBossWave(){
	if(EE_BOSS_WAVE == 0) return false;
	else return WaveNum > 0 && WaveNum % EE_BOSS_WAVE == 0;
}

simulated function bool IsBossWaveNext(){
	if(EE_BOSS_WAVE == 0) return false;
	else return WaveNum > 0 && (WaveNum + 1) % EE_BOSS_WAVE == 0;
}
*/