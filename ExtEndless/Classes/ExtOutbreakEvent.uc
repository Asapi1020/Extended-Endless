// ================================================================
//  ExtOutbreakEvent
// ================================================================
//  Additional outbreak events
// ================================================================

class ExtOutbreakEvent extends KFOutbreakEvent_Endless;

DefaultProperties
{
	// Cranium Cracker
	SetEvents[6] = {(
                    EventDifficulty=1,
                    GameLength=GL_Normal,
                    bHeadshotsOnly=true,
                    WeeklyOutbreakId=1,
                    SpawnReplacementList={(
                                            
                                            (SpawnEntry=AT_Stalker,NewClass=(class'KFGameContent.KFPawn_ZedClot_Alpha'),PercentChance=1.0),
                                            (SpawnEntry=AT_Husk,NewClass=(class'KFGameContent.KFPawn_ZedBloat'),PercentChance=1.0)
                    )},
                    BossSpawnReplacementList={(
                                            (SpawnEntry=BAT_Matriarch,NewClass=class'KFGameContent.KFPawn_ZedPatriarch')
                    )},
                    ZedsToAdjust={(
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedPatriarch',HealthScale=0.50), // HealthScale = 0.25, then .40
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedMatriarch',HealthScale=0.75,ShieldScale=0.5),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedFleshpoundKing',HealthScale=0.75,ShieldScale=0.5),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedHans',HealthScale=0.40,ShieldScale=0.75), //HealthScale = 0.25, Shieldscale = 1.0
									(ClassToAdjust=class'KFGameContent.KFPawn_ZedBloatKing',HealthScale=0.6,ShieldScale=0.75),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedBloatKingSubspawn',HealthScale=0.25),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedFleshpoundmini',HealthScale=0.9), //HealthScale = 1.0
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedDAR_EMP',HealthScale=0.05),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedDAR_Laser',HealthScale=0.05),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedDAR_Rocket',HealthScale=0.05)
                    )}
    )}

    // ZedTime
    SetEvents[7] = {(
                    EventDifficulty=3,
                    bPermanentZedTime = true,
                    SpawnRateMultiplier=15.0, //10.0
                    OverrideZedTimeSlomoScale = 0.5,
                    ZedTimeRadius=1450.0, //1024
                    ZedTimeBossRadius=2048.0,
                    ZedTimeHeight=512.0,
                    WeeklyOutbreakId=6,
                    ZedsToAdjust={(
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedPatriarch',HealthScale=0.8,DamageDealtScale=0.85),  //health0.75way to weak   damage0.6
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedMatriarch',HealthScale=0.8,DamageDealtScale=0.85),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedHans',HealthScale=0.7,DamageDealtScale=0.7),  //health0.75  damage0.6
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedFleshpoundKing',HealthScale=0.8,DamageDealtScale=0.85),
									(ClassToAdjust=class'KFGameContent.KFPawn_ZedBloatKing',HealthScale=0.8,DamageDealtScale=0.85),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedClot_AlphaKing',DamageDealtScale=0.6), //4
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedClot_Slasher',DamageDealtScale=0.6), //5
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedClot_Alpha',DamageDealtScale=0.6),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedClot_Cyst',DamageDealtScale=0.6),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedBloat',DamageDealtScale=0.6), //0.7  2.0
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedCrawler',DamageDealtScale=0.6),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedCrawlerKing',DamageDealtScale=0.6),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedFleshpound',DamageDealtScale=0.6),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedGorefast',DamageDealtScale=0.6),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedGorefastDualBlade',DamageDealtScale=0.6),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedHusk',DamageDealtScale=0.6),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedScrake',DamageDealtScale=0.6),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedSiren',DamageDealtScale=0.6),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedStalker',DamageDealtScale=0.6)
                    )},
                    SpawnReplacementList={(
                                            (SpawnEntry=AT_Stalker,NewClass=(class'KFGameContent.KFPawn_ZedScrake'),PercentChance=0.07)
                    )},
                    PermanentZedTimeCutoff = 6,
                    OverrideSpawnDerateTime = 0.0,
                    OverrideTeleportDerateTime = 0.0,
                    WaveAICountScale=(0.5, 0.5, 0.5, 0.5, 0.5, 0.5), //This is per player-count
                    MaxPerkLevel=3,
                    bAllowSpawnReplacementDuringBossWave=false
    )}

    // BloodThrst
    SetEvents[8]={(
                    EventDifficulty = 1, //2
                    GameLength = GL_Normal,
                    GlobalDamageTickRate = 2.0,
                    GlobalDamageTickAmount = 6.0, //5.0,
                    bHealAfterKill = true,
                    bCannotBeHealed = true,
                    bGlobalDamageAffectsShield = false,
                    bHealPlayerAfterWave = true,
                    bApplyGlobalDamageBossWave = false,
                    DamageDelayAfterWaveStarted = 10.0f,
                    SpawnRateMultiplier=6.0, //8.0,
                    WeeklyOutbreakId=8,
                    ZedsToAdjust={(
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedPatriarch',HealthScale=1.0,DamageDealtScale=0.75),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedMatriarch',HealthScale=1.0,DamageDealtScale=0.75),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedHans',HealthScale=1.0,DamageDealtScale=0.75),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedFleshpoundKing',HealthScale=1.0,DamageDealtScale=0.75),
									(ClassToAdjust=class'KFGameContent.KFPawn_ZedBloatKing',HealthScale=1.0,DamageDealtScale=0.75)
                    )},
                    ZedsToAdjust={(
                                (ClassToAdjust=class'KFGameContent.KFPawn_ZedClot_Cyst',HealByKill=5,HealByAssistance=3, InitialGroundSpeedModifierScale=1.20),
                                (ClassToAdjust=class'KFGameContent.KFPawn_ZedClot_Alpha',HealByKill=5,HealByAssistance=3, InitialGroundSpeedModifierScale=1.20),
                                (ClassToAdjust=class'KFGameContent.KFPawn_ZedClot_AlphaKing',HealByKill=10,HealByAssistance=7, InitialGroundSpeedModifierScale=1.20),
                                (ClassToAdjust=class'KFGameContent.KFPawn_ZedClot_Slasher',HealByKill=5,HealByAssistance=3, InitialGroundSpeedModifierScale=1.20),
                                (ClassToAdjust=class'KFGameContent.KFPawn_ZedSiren',HealByKill=12,HealByAssistance=8, InitialGroundSpeedModifierScale=1.20),
                                (ClassToAdjust=class'KFGameContent.KFPawn_ZedStalker',HealByKill=7,HealByAssistance=5, InitialGroundSpeedModifierScale=1.20),
                                (ClassToAdjust=class'KFGameContent.KFPawn_ZedCrawler',HealByKill=5,HealByAssistance=3, InitialGroundSpeedModifierScale=1.20),
                                (ClassToAdjust=class'KFGameContent.KFPawn_ZedCrawlerKing',HealByKill=10,HealByAssistance=7, InitialGroundSpeedModifierScale=1.20),
                                (ClassToAdjust=class'KFGameContent.KFPawn_ZedGorefast',HealByKill=7,HealByAssistance=5, InitialGroundSpeedModifierScale=1.20),
                                (ClassToAdjust=class'KFGameContent.KFPawn_ZedGorefastDualBlade',HealByKill=10,HealByAssistance=7, InitialGroundSpeedModifierScale=1.20),
                                (ClassToAdjust=class'KFGameContent.KFPawn_ZedBloat',HealByKill=16, HealByAssistance=11, InitialGroundSpeedModifierScale=1.20),
                                (ClassToAdjust=class'KFGameContent.KFPawn_ZedHusk',HealByKill=12,HealByAssistance=8, InitialGroundSpeedModifierScale=1.20),
                                (ClassToAdjust=class'KFGameContent.KFPawn_ZedDAR_EMP',HealByKill=10,HealByAssistance=7, InitialGroundSpeedModifierScale=1.20),
                                (ClassToAdjust=class'KFGameContent.KFPawn_ZedDAR_Laser',HealByKill=10,HealByAssistance=7, InitialGroundSpeedModifierScale=1.20),
                                (ClassToAdjust=class'KFGameContent.KFPawn_ZedDAR_Rocket',HealByKill=10,HealByAssistance=7, InitialGroundSpeedModifierScale=1.20),
                                (ClassToAdjust=class'KFGameContent.KFPawn_ZedScrake',HealByKill=50,HealByAssistance=35, InitialGroundSpeedModifierScale=1.20),
                                (ClassToAdjust=class'KFGameContent.KFPawn_ZedFleshpound',HealByKill=60,HealByAssistance=42, InitialGroundSpeedModifierScale=1.20),
                                (ClassToAdjust=class'KFGameContent.KFPawn_ZedFleshpoundMini',HealByKill=36,HealByAssistance=25, InitialGroundSpeedModifierScale=1.20),
                                (ClassToAdjust=class'KFGameContent.KFPawn_ZedBloatKingSubspawn',HealByKill=7,HealByAssistance=5)
					)}
    
    )}


    //Coliseum
    SetEvents[10]={(
                    EventDifficulty=3,
                    GameLength=GL_Normal,
					PerksAvailableList=(class'KFPerk_Berserker'),
                    SpawnWeaponList=KFGFxObject_TraderItems'GP_Trader_ARCH.ColliseumWeeklySpawnList',
					bSpawnWeaponListAffectsSecondaryWeapons=true,
                    TraderWeaponList=KFGFxObject_TraderItems'GP_Trader_ARCH.ColliseumWeeklyTraderList',
					bColliseumSkillConditionsActive=true,
					bModifyZedTimeOnANearZedKill=true,
					ZedTimeOnANearZedKill=0.6,
                    PickupResetTime=PRS_Wave,
                    OverrideItemPickupModifier=0,
                    DoshOnKillGlobalModifier=0.7,
                    SpawnRateMultiplier=2.0,
                    WeeklyOutbreakId=9,
                    WaveAICountScale=(0.75, 0.7, 0.65, 0.6, 0.55, 0.5),
                    ZedsToAdjust={(
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedPatriarch',HealthScale=0.75,DamageDealtScale=0.6),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedMatriarch',HealthScale=0.75,DamageDealtScale=0.6),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedHans',HealthScale=0.75,DamageDealtScale=0.6),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedFleshpoundKing',HealthScale=0.75,DamageDealtScale=0.6),
									(ClassToAdjust=class'KFGameContent.KFPawn_ZedBloatKing',HealthScale=0.75,DamageDealtScale=0.6),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedScrake',HealthScale=0.75,DamageDealtScale=0.6),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedFleshpound',HealthScale=0.75,DamageDealtScale=0.6),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedFleshpoundMini',HealthScale=0.75,DamageDealtScale=0.6),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedGorefast',HealthScale=1.0,DamageDealtScale=0.75),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedGorefastDualBlade',HealthScale=1.0,DamageDealtScale=0.75),                             
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedClot_Cyst',HealthScale=1.0,DamageDealtScale=0.75),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedClot_Alpha',HealthScale=1.0,DamageDealtScale=0.75),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedClot_AlphaKing',HealthScale=1.0,DamageDealtScale=0.75),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedClot_Slasher',HealthScale=1.0,DamageDealtScale=0.75),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedBloat',HealthScale=1.0,DamageDealtScale=0.75),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedSiren',HealthScale=1.0,DamageDealtScale=0.75)
                    )},
                    SpawnReplacementList={(
                                            (SpawnEntry=AT_AlphaClot,NewClass=(class'KFGameContent.KFPawn_ZedGorefast'),PercentChance=0.1),
                                            (SpawnEntry=AT_SlasherClot,NewClass=(class'KFGameContent.KFPawn_ZedGorefast'),PercentChance=0.1),
                                            (SpawnEntry=AT_Crawler,NewClass=(class'KFGameContent.KFPawn_ZedGorefast'),PercentChance=1.0),
                                            (SpawnEntry=AT_Stalker,NewClass=(class'KFGameContent.KFPawn_ZedGorefast'),PercentChance=1.0),
                                            (SpawnEntry=AT_Bloat,NewClass=(class'KFGameContent.KFPawn_ZedFleshpoundMini'),PercentChance=0.5),
                                            (SpawnEntry=AT_Siren,NewClass=(class'KFGameContent.KFPawn_ZedFleshpoundMini'),PercentChance=0.5),
                                            (SpawnEntry=AT_Husk,NewClass=(class'KFGameContent.KFPawn_ZedScrake'),PercentChance=1.0),
                                            (SpawnEntry=AT_GoreFast,NewClass=(class'KFGameContent.KFPawn_ZedGorefastDualBlade'),PercentChance=0.3),
                                            (SpawnEntry=AT_Scrake,NewClass=(class'KFGameContent.KFPawn_ZedFleshpound'),PercentChance=0.5)
                                            
                    )}

    )}

    // Aracnophobia
    SetEvents[9]={(
                    EventDifficulty=2, //1,
                    GameLength=GL_Normal,
                    SpawnRateMultiplier=0.75, //5.0,
                    bHealAfterKill = true,
                    bGoompaJumpEnabled = true,
                    GoompaJumpDamage = 550, //300,
                    GoompaStreakDamage = 0.1, //0.2,
                    GoompaJumpImpulse = 600, //1000,
                    GoompaStreakMax = 5,
                    GoompaBonusDuration=8.0f, //10.0f,
                    DoshOnKillGlobalModifier=1.0,
                    SpawnWeaponList=KFGFxObject_TraderItems'GP_Trader_ARCH.AracnophobiaWeeklySpawnList',
                    bAddSpawnListToLoadout=true,
                    WeeklyOutbreakId=10,
                    WaveAICountScale=(0.6, 0.6, 0.6, 0.6, 0.6, 0.6),
                    JumpZ=700.f, // 650.0 by default; -1 used for not overriding.
                    /** HealByKill = Normal kill. HealByAssistance = Goomba stomping  */
                    ZedsToAdjust={(
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedCrawler',HealthScale=10.0, HeadHealthScale=20.0, DamageDealtScale=0.7, InitialGroundSpeedModifierScale=0.7, HealByAssistance=10),
                                    (ClassToAdjust=class'KFGameContent.KFPawn_ZedCrawlerKing',HealthScale=10.0,HeadHealthScale=20.0, DamageDealtScale=0.7, InitialGroundSpeedModifierScale=0.7, HealByAssistance=20)
                                    //(ClassToAdjust=class'KFGameContent.KFPawn_ZedClot_Cyst',HealByAssistance=5),
                                    //(ClassToAdjust=class'KFGameContent.KFPawn_ZedClot_Alpha',HealByAssistance=5),
                                    //(ClassToAdjust=class'KFGameContent.KFPawn_ZedClot_AlphaKing',HealByAssistance=5),
                                    //(ClassToAdjust=class'KFGameContent.KFPawn_ZedClot_Slasher',HealByAssistance=5),
                                    //(ClassToAdjust=class'KFGameContent.KFPawn_ZedSiren',HealByAssistance=5),
                                    //(ClassToAdjust=class'KFGameContent.KFPawn_ZedStalker',HealByAssistance=5),
                                    //(ClassToAdjust=class'KFGameContent.KFPawn_ZedGorefast',HealByAssistance=5),
                                    //(ClassToAdjust=class'KFGameContent.KFPawn_ZedGorefastDualBlade',HealByAssistance=5),
                                    //(ClassToAdjust=class'KFGameContent.KFPawn_ZedBloat',HealByAssistance=5),
                                    //(ClassToAdjust=class'KFGameContent.KFPawn_ZedHusk',HealByAssistance=5),
                                    //(ClassToAdjust=class'KFGameContent.KFPawn_ZedDAR_EMP',HealByAssistance=5),
                                    //(ClassToAdjust=class'KFGameContent.KFPawn_ZedDAR_Laser',HealByAssistance=5),
                                    //(ClassToAdjust=class'KFGameContent.KFPawn_ZedDAR_Rocket',HealByAssistance=5),
                                    //(ClassToAdjust=class'KFGameContent.KFPawn_ZedScrake',HealByAssistance=15),
                                    //(ClassToAdjust=class'KFGameContent.KFPawn_ZedFleshpound',HealByAssistance=15),
                                    //(ClassToAdjust=class'KFGameContent.KFPawn_ZedFleshpoundMini',HealByAssistance=15),
                                    //(ClassToAdjust=class'KFGameContent.KFPawn_ZedBloatKingSubspawn',HealByAssistance=5)
                    )},
                    SpawnReplacementList={(
                                            (SpawnEntry=AT_Clot,NewClass=(class'KFGameContent.KFPawn_ZedCrawler'),PercentChance=0.6),
                                            (SpawnEntry=AT_AlphaClot,NewClass=(class'KFGameContent.KFPawn_ZedCrawler'),PercentChance=0.6),
                                            (SpawnEntry=AT_SlasherClot,NewClass=(class'KFGameContent.KFPawn_ZedCrawler'),PercentChance=0.6),
                                            (SpawnEntry=AT_Stalker,NewClass=(class'KFGameContent.KFPawn_ZedCrawler'),PercentChance=0.6),
                                            (SpawnEntry=AT_Bloat,NewClass=(class'KFGameContent.KFPawn_ZedCrawler'),PercentChance=0.6),
                                            (SpawnEntry=AT_Siren,NewClass=(class'KFGameContent.KFPawn_ZedCrawler'),PercentChance=0.6),
                                            (SpawnEntry=AT_Husk,NewClass=(class'KFGameContent.KFPawn_ZedCrawler'),PercentChance=0.6),
                                            (SpawnEntry=AT_GoreFast,NewClass=(class'KFGameContent.KFPawn_ZedCrawler'),PercentChance=0.6),
                                            //(SpawnEntry=AT_Scrake,NewClass=(class'KFGameContent.KFPawn_ZedCrawler'),PercentChance=0.7),
                                            //(SpawnEntry=AT_FleshPound,NewClass=(class'KFGameContent.KFPawn_ZedCrawler'),PercentChance=0.7),
                                            //(SpawnEntry=AT_FleshpoundMini,NewClass=(class'KFGameContent.KFPawn_ZedCrawler'),PercentChance=0.7),
                                            (SpawnEntry=AT_EliteClot,NewClass=(class'KFGameContent.KFPawn_ZedCrawler'),PercentChance=0.6),
                                            (SpawnEntry=AT_EliteGoreFast,NewClass=(class'KFGameContent.KFPawn_ZedCrawler'),PercentChance=0.6),
                                            (SpawnEntry=AT_EDAR_EMP,NewClass=(class'KFGameContent.KFPawn_ZedCrawler'),PercentChance=0.6),
                                            (SpawnEntry=AT_EDAR_Laser,NewClass=(class'KFGameContent.KFPawn_ZedCrawler'),PercentChance=0.6),
                                            (SpawnEntry=AT_EDAR_Rocket,NewClass=(class'KFGameContent.KFPawn_ZedCrawler'),PercentChance=0.6),
                                            (SpawnEntry=AT_Crawler,NewClass=(class'KFGameContent.KFPawn_ZedCrawler'),PercentChance=1.0)
                    )}
    )}

    // Broken Trader
    SetEvents[11]={(
                    EventDifficulty=1,
                    GameLength=GL_Normal,
                    bSpawnWeaponListAffectsSecondaryWeapons=true,
                    TraderWeaponList=KFGFxObject_TraderItems'GP_Trader_ARCH.BrokenTraderWeeklyTraderList',
                    PickupResetTime=PRS_Wave,
                    bDisableTraders=false,
                    DroppedItemLifespan=20.0f, //10.0f, // 300 default
                    DoshOnKillGlobalModifier=0.2,
                    WeeklyOutbreakId=11,
                        //Pickup Notes for when you're modifying:
                    //      NumPickups = Actors * OverridePickupModifer * WavePickupModifier
                    //      Ex: 16 item pickups in the world
                    //          * 0.9 Pickup Modifier = 14
                    //          * 0.5 Current wave modifier = 7 expected to spawn
                    //
                    //      Ex: 16 ammo pickups in the world
                    //          * 0.1 pickup modifier = 2
                    //          * 0.5 current wave modifier = 1 expected to spawn
                    bUnlimitedWeaponPickups=true,
                    OverrideItemPickupModifier=2.0,
                    OverrideAmmoPickupModifier=0.8, //0.5,
                    WaveItemPickupModifiers={(
                                1.0, 1.0, 1.0, 1.0, 1.0
                    )},
                    WaveAmmoPickupModifiers={(
                                0.5, 0.6, 0.7, 0.8, 0.9
                    )},
                    bUseOverrideAmmoRespawnTime=true,
                    OverrideAmmoRespawnTime={(
                                PlayersMod[0]=20.000000,
                                PlayersMod[1]=20.000000,
                                PlayersMod[2]=10.000000,
                                PlayersMod[3]=10.000000,
                                PlayersMod[4]=5.000000,
                                PlayersMod[5]=5.000000,
                                ModCap=1.000000
                    )},
                    bUseOverrideItemRespawnTime=true,
                    OverrideItemRespawnTime={(
                                PlayersMod[0]=10.000000,
                                PlayersMod[1]=10.000000,
                                PlayersMod[2]=5.000000,
                                PlayersMod[3]=5.000000,
                                PlayersMod[4]=2.000000,
                                PlayersMod[5]=2.000000,
                                ModCap=1.000000
                    )}
    )}
}