// ==========================================
//  Extended Endless
// ==========================================
//  Enhanced Special / Outbreak Evenets
//  Fundamental improvement
// ==========================================

// notes
/* 
	[Problems to solve]
	Cannot apply outbreakchance change immediately.
	
	[Features to add]
	More optional specialwaves
	Control Zed Upgrade
	Control BossWaveFrequency
*/

class ExtEndless extends KFGameInfo_Endless
	config(Extended_Endless);

var bool bWaitingSetWave;
var bool bPausedTrader;
var byte WaitingNextWave;

var config bool bAutoPause;
var config bool bEnableReadySystem;
//var config byte BossWaveFrequency;

var bool bControlOutbreakChance;
var bool bControlSpecialChance;
var bool bControlOutbreakType;
var bool bControlSpecialType;
var float OriginalZTSlomoScale;
var array<float> OutbreakChosenChance;
var array<float> SpecialChosenChance;

var config float GeneralOutbreakChance;
var config string SpecificOutbreakChance;

var config float GeneralSpecialChance;
var config string SpecificSpecialChance;

var config bool bInitConfig;

/* ----------<< Fandamental improvement >>----------*/

event InitGame( string Options, out string ErrorMessage ){
	local string ConsoleOpt;
	//Initialize Config Value
	ConsoleOpt = class'GameInfo'.static.ParseOption(Options, "init");
	if(ConsoleOpt != "") bInitConfig = bool(ConsoleOpt);
	
	if(!bInitConfig) InitCfg();

	// For additional console options
	// Basic
	ConsoleOpt = class'GameInfo'.static.ParseOption(Options, "ap");
	if(ConsoleOpt != "") bAutoPause = bool(ConsoleOpt);
	ConsoleOpt = class'GameInfo'.static.ParseOption(Options, "rs");
	if(ConsoleOpt != "") bEnableReadySystem = bool(ConsoleOpt);
	ConsoleOpt = class'GameInfo'.static.ParseOption(Options, "bwf");
	/*if(ConsoleOpt != ""){
		BossWaveFrequency = byte(ConsoleOpt);
		SetBWF(byte(ConsoleOpt));
	}*/

	// Outbreak
	ConsoleOpt = class'GameInfo'.static.ParseOption(Options, "goc");
	if(ConsoleOpt == "-1") bControlOutbreakChance = false;
	else if(ConsoleOpt != ""){
		bControlOutbreakChance = true;
		GeneralOutbreakChance = FClamp(float(ConsoleOpt), 0, 1.f);
	}
	ConsoleOpt = class'GameInfo'.static.ParseOption(Options, "soc");
	if(ConsoleOpt == "-1") bControlOutbreakType = false;
	else if(ConsoleOpt != ""){
		bControlOutbreakType = true;
		ConvertStoF(ConsoleOpt, OutbreakChosenChance);
	}

	//Special
	ConsoleOpt = class'GameInfo'.static.ParseOption(Options, "gsc");
	if(ConsoleOpt == "-1") bControlSpecialChance = false;
	else if(ConsoleOpt != ""){
		bControlSpecialChance = true;
		GeneralSpecialChance = FClamp(float(ConsoleOpt), 0, 1.f);
	}

	ConsoleOpt = class'GameInfo'.static.ParseOption(Options, "ssc");
	if(ConsoleOpt == "-1") bControlSpecialType = false;
	else if(ConsoleOpt != ""){
		bControlSpecialType = true;
		ConvertStoF(ConsoleOpt, SpecialChosenChance);
	}

	//SpecialWaveStart = Max(class'GameInfo'.static.GetIntOption(Options, "specialstart", 6), 1);
	//OutbreakWaveStart = Max(class'GameInfo'.static.GetIntOption(Options, "outbreakstart", 6), 1);
	// = class'GameInfo'.static.GetIntOption(Options, "", <int>)

	SaveConfig();

	Super.InitGame( Options, ErrorMessage );

	LogInfo();
	OriginalZTSlomoScale = ZedTimeSlomoScale;
}

// --------------------------------------
function PostBeginPlay(){
	Super.PostBeginPlay();
	
	SetTimer(0.25, true, nameof(TraderDash)); // TraderDash
}

function InitCfg(){
	bInitConfig = true;
	bAutoPause = false;
	//BossWaveFrequency = 5;
	bEnableReadySystem = true;
	GeneralOutbreakChance = -1;
	SpecificOutbreakChance = "-1";
	GeneralSpecialChance = -1;
	SpecificSpecialChance = "-1";

	// Actually not cfg value
	bControlOutbreakChance = false;
	bControlOutbreakType = false;
	bControlSpecialChance = false;
	bControlSpecialType = false;
}

exec function InitValue(){
	InitCfg();
	SaveConfig();
}

function ConvertStoF(string s, array<float> F){
	local array<string> splitbuf;
	local int i;

	ParseStringIntoArray(s, splitbuf, ",", true);
	for (i=0; i<splitbuf.length; i++){
		F[i] = FClamp(float(splitbuf[i]),0,1.f);
	}
}
/*
function SetBWF(byte BWF){
	local EEGameReplicationInfo EEGRI;
	EEGRI = spawn(class'EEGameReplicationInfo');

	if (BWF <= 0) EEGRI.EE_BOSS_WAVE = 0;
	else EEGRI.EE_BOSS_WAVE = BWF;
}
*/
// Trader Dash
function TraderDash() {
	local KFPlayerController KFPC;
	local KFPawn Player;
	local name GameStateName;

	GameStateName = GetStateName();

		foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC) {
			Player = KFPawn(KFPC.Pawn);
			if (Player!=None && GameStateName == 'TraderOpen') Player.GroundSpeed = 364364.0f;
			else Player.UpdateGroundSpeed();
		}
}

// Override weapon lifespan
function bool CheckRelevance(Actor Other)
{
	local KFDroppedPickup Weap;
	local bool SuperRelevant;

	SuperRelevant = super.CheckRelevance(Other);

	Weap = KFDroppedPickup(Other);
	if(none != Weap) {
		Weap.Lifespan = 2147483647;
	}

	return SuperRelevant;
}

// Console Printer
static final function LogToConsole(string Text)
{
    local KFGameEngine KFGE;
    local KFGameViewportClient KFGVC;
    local Console TheConsole;
    
    KFGE = KFGameEngine(class'Engine'.Static.GetEngine());
    
    if (KFGE != none)
    {
        KFGVC = KFGameViewportClient(KFGE.GameViewport);
        
        if (KFGVC != none)
        {
            TheConsole = KFGVC.ViewportConsole;
            
            if (TheConsole != none)
                TheConsole.OutputText( "[Extended Endless] " $ Text);
        }
    }
}

// Chat Printer
function BroadcastExtEcho( coerce string MsgStr )
{
	local PlayerController PC;
	
	foreach WorldInfo.AllControllers(class'PlayerController', PC){
		PC.ClientMessage(MsgStr);
	}
}

// Set chat commands here
event Broadcast(Actor Sender, coerce string Msg, optional name Type){
	local string MsgHead,MsgBody,MsgHip;
	local array<String> splitbuf;
	local name GameStateName;
	
	super.Broadcast(Sender, Msg, Type);

	GameStateName = GetStateName();

	if ( Type == 'Say' ){
		ParseStringIntoArray(Msg,splitbuf," ",true);
		MsgHead = splitbuf[0];
		MsgBody = splitbuf[1];
		MsgHip = splitbuf[2];

		// Basically Ganeral
		if (Msg == "!ot" || Msg == "!opentrader") Ext_OpenTrader(KFPlayerController(Sender));
		else if(Msg == "!ecw" || Msg == "!endcurrentwave") EndCurrentWave();
		else if(MsgHead == "!nw" || Msg == "!nextwave"){
			if(MsgBody != "") SetNextWave(byte(MsgBody));
		}
		else if((Msg == "!pt" || Msg == "!pausetrader") && GameStateName == 'TraderOpen' && !MyKFGRI.bStopCountDown) PauseTraderTime();
		else if((Msg == "!upt" || Msg == "!unpausetrader") && GameStateName == 'TraderOpen' && MyKFGRI.bStopCountDown) UnpauseTraderTime();
		else if(Msg == "!cdr" || Msg == "!ready") ReadyUp(Sender);
		else if(Msg == "!cdur" || Msg == "!unready") Unready(Sender);
		else if(MsgHead == "!info"){
			if(MsgBody == "") LogInfo();
			else if(MsgBody == "basic") LogBasicInfo();
			else if(MsgBody == "outbreak") LogOutbreakInfo();
			else if(MsgBody == "special") LogSpecialInfo();
			BroadcastExtEcho("(See Console)");
		}
		else if(Msg == "!help"){
			LogHelp();
			BroadcastExtEcho("(See Console)");
		}

		// BasicSettings
		else if (MsgHead == "!ap" || MsgHead == "!autopause"){
			if(MsgBody != "") bAutoPause = bool(MsgBody);
			BroadcastExtEcho("AutoPause = " $ string(bAutoPause));
		}
		else if (MsgHead == "!rs" || MsgHead == "!readysystem" || MsgHead == "!ers"){
			if(MsgBody != "") bEnableReadySystem = bool(MsgBody);
			BroadcastExtEcho("ReadySystem = " $ string(bEnableReadySystem));
		}/*
		else if (MsgHead == "bwf" || MsgHead == "!BossWaveFrequency"){
			if(MsgBody != "") BossWaveFrequency = byte(MsgBody);
			SetBWF(BossWaveFrequency);
			BroadcastExtEcho("BossWaveFrequency = " $ string(BossWaveFrequency));
		}*/
		
		// OutbreakSettings
		else if (MsgHead == "!goc" || MsgHead == "!generaloutbreakchance"){
			if(MsgBody != ""){
				if(float(MsgBody) >= 0.f){
					GeneralOutbreakChance = float(MsgBody);
					bControlOutbreakChance = true;
				}
				else bControlOutbreakChance = false;
			}
			if(bControlOutbreakChance) BroadcastExtEcho("OutbreakChance = " $ string(GeneralOutbreakChance));
			else BroadcastExtEcho("OutbreakChance = unmodded");
		}
		else if(MsgHead == "!soc" || MsgHead == "!specificoutbreakchance"){
			if(MsgBody != ""){
				if(MsgHip != "" && 0 <= int(MsgBody) && int(MsgBody) < 10){
					bControlOutbreakType = true;
					OutbreakChosenChance[int(MsgBody)] = float(MsgHip);
				}
				else if(MsgBody == "-1") bControlOutbreakType = false;
			}
			LogOutbreakInfo();
			BroadcastExtEcho("(See Console)");
		}
		else if (MsgHead == "!boom") SetSOC(MsgBody, "Boom", 0);
		else if (MsgHead == "!tiny" || MsgHead == "!tinyterror") SetSOC(MsgBody, "TinyTerror", 1);
		else if (MsgHead == "!bobble" || MsgHead == "!bobblezeds") SetSOC(MsgBody, "BobbleZeds", 2);
		else if (MsgHead == "!pound" || MsgHead == "!poundemonium") SetSOC(MsgBody, "Poundemonium", 3);
		else if (MsgHead == "!upup" || MsgHead == "!upup&decay") SetSOC(MsgBody, "Up,Up&Decay", 4);
		else if (MsgHead == "!beef" || MsgHead == "!beefcake") SetSOC(MsgBody, "Beefcake", 5);
		else if (MsgHead == "!cranium" || MsgHead == "!craniumcracker") SetSOC(MsgBody, "CraniumCracker", 6);
		else if (MsgHead == "!zt" || MsgHead == "!zedtime") SetSOC(MsgBody, "ZedTime", 7);
		else if (MsgHead == "!blood" || MsgHead == "!bloodthirst") SetSOC(MsgBody, "BloodThirst", 8);
		else if (MsgHead == "!arach" || MsgHead == "!arachnophobia") SetSOC(MsgBody, "Arachnophobia", 9);

		// SpecialSettings
		else if (MsgHead == "!gsc" || MsgHead == "!generalspecialchance"){
			if(MsgBody != ""){
				if(MsgBody == "-1") bControlSpecialChance = false;
				else{
					bControlSpecialChance = true;
					GeneralSpecialChance = float(MsgBody);
				}
			}
			if(bControlSpecialChance) BroadcastExtEcho("SpecialChance = " $ string(GeneralSpecialChance));
			else BroadcastExtEcho("SpecialChance = unmodded");
		}
		else if (MsgHead == "!ssc" || MsgHead == "!specificspecialchance"){
			if(MsgBody != ""){
				if(MsgHip != "" && 0 <= int(MsgBody) && int(MsgBody) < 13){
					bControlSpecialType = true;
					SpecialChosenChance[int(MsgBody)] = float(MsgHip);
				}
				else if(MsgBody == "-1") bControlSpecialType = false;
			}
			LogSpecialInfo();
			BroadcastExtEcho("(See Console)");
		}
		else if (MsgHead == "!cy" || MsgHead == "!cyst") SetSSC(MsgBody, "Cyst", 0);
		else if (MsgHead == "!al" || MsgHead == "!alphaclot") SetSSC(MsgBody, "Alpha Clot", 1);
		else if (MsgHead == "!sl" || MsgHead == "!slasher") SetSSC(MsgBody, "Slasher", 2);
		else if (MsgHead == "!gf" || MsgHead == "!gorefast") SetSSC(MsgBody, "Gorefast", 3);
		else if (MsgHead == "!cr" || MsgHead == "!crawler") SetSSC(MsgBody, "Crawler", 4);
		else if (MsgHead == "!st" || MsgHead == "!stalker") SetSSC(MsgBody, "Stalker", 5);
		else if (MsgHead == "!bl" || MsgHead == "!bloat") SetSSC(MsgBody, "Bloat", 6);
		else if (MsgHead == "!si" || MsgHead == "!siren") SetSSC(MsgBody, "Siren", 7);
		else if (MsgHead == "!hu" || MsgHead == "!husk") SetSSC(MsgBody, "Husk", 8);
		else if (MsgHead == "!sc" || MsgHead == "!scrake") SetSSC(MsgBody, "Scrake", 9);
		else if (MsgHead == "!fp" || MsgHead == "!fleshpound") SetSSC(MsgBody, "Fleshpound", 10);
		else if (MsgHead == "!qp" || MsgHead == "!quarterpound") SetSSC(MsgBody, "Quarterpound", 11);
		else if (MsgHead == "!ed" || MsgHead == "!edar") SetSSC(MsgBody, "EDAR", 12);
		/* HP Fakes
		else if (MsgHead == "!hpf"){
			if(MsgBody != ""){
				if( 1 <= byte(MsgBody)){
					HPF = byte(MsgBody);
					BroadcastSTMEcho("HP Fakes = " $ string(HPF));
				} 
				else BroadcastSTMEcho("HP Fakes should be positive value!");
			}
			else BroadcastSTMEcho("HP Fakes = " $ string(HPF));
		}*/
		/* Cheats
		else if (Msg == "!fa") STM_FillAmmo(); 
		else if (Msg =="!kz") STM_KillZeds();
		else if (Msg == "!rich") STM_ImRich();
		else if (Msg == "!god") STM_God();
		else if (Msg == "!demigod") STM_DemiGod();
		*/
		SaveConfig();
	}
}

function SetSOC(string Msg, string OutbreakName, int Index){
	if(Msg != ""){
		bControlOutbreakType = true;
		OutbreakChosenChance[Index] = float(Msg);
	}
	if(bControlOutbreakType) BroadcastExtEcho(OutbreakName $ " = " $ string(OutbreakChosenChance[Index]));
	else BroadcastExtEcho(OutbreakName $ " = unmodded");
}

function SetSSC(string Msg, string SpecialName, int Index){
	if(Msg != ""){
		bControlSpecialType = true;
		SpecialChosenChance[Index] = float(Msg);
	}
	if(bControlSpecialType) BroadCastExtEcho(SpecialName $ " = " $ string(SpecialChosenChance[Index]));
	else BroadcastExtEcho(SpecialName $ " = unmodded");
}

private function Ext_OpenTrader(KFPlayerController KFPC){
	local name GameStateName;

	GameStateName = GetStateName();
	if(GameStateName == 'TraderOpen') KFPC.OpenTraderMenu();
}

function Ext_KillZeds(){
	local KFPawn_Monster	AIP;
	ForEach WorldInfo.AllPawns(class'KFPawn_Monster', AIP){
		if ( AIP.Health > 0 && PlayerController(AIP.Controller) == none){
			AIP.Died(none , none, AIP.Location);
		}
	}
}

exec function EndCurrentWave(){
	Ext_KillZeds();
	WaveEnded(WEC_WaveWon);
}

exec function SetWave(byte NewWaveNum)
{
	local int CurrRound;

	// Stop Wave
	GotoState('DebugSuspendWave');
	WaveNum = NewWaveNum - 1;
	MyKFGRI.WaveNum = WaveNum;
	bIsInHoePlus = false;

	// Reset Endless Stats to round 1.
	ResetDifficulty();
	SpawnManager.GetWaveSettings(SpawnManager.WaveSettings);
	UpdateGameSettings();

	// Apply Endless Stats round by round to ensure all numbers are correct.
	for (CurrRound = 0; CurrRound < WaveNum; CurrRound++)
	{
		if (CurrRound > 0 && (CurrRound % 5) == 0)
		{
			IncrementDifficulty();
		}

		HellOnEarthPlusRoundIncrement();
	}

	ResetAllPickups();
	
	// Restart Wave
	GotoState('PlayingWave');
}

function SetNextWave(byte NewWaveNum){
	local int CurrRound;

	BroadcastExtEcho("Next wave is set to " $ string(NewWaveNum));
	bWaitingSetWave = true;

	WaveNum = NewWaveNum - 1;
	//MyKFGRI.WaveNum = WaveNum;
	bIsInHoePlus = false;

	// Reset Endless Stats to round 1.
	ResetDifficulty();
	SpawnManager.GetWaveSettings(SpawnManager.WaveSettings);
	UpdateGameSettings();

	// Apply Endless Stats round by round to ensure all numbers are correct.
	for (CurrRound = 0; CurrRound < WaveNum; CurrRound++)
	{
		if (CurrRound > 0 && (CurrRound % 5) == 0)
		{
			IncrementDifficulty();
		}

		HellOnEarthPlusRoundIncrement();
	}

	ResetAllPickups();

}

State TraderOpen
{	
	function BeginState( Name PreviousStateName ){
		super.BeginState( PreviousStateName );
		if(bAutoPause) PauseTraderTime();
		UnreadyAllPlayers();
	}
	function CloseTraderTimer()
	{	
		bPausedTrader = false;
		if(bWaitingSetWave) MyKFGRI.WaveNum = WaveNum;;
		GotoState('PlayingWave');
	}
}

State DebugSuspendWave
{
 	ignores CheckWaveEnd;

 	function BeginState( Name PreviousStateName )
 	{
 		Ext_KillZeds();
 	}

	function EndState( Name NextStateName )
	{		
	}
}

State PlayingWave
{
	function BeginState( Name PreviousStateName ){
		TrySetNextWaveSpecial();
		super.BeginState( PreviousStateName );
	}
}

private function PauseTraderTime()
{	
	MyKFGRI.RemainingTime = 6;
	MyKFGRI.RemainingMinute = 0;
	MyKFGRI.bStopCountDown = !MyKFGRI.bStopCountDown;
	bPausedTrader = true;
	ClearTimer( 'CloseTraderTimer' );
	BroadcastExtEcho("Paused Trader!");
	//LogToConsole("Hit \"!upt\" in a chat box to unpause trader or hit \"!ready\" or \"!cdr\" to be ready.");
}


private function UnpauseTraderTime(){
	MyKFGRI.bStopCountDown = !MyKFGRI.bStopCountDown;

	MyKFGRI.RemainingTime = 6;
	MyKFGRI.RemainingMinute = 0;
	SetTimer( 6, False, 'CloseTraderTimer' );
}

/* -----Information----- */

function LogInfo(){
	LogToConsole("==========[Extended Endless Info]==========");
	LogBasicInfo();
	LogOutbreakInfo();
	LogSpecialInfo();
	LogToConsole("");
	LogToConsole("When you want to get info about chat command, hit \"!help\" into a chat box.");
}

function LogBasicInfo(){
	LogToConsole("-----<Basic Info>-----");
	LogToConsole("AutoPause = " $ string(bAutoPause));
	LogToConsole("ReadySystem = " $ string(bEnableReadySystem));
	//LogToConsole("BossWaveFrequency = " $ string(BossWaveFrequency));
}

function LogOutbreakInfo(){
	local int i;
	local array<string> SOCInfo;

	for(i=0; i<10; i++){
		if(bControlOutbreakType) SOCInfo[i] = string(OutbreakChosenChance[i]);
		else SOCInfo[i] = "unmodded";
	}

	LogToConsole("-----<Outbreak Info>-----");

	if(bControlOutbreakChance) LogToConsole("OutbreakChance = " $ string(GeneralOutbreakChance));
	else LogToConsole("OutbreakChance = unmodded");

	LogToConsole("Outbreak Boom = " $ SOCInfo[0]);
	LogToConsole("Outbreak TinyTerror = " $ SOCInfo[1]);
	LogToConsole("Outbreak BobbleZeds = " $ SOCInfo[2]);
	LogToConsole("Outbreak Poundemonium = " $ SOCInfo[3]);
	LogToConsole("Outbreak Up,Up&Decay = " $ SOCInfo[4]);
	LogToConsole("Outbreak Beefcake = " $ SOCInfo[5]);
	LogToConsole("Outbreak CraniumCracker = " $ SOCInfo[6]);
	LogToConsole("Outbreak ZedTime = " $ SOCInfo[7]);
	LogToConsole("Outbreak BloodThirst = " $ SOCInfo[8]);
	LogToConsole("Outbreak Arachnophobia = " $ SOCInfo[9]);
}

function LogSpecialInfo(){
	local int i;
	local array<string> SOCInfo;

	for(i=0; i<13; i++){
		if(bControlSpecialType) SOCInfo[i] = string(SpecialChosenChance[i]);
		else SOCInfo[i] = "unmodded";
	}

	LogToConsole("-----<Special Info>-----");

	if(bControlSpecialChance) LogToConsole("SpecialChance = " $ string(GeneralSpecialChance));
	else LogToConsole("SpecialChance = unmodded");

	LogToConsole("Cyst = " $ SOCInfo[0]);
	LogToConsole("Alpha Clot = " $ SOCInfo[1]);
	LogToConsole("Slasher = " $ SOCInfo[2]);
	LogToConsole("Gorefast = " $ SOCInfo[3]);
	LogToConsole("Crawler = " $ SOCInfo[4]);
	LogToConsole("Stalker = " $ SOCInfo[5]);
	LogToConsole("Bloat = " $ SOCInfo[6]);
	LogToConsole("Siren = " $ SOCInfo[7]);
	LogToConsole("Husk = " $ SOCInfo[8]);
	LogToConsole("Scrake = " $ SOCInfo[9]);
	LogToConsole("Fleshpound = " $ SOCInfo[10]);
	LogToConsole("Quarterpound = " $ SOCInfo[11]);
	LogToConsole("EDAR = " $ SOCInfo[12]);
}

function LogHelp(){
	LogToConsole("==========[About Chat Command]==========");
	LogToConsole("---<Basic>---");
	LogToConsole("!info : Show info about settings in console");
	LogToConsole("!info basic/outbreak/special : Show more specific info");
	LogToConsole("!help : Show this info about Chat Command");
	LogToConsole("!ot : OpenTrader");
	LogToConsole("!pt / !upt : Pause/Unpause Trader");
	LogToConsole("!ready / !cdr : Ready up (Trader will be unpaused when all mates are ready.");
	LogToConsole("!unready / !cdur : Unready");
	LogToConsole("!ecw : EndCurrentWave");
	LogToConsole("!nw <int> : Set next wave");
	LogToConsole("!ap <bool> : AutoPause");
	LogToConsole("!rs <bool> : ReadySystem");

	LogToConsole("---<Outbreak>---");
	LogToConsole("!goc <float> : GeneralOutbreakChance (-1 returns unmodded chance)");
	LogToConsole("!soc <int> <float> : SpecificOutbreakChance (<int> 0~9=OutbreakIndex, -1=unmodded | <float> Chance");
	LogToConsole("!boom/tiny/bobble/pound/upup/beef/cranium/zt/blood/arach <float> : EachOutbreakChance");

	LogToConsole("---<Special>---");
	LogToConsole("!gsc <float> : GeneralSpecialChance (-1 returns unmodded chance)");
	LogToConsole("!ssc <int> <float> : SpecificSpecialChance (<int> 0~14=SpecialIndex, -1=unmodded | <float> Chance");
	LogToConsole("!cy/al/sl/gf/cr/st/bl/si/hu/sc/fp/qp/ed <float> : EachSpecialChance");
}


/*-----Ready System-----*/

private function ReadyUp(Actor Sender)
{
	local KFPlayerController KFPC;
	local ExtPlayerController EEPC;
	local name GameStateName;
	GameStateName = GetStateName();
	KFPC = KFPlayerController(Sender);
	EEPC = ExtPlayerController(Sender);

	if(EEPC != none){
		if (!bEnableReadySystem){
			BroadcastExtEcho( "The Ready system is currently disabled." );
		}
		else if ( GameStateName == 'TraderOpen' && MyKFGRI.bStopCountDown && !KFPC.PlayerReplicationInfo.bOnlySpectator){
			if (EEPC.bIsReadyForNextWave){
				BroadCastExtEcho( "We get it, you're ready." );
			}
			else{
				EEPC.bIsReadyForNextWave = true;
				BroadCastExtEcho( KFPC.PlayerReplicationInfo.PlayerName $ " has readied up." );
				if( bAllPlayersAreReady() ){
					BroadCastExtEcho( "All Players are ready. Unpausing Trader." );
					UnpauseTraderTime();
				}
			}
		}
	}
}

private function Unready(Actor Sender)
{
	local KFPlayerController KFPC;
	local ExtPlayerController EEPC;
	local name GameStateName;
	GameStateName = GetStateName();

	KFPC = KFPlayerController(Sender);
	EEPC = ExtPlayerController(Sender);
	
	if (EEPC != none)
	{
		if (!bEnableReadySystem){
			BroadCastExtEcho( "The Ready system is currently disabled." );
		}
		else if ( GameStateName == 'TraderOpen' && !KFPC.PlayerReplicationInfo.bOnlySpectator && EEPC.bIsReadyForNextWave){
			if (WorldInfo.NetMode != NM_StandAlone && MyKFGRI.RemainingTime <= 5){
				BroadCastExtEcho( "Unready requires at least 5 seconds remaining." );
			}
			else{
				EEPC.bIsReadyForNextWave = false;
				BroadCastExtEcho( KFPC.PlayerReplicationInfo.PlayerName $ " has unreadied." );
				if ( !MyKFGRI.bStopCountDown ){
					PauseTraderTime();
				}
			}
		}
	}
}

private function bool bAllPlayersAreReady()
{
    local KFPlayerController KFPC;
	local ExtPlayerController EEPC;
    local int TotalPlayerCount;
    local int SpectatorCount;
    local int ReadyCount;
	
	TotalPlayerCount = 0;
	SpectatorCount = 0;
	ReadyCount = 0;
	
    foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC){
        EEPC = ExtPlayerController(KFPC);
		
		if (EEPC != none){
		
			if ( !KFPC.bIsPlayer || KFPC.bDemoOwner ){
				continue;
			}
			else{
				TotalPlayerCount++;
			}		       
			if ( KFPC.PlayerReplicationInfo.bOnlySpectator ){
				SpectatorCount++;
			}
			else if ( EEPC.bIsReadyForNextWave && !KFPC.PlayerReplicationInfo.bOnlySpectator){
				ReadyCount++;
			}
		}
    }
	
    if (TotalPlayerCount == ReadyCount + SpectatorCount) return true;
	else return false;
}

private function UnreadyAllPlayers()
{
	local KFPlayerController KFPC;
	local ExtPlayerController EEPC;
	
	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC){
		if ( KFPC.bIsPlayer && !KFPC.PlayerReplicationInfo.bOnlySpectator && !KFPC.bDemoOwner ){
			EEPC = ExtPlayerController(KFPC);
			if (EEPC != none){
				EEPC.bIsReadyForNextWave = false;
			}
		}
	}
}

// To set specific outbreak chance
function SetOutbreakChosenChance(string occ){
	local array<string> splitbuf;
	local int i;
	if(occ == "-1") bControlOutbreakType = false;
	else{
		bControlOutbreakType = true;
		ParseStringIntoArray(occ,splitbuf,",",true);
		for(i=0; i<10; i++){
			OutbreakChosenChance[i] = float(splitbuf[i]);
		}
	}

}

/* ----------<<Extended Endless Features>>----------*/

function bool TrySetNextWaveSpecial()
{
	local float OutbreakPct, SpecialWavePct;
	local int OutbreakEventIdx, i;
	local float ConditionL, ConditionR, RandV;
	local array<EAIType> ssTypes;

	ssTypes[0] = SpecialWaveTypes[0];
	ssTypes[1] = SpecialWaveTypes[7];
	ssTypes[2] = SpecialWaveTypes[1];
	ssTypes[3] = SpecialWaveTypes[8];
	ssTypes[4] = SpecialWaveTypes[2];
	ssTypes[5] = SpecialWaveTypes[3];
	ssTypes[6] = SpecialWaveTypes[9];
	ssTypes[7] = SpecialWaveTypes[4];
	ssTypes[8] = SpecialWaveTypes[5];
	ssTypes[9] = SpecialWaveTypes[6];
	ssTypes[10] = SpecialWaveTypes[10];
	ssTypes[11] = SpecialWaveTypes[11];
	ssTypes[12] = SpecialWaveTypes[12];
	ssTypes[13] = SpecialWaveTypes[13];
	ssTypes[14] = SpecialWaveTypes[14];


	if (MyKFGRI.IsBossWave() || MyKFGRI.IsBossWaveNext())
	{
		return false;
	}

	if(!bControlOutbreakChance) OutbreakPct = EndlessDifficulty.GetOutbreakPctChance();
	else OutbreakPct = GeneralOutbreakChance;
	if(!bControlSpecialChance) SpecialWavePct = EndlessDifficulty.GetSpeicalWavePctChance();
	else SpecialWavePct = GeneralSpecialChance;

	if (bForceOutbreakWave || (WaveNum >= OutbreakWaveStart && OutbreakPct > 0.f && FRand() < OutbreakPct))
	{
		if(DebugForcedOutbreakIdx == INDEX_NONE)
		{
			if(!bControlOutbreakType) OutbreakEventIdx = Rand(6);
			else{
				ConditionL = 0;
				ConditionR = OutbreakChosenChance[0];
				RandV = FRand();
				for(i=0; i<10; i++){
					if(RandV < ConditionR && RandV >= ConditionL){
						OutbreakEventIdx = i;
						break;
					}
					else if(i != 9){
						ConditionL = ConditionR;
						ConditionR += OutbreakChosenChance[i+1];
					}
					else return false;
				}
			}
		}
		else
		{
			`log("Forcing Outbreak" @ DebugForcedOutbreakIdx);
			OutbreakEventIdx = DebugForcedOutbreakIdx;
		}
		KFGameReplicationInfo_Endless(GameReplicationInfo).CurrentWeeklyMode = OutbreakEventIdx;
		bForceOutbreakWave = false;
		DebugForcedOutbreakIdx = INDEX_NONE;
		return true;
	}
	else if (bForceSpecialWave || (WaveNum >= SpecialWaveStart && SpecialWavePct > 0.f && FRand() < SpecialWavePct))
	{
		bUseSpecialWave = true;
		if(!bControlSpecialType){
			if(DebugForceSpecialWaveZedType == INDEX_NONE)
			{
				SpecialWaveType = EndlessDifficulty.GetSpecialWaveType();
			}
			else
			{
				`log("Forcing Special Wave Type" @ EAIType(DebugForceSpecialWaveZedType));
				SpecialWaveType = EAIType(DebugForceSpecialWaveZedType);
			}
		}
		else{
			ConditionL = 0;
			ConditionR = SpecialChosenChance[0];
			RandV = FRand();
			for(i=0; i<13; i++){
				if(RandV < ConditionR && RandV >= ConditionL){
					SpecialWaveType = ssTypes[i];
					break;
				}
				else if(i != 12){
					ConditionL = ConditionR;
					ConditionR += SpecialChosenChance[i+1];
				}
				else return false;
			}
		}
		KFGameReplicationInfo_Endless(GameReplicationInfo).CurrentSpecialMode = SpecialWaveType;
		bForceSpecialWave = false;
		DebugForceSpecialWaveZedType = INDEX_NONE;
		return true;
	}

	bForceOutbreakWave = false;
	bForceSpecialWave = false;

	DebugForcedOutbreakIdx = INDEX_NONE;
	DebugForceSpecialWaveZedType = INDEX_NONE;

	return false;
}

function StartOutbreakRound(int OutbreakIdx)
{	
	local KFPlayerController KFPC;
	local ExtPlayerController EPC;
	local KFPawn Player;

	OutbreakEvent.SetActiveEvent(OutbreakIdx);
	OutbreakEvent.UpdateGRI();
	OutbreakEvent.SetWorldInfoOverrides();

	//ZedTime
	if (OutbreakEvent.ActiveEvent.bPermanentZedTime) EE_SetPermanentZedTime(); 
   	if (ZedTimeSlomoScale != OutbreakEvent.ActiveEvent.OverrideZedTimeSlomoScale){
   		OriginalZTSlomoScale = ZedTimeSlomoScale;
   		ZedTimeSlomoScale = OutbreakEvent.ActiveEvent.OverrideZedTimeSlomoScale;
   	}

   	//BloodThirst
   	if (OutbreakEvent.ActiveEvent.GlobalDamageTickRate > 0.f && OutbreakEvent.ActiveEvent.GlobalDamageTickAmount > 0.f){
   		if(!IsTimerActive('EE_EnableGlobalDamage', self)){
   			SetTimer(OutbreakEvent.ActiveEvent.DamageDelayAfterWaveStarted, false, 'EE_EnableGlobalDamage', self);
   		}
   		SetTimer(1.0f, false, 'EE_CheckForZedFrustrationMode', self);
   	}

   	//Coliseum
   	if(OutbreakEvent.ActiveEvent.PerksAvailableList.length > 0){
   		foreach worldinfo.AllControllers(class'KFPlayerController', KFPC){
   			EPC = ExtPlayerController(KFPC);
   			EPC.ColiseumAdjust();
   		}
   	}

   	//Arachnophobia
   	if (OutbreakEvent.ActiveEvent.bGoompaJumpEnabled){
   		foreach worldinfo.AllControllers(class'KFPlayerController', KFPC){
   			EPC = ExtPlayerController(KFPC);
   			EPC.MaxGoompaStreak = OutbreakEvent.ActiveEvent.GoompaStreakMax;
   			Player = KFPawn(KFPC.Pawn);
   			Player.JumpZ = OutbreakEvent.ActiveEvent.JumpZ;
   		}
   	}

   	//Scavenger
}

function EndOutbreakRound()
{	
	local KFPlayerController KFPC;
	local ExtPlayerController EPC;
	local KFPawn Player;

	// ZedTime
	if (OutbreakEvent.ActiveEvent.bPermanentZedTime && ZedTimeRemaining > ZedTimeBlendOutTime){
        EE_ClearZedTimePCTimers();
        ZedTimeRemaining = ZedTimeBlendOutTime;
    }
    if (OriginalZTSlomoScale != ZedTimeSlomoScale) ZedTimeSlomoScale = OriginalZTSlomoScale;
    EE_SetSpawnPointOverrides();

    // BloodThirst
    EE_DisableGlobalDamage();

    //Coliseum
   	if(OutbreakEvent.ActiveEvent.PerksAvailableList.length > 0){
   		foreach worldinfo.AllControllers(class'KFPlayerController', KFPC){
   			EPC = ExtPlayerController(KFPC);
   			EPC.ColiseumReset();
   		}
   	}

   	//Arachnophobia
   	if (OutbreakEvent.ActiveEvent.bGoompaJumpEnabled){
   		foreach worldinfo.AllControllers(class'KFPlayerController', KFPC){
   			EPC = ExtPlayerController(KFPC);
   			EPC.ResetGoompaStreak();
   			EPC.ResetStreakInfo();
   			EPC.MaxGoompaStreak = -1;
   			Player = KFPawn(KFPC.Pawn);
   			Player.JumpZ = 650.f;
   		}
   	}

   	//Scavenger

    super.EndOutbreakRound();
}

/* ----- Outbreak - ZedTime ----- */

function EE_SetPermanentZedTime()
{
    local KFPlayerController KFPC;
    if (OutbreakEvent.ActiveEvent.bPermanentZedTime){
        ZedTimeRemaining = 999999.f;
        bZedTimeBlendingOut = false;
        LastZedTimeEvent = WorldInfo.TimeSeconds;
        SetZedTimeDilation(ZedTimeSlomoScale);

        foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC){
            if (KFPC != none){
                KFPC.EnterZedTime();
            }
        }
    }
}

function TickZedTime( float DeltaTime )
{
    super.TickZedTime(DeltaTime);

    //If we're in permanent mode with a valid wave, set remaining time to a stupid value to stay in zed time
    if (OutbreakEvent.ActiveEvent.bPermanentZedTime && IsWaveActive())
    {
        //Keep up the timer if we have enough zeds left or it's a boss phase
        if (MyKFGRI.AIRemaining > OutbreakEvent.ActiveEvent.PermanentZedTimeCutoff || WaveNum == WaveMax)
        {
            ZedTimeRemaining = 999999.f;
        }
        //Else start the fade back to normal
        else if (ZedTimeRemaining > ZedTimeBlendOutTime)
        {
            ZedTimeRemaining = ZedTimeBlendOutTime;
            EE_ClearZedTimePCTimers();
        }
    }
}

function EE_ClearZedTimePCTimers()
{
    local KFPlayerController KFPC;

    foreach AllActors(class'KFPlayerController', KFPC)
    {
        KFPC.ClearTimer('RecheckZedTime');
    }
}

function EE_SetSpawnPointOverrides()
{
    local KFSpawnVolume KFSV;

    foreach WorldInfo.AllActors(class'KFSpawnVolume', KFSV)
    {
        if (OutbreakEvent.ActiveEvent.OverrideSpawnDerateTime >= 0.f)
        {
            KFSV.SpawnDerateTime = OutbreakEvent.ActiveEvent.OverrideSpawnDerateTime;
        }

        if (OutbreakEvent.ActiveEvent.OverrideTeleportDerateTime >= 0.f)
        {
            KFSV.TeleportDerateTime = OutbreakEvent.ActiveEvent.OverrideTeleportDerateTime;
        }
    }
}

/* ----- Outbreak - BloodThirst ----- */

protected function ScoreMonsterKill( Controller Killer, Controller Monster, KFPawn_Monster MonsterPawn )
{
    super.ScoreMonsterKill(Killer, Monster, MonsterPawn);

	if(OutbreakEvent.ActiveEvent.bHealAfterKill)
    {
    	if( MonsterPawn != none && MonsterPawn.DamageHistory.Length > 0 )
		{
			EE_HealAfterKilling( MonsterPawn, Killer );
        }
	}

}

function EE_HealAfterKilling(KFPawn_Monster MonsterPawn , Controller Killer)
{
	local int i;
    local int j;
	local KFPlayerController KFPC;
	local KFPlayerReplicationInfo DamagerKFPRI;
    local array<DamageInfo> DamageHistory;
    local array<KFPlayerController> Attackers;
    local KFPawn_Human PawnHuman;
    local KFGameInfo KFGI;
    
    DamageHistory = MonsterPawn.DamageHistory;
    
    KFGI = KFGameInfo(WorldInfo.Game);
	
	for ( i = 0; i < DamageHistory.Length; i++ )
	{
		if( DamageHistory[i].DamagerController != none
			&& DamageHistory[i].DamagerController.bIsPlayer
			&& DamageHistory[i].DamagerPRI.GetTeamNum() == 0
			&& DamageHistory[i].DamagerPRI != none )
		{
			DamagerKFPRI = KFPlayerReplicationInfo(DamageHistory[i].DamagerPRI);
			if( DamagerKFPRI != none )
			{
                KFPC = KFPlayerController(DamagerKFPRI.Owner);
                if( KFPC != none )
                {
                    if(Attackers.Find(KFPC) < 0)
                    {
                    	PawnHuman = KFPawn_Human(KFPC.Pawn);
                        Attackers.AddItem(KFPC);

                        /*Aracnophobia (10)*/
                        if( KFPC == Killer && KFGI != none && KFGI.OutbreakEvent.ActiveEvent.bGoompaJumpEnabled )
                        {
                            for (j = 0; j < DamageHistory[i].DamageTypes.Length; j++)
                            {
                                if (DamageHistory[i].DamageTypes[j] == class 'KFDT_GoompaStomp')
                                {
                                    PawnHuman.HealDamageForce(MonsterPawn.HealByAssistance, KFPC, class'KFDT_Healing', false, false );
                                    return;
                                }
                            }

                            PawnHuman.HealDamageForce(MonsterPawn.HealByKill, KFPC, class'KFDT_Healing', false, false );
                            return;
                        }
                        //

                        if( KFPC == Killer )
                        {
            				PawnHuman.HealDamageForce(MonsterPawn.HealByKill, KFPC, class'KFDT_Healing', false, false );
                            
                            if( KFPawn_ZedFleshpound(MonsterPawn) != none || KFPawn_ZedScrake(MonsterPawn) != none )
                            {
                                KFPC.ReceivePowerUp(class'KFPowerUp_HellishRage_NoCostHeal');
                            }
                        }
                        else
                        {
            				PawnHuman.HealDamageForce(MonsterPawn.HealByAssistance, KFPC, class'KFDT_Healing', false, false );
                        }
                    }
				}
			}
		}
	}
}

function EE_EnableGlobalDamage(){
	MyKFGRI.SetGlobalDamage(true);
    SetTimer(OutbreakEvent.ActiveEvent.GlobalDamageTickRate, true, 'ApplyGlobalDamage', OutbreakEvent);
}

function EE_DisableGlobalDamage(){
    MyKFGRI.SetGlobalDamage(false);

    if (IsTimerActive('ApplyGlobalDamage', OutbreakEvent))
    {
        ClearTimer('ApplyGlobalDamage', OutbreakEvent);
    }

    if (IsTimerActive('EE_EnableGlobalDamage', self))
    {
        ClearTimer('EE_EnableGlobalDamage', self);
    }
}

function EE_CheckForZedFrustrationMode(){
	if(IsTimerActive('ApplyGlobalDamage', OutbreakEvent))
    {
        if(class'KFAIController'.default.FrustrationThreshold > 0 && MyKFGRI.AIRemaining <= class'KFAIController'.default.FrustrationThreshold)
        {
            EE_DisableGlobalDamage();
            ClearTimer('EE_CheckForZedFrustrationMode', self);
        }
    }
}

/* ----- Outbreak - Coliseum ----- */
/*
function BeginColiseum(){
	local KFPlayerController KFPC;
	foreach WorldInfo.AllControllers('KFPlayerController', KFPC){
		if(KFPC.GetPerk().GetPerkClass() !=  class'KFPerk_Berserker') 
	}
	
}*/

/* ----- Outbreak - Archanophobia ----- */

simulated function ModifyDamageGiven(out int InDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx )
{
    local ExtPlayerController EPC;
    local int Streak;

    if (OutbreakEvent.ActiveEvent.bGoompaJumpEnabled)
    {
        EPC = ExtPlayerController(DamageInstigator);
        if (EPC != none)
        {
            Streak = EPC.GoompaStreakBonus < EPC.MaxGoompaStreak ? EPC.GoompaStreakBonus : EPC.MaxGoompaStreak;
            InDamage *= (1 + OutbreakEvent.ActiveEvent.GoompaStreakDamage * Streak);
        }
    }
}

function float GetAdjustedAIDoshValue( class<KFPawn_Monster> MonsterClass )
{
	return super.GetAdjustedAIDoshValue(MonsterClass) * OutbreakEvent.ActiveEvent.DoshOnKillGlobalModifier;
}

/* ----- Special AIType -----*/

function class<KFPawn_Monster> GetAISpawnType(EAIType AIType)
{
	if (bUseSpecialWave){
		if(SpecialWaveType == AT_EDAR_EMP || SpecialWaveType == AT_EDAR_Rocket || SpecialWaveType == AT_EDAR_Laser){
			if(FRand() < 0.33f){
				SpecialWaveType = AT_EDAR_EMP;
				return super.GetAISpawnType(SpecialWaveType);
			}
			else if(0.33f <= FRand() && FRand() < 0.66f){
				SpecialWaveType = AT_EDAR_Rocket;
				return super.GetAISpawnType(SpecialWaveType);
			}
			else{
				SpecialWaveType = AT_EDAR_Laser;
				return super.GetAISpawnType(SpecialWaveType);
			}
		}
	}
	return Super.GetAISpawnType(AIType);
}

DefaultProperties
{	
	PlayerControllerClass=class'ExtEndless.ExtPlayerController'
	OutbreakEventClass=class'ExtEndless.ExtOutbreakEvent'
	GameReplicationInfoClass=class'ExtEndless.EEGameReplicationInfo'

	SpecialWaveTypes(11) = AT_FleshpoundMini
	SpecialWaveTypes(12) = AT_EDAR_EMP
	SpecialWaveTypes(13) = AT_EDAR_Rocket
	SpecialWaveTypes(14) = AT_EDAR_Laser

	bWaitingSetWave = false
}