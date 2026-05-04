class MKK_PTG_MainDisplay {
    idd = 88000;
    movingEnable = 1;
    enableSimulation = 1;
    onLoad = QUOTE(_this call FUNC(initDisplay));
    onUnload = "uiNamespace setVariable ['mkk_ptg_display', displayNull];";

    class controlsBackground {
        class Background: MKK_PTG_RscText {
            idc = -1;
            x = 0.05;
            y = 0.05;
            w = 0.90;
            h = 0.85;
            colorBackground[] = {0.015,0.017,0.020,0.97};
        };

        class Header: MKK_PTG_RscText {
            idc = 88001;
            x = 0.06;
            y = 0.055;
            w = 0.44;
            h = 0.042;
            text = "$STR_MKK_PTG_MOD_NAME";
            colorText[] = {0.94,0.98,1,1};
            sizeEx = 0.038;
        };

        class Author: MKK_PTG_RscText {
            idc = 88004;
            x = 0.70;
            y = 0.060;
            w = 0.20;
            h = 0.035;
            text = "$STR_MKK_PTG_AUTHOR";
            colorText[] = {0.55,0.68,0.76,1};
            sizeEx = 0.026;
        };

        class SectionTitle: MKK_PTG_RscText {
            idc = 88003;
            x = 0.06;
            y = 0.103;
            w = 0.55;
            h = 0.034;
            text = "$STR_MKK_PTG_SELECT_FUNCTION";
            colorText[] = {0.72,0.88,1,1};
            sizeEx = 0.030;
        };

        class ResultCount: MKK_PTG_RscText {
            idc = 88002;
            x = 0.42;
            y = 0.135;
            w = 0.18;
            h = 0.03;
            text = "$STR_MKK_PTG_FOUND_ZERO";
        };

        class VehicleImage: MKK_PTG_RscPicture {
            idc = 88030;
            x = 0.67;
            y = 0.17;
            w = 0.23;
            h = 0.18;
            text = "";
        };

        class VehicleInfo: MKK_PTG_RscStructuredText {
            idc = 88031;
            x = 0.67;
            y = 0.36;
            w = 0.23;
            h = 0.32;
            text = "$STR_MKK_PTG_SELECT_VEHICLE";
        };
    };

    class controls {
        class DashboardHeaderAccent: MKK_PTG_RscText {
            idc = 88132;
            x = 0.06;
            y = 0.142;
            w = 0.84;
            h = 0.004;
            colorBackground[] = {0.18,0.58,0.72,0.95};
        };

        class DashboardPrepareCard: MKK_PTG_RscDashboardCard {
            idc = 88140;
            x = 0.075;
            y = 0.165;
            w = 0.270;
            h = 0.555;
        };

        class DashboardAnalyzeCard: MKK_PTG_RscDashboardCard {
            idc = 88141;
            x = 0.365;
            y = 0.165;
            w = 0.270;
            h = 0.555;
        };

        class DashboardSystemCard: MKK_PTG_RscDashboardCard {
            idc = 88142;
            x = 0.655;
            y = 0.165;
            w = 0.270;
            h = 0.555;
        };

        class DashboardPrepareTitle: MKK_PTG_RscDashboardLabel {
            idc = 88143;
            x = 0.092;
            y = 0.180;
            w = 0.236;
            h = 0.030;
            text = "$STR_MKK_PTG_DASHBOARD_PREPARE_TITLE";
        };

        class DashboardAnalyzeTitle: MKK_PTG_RscDashboardLabel {
            idc = 88144;
            x = 0.382;
            y = 0.180;
            w = 0.236;
            h = 0.030;
            text = "$STR_MKK_PTG_DASHBOARD_ANALYZE_TITLE";
        };

        class DashboardSystemTitle: MKK_PTG_RscDashboardLabel {
            idc = 88145;
            x = 0.672;
            y = 0.180;
            w = 0.236;
            h = 0.030;
            text = "$STR_MKK_PTG_DASHBOARD_SYSTEM_TITLE";
        };

        class DashboardPrepareHint: MKK_PTG_RscDashboardHint {
            idc = 88146;
            x = 0.092;
            y = 0.210;
            w = 0.236;
            h = 0.045;
            text = "$STR_MKK_PTG_DASHBOARD_PREPARE_HINT";
        };

        class DashboardAnalyzeHint: MKK_PTG_RscDashboardHint {
            idc = 88147;
            x = 0.382;
            y = 0.210;
            w = 0.236;
            h = 0.045;
            text = "$STR_MKK_PTG_DASHBOARD_ANALYZE_HINT";
        };

        class DashboardSystemHint: MKK_PTG_RscDashboardHint {
            idc = 88148;
            x = 0.672;
            y = 0.210;
            w = 0.236;
            h = 0.045;
            text = "$STR_MKK_PTG_DASHBOARD_SYSTEM_HINT";
        };

        class DashboardVehicleBtn: MKK_PTG_RscButtonPrimary {
            idc = 88100;
            x = 0.095;
            y = 0.270;
            w = 0.230;
            h = 0.046;
            text = "$STR_MKK_PTG_VEHICLE_SPAWN";
            action = QUOTE([] call FUNC(showVehicleView));
        };

        class DashboardTargetBtn: MKK_PTG_RscButtonPrimary {
            idc = 88122;
            x = 0.095;
            y = 0.326;
            w = 0.230;
            h = 0.046;
            text = "$STR_MKK_PTG_CREATE_TARGET";
            action = QUOTE([] call FUNC(openTargetOverlay));
        };

        class DashboardRearmBtn: MKK_PTG_RscButtonPrimary {
            idc = 88121;
            x = 0.095;
            y = 0.382;
            w = 0.230;
            h = 0.046;
            text = "$STR_MKK_PTG_REARM_PYLONS";
            action = QUOTE([] call FUNC(openRearmOverlay));
        };

        class DashboardUnlockVehicleBtn: MKK_PTG_RscButtonPrimary {
            idc = 88106;
            x = 0.095;
            y = 0.438;
            w = 0.230;
            h = 0.046;
            text = "$STR_MKK_PTG_UNLOCK_VEHICLE";
            action = QUOTE([] call EFUNC(main,unlockCursorVehicle));
        };

        class DashboardTeleportBtn: MKK_PTG_RscButtonSecondary {
            idc = 88101;
            x = 0.095;
            y = 0.494;
            w = 0.230;
            h = 0.046;
            text = "$STR_MKK_PTG_TELEPORT";
            action = QUOTE([] call FUNC(startTeleport));
        };

        class DashboardPrepareInfo: MKK_PTG_RscDashboardHint {
            idc = 88149;
            x = 0.092;
            y = 0.565;
            w = 0.236;
            h = 0.100;
            text = "$STR_MKK_PTG_DASHBOARD_PREPARE_INFO";
        };

        class DashboardCameraBtn: MKK_PTG_RscButtonPrimary {
            idc = 88120;
            x = 0.385;
            y = 0.270;
            w = 0.230;
            h = 0.046;
            text = "$STR_MKK_PTG_CAMERA";
            action = QUOTE([] call FUNC(startMapCamera));
        };

        class DashboardTrackingBtn: MKK_PTG_RscButtonSecondary {
            idc = 88102;
            x = 0.385;
            y = 0.326;
            w = 0.230;
            h = 0.046;
            text = "$STR_MKK_PTG_PROJECTILE_TRACKING";
            action = QUOTE([] call FUNC(toggleTracking));
        };

        class DashboardTrajectoryBtn: MKK_PTG_RscButtonSecondary {
            idc = 88110;
            x = 0.385;
            y = 0.382;
            w = 0.190;
            h = 0.046;
            text = "$STR_MKK_PTG_TRAJECTORY_LINES";
            action = QUOTE([] call EFUNC(tracking,toggleTrajectoryLines));
        };

        class DashboardTrajectorySettingsBtn: MKK_PTG_RscSettingsButton {
            idc = 88118;
            x = 0.580;
            y = 0.382;
            w = 0.035;
            h = 0.046;
            text = "\a3\ui_f\data\igui\cfg\simpletasks\types\repair_ca.paa";
            action = QUOTE([] call FUNC(toggleTrajectorySettings));
        };

        class DashboardMapMarkerBtn: MKK_PTG_RscButtonSecondary {
            idc = 88111;
            x = 0.385;
            y = 0.438;
            w = 0.190;
            h = 0.046;
            text = "$STR_MKK_PTG_MAP_PROJECTILE_MARKERS";
            action = QUOTE([] call EFUNC(tracking,toggleMapProjectileMarkers));
        };

        class DashboardMapMarkerSettingsBtn: MKK_PTG_RscSettingsButton {
            idc = 88119;
            x = 0.580;
            y = 0.438;
            w = 0.035;
            h = 0.046;
            text = "\a3\ui_f\data\igui\cfg\simpletasks\types\repair_ca.paa";
            action = QUOTE([] call FUNC(toggleMapProjectileMarkerSettings));
        };

        class DashboardObjectStatusBtn: MKK_PTG_RscButtonPrimary {
            idc = 88115;
            x = 0.385;
            y = 0.494;
            w = 0.190;
            h = 0.046;
            text = "$STR_MKK_PTG_OBJECT_STATUS_DISPLAY";
            action = QUOTE([] call FUNC(toggleObjectStatusDisplay));
        };

        class DashboardObjectStatusSettingsBtn: MKK_PTG_RscSettingsButton {
            idc = 88117;
            x = 0.580;
            y = 0.494;
            w = 0.035;
            h = 0.046;
            text = "\a3\ui_f\data\igui\cfg\simpletasks\types\repair_ca.paa";
            action = QUOTE([] call FUNC(toggleObjectStatusSettings));
        };

        class DashboardHitpointInspectorBtn: MKK_PTG_RscButtonPrimary {
            idc = 88116;
            x = 0.385;
            y = 0.550;
            w = 0.230;
            h = 0.046;
            text = "$STR_MKK_PTG_HITPOINT_INSPECTOR";
            action = QUOTE([] call FUNC(toggleHitpointInspector));
        };

        class DashboardPenetrationBtn: MKK_PTG_RscButtonDisabledTile {
            idc = 88109;
            x = 0.385;
            y = 0.606;
            w = 0.230;
            h = 0.046;
            text = "$STR_MKK_PTG_PENETRATION_TEST_DEV";
            action = "";
            enabled = 0;
        };

        class DashboardMapMarkerAmmoBtn: MKK_PTG_RscButtonSecondary {
            idc = 88112;
            x = 0.385;
            y = 0.662;
            w = 0.230;
            h = 0.046;
            text = "$STR_MKK_PTG_MAP_MARKER_AMMO";
            action = QUOTE([] call EFUNC(tracking,toggleMapProjectileMarkerAmmo));
        };

        class DashboardInfiniteAmmoBtn: MKK_PTG_RscButtonToggle {
            idc = 88113;
            x = 0.675;
            y = 0.270;
            w = 0.230;
            h = 0.046;
            text = "$STR_MKK_PTG_INFINITE_AMMO";
            action = QUOTE([] call EFUNC(player,toggleInfiniteAmmo));
        };

        class DashboardGodModeBtn: MKK_PTG_RscButtonToggle {
            idc = 88114;
            x = 0.675;
            y = 0.326;
            w = 0.230;
            h = 0.046;
            text = "$STR_MKK_PTG_GOD_MODE";
            action = QUOTE([] call EFUNC(player,toggleGodMode));
        };

        class DashboardInterfaceSizeLabel: MKK_PTG_RscText {
            idc = 88130;
            x = 0.675;
            y = 0.393;
            w = 0.230;
            h = 0.026;
            text = "$STR_MKK_PTG_INTERFACE_SIZE";
            colorText[] = {0.72,0.88,1,1};
            sizeEx = 0.028;
        };

        class DashboardInterfaceSizeCombo: MKK_PTG_RscCombo {
            idc = 88131;
            x = 0.675;
            y = 0.424;
            w = 0.230;
            h = 0.042;
            onLBSelChanged = QUOTE(_this call FUNC(onInterfaceSizeSelected));
        };

        class DashboardSystemInfo: MKK_PTG_RscDashboardHint {
            idc = 88150;
            x = 0.672;
            y = 0.488;
            w = 0.236;
            h = 0.095;
            text = "$STR_MKK_PTG_DASHBOARD_SYSTEM_INFO";
        };

        class DashboardCleanupBtn: MKK_PTG_RscButtonDanger {
            idc = 88105;
            x = 0.675;
            y = 0.600;
            w = 0.230;
            h = 0.046;
            text = "$STR_MKK_PTG_CLEANUP_RANGE";
            action = QUOTE([] call FUNC(onCleanupPressed));
        };

        class DashboardCloseBtn: MKK_PTG_RscButtonSecondary {
            idc = 88107;
            x = 0.675;
            y = 0.656;
            w = 0.230;
            h = 0.046;
            text = "$STR_MKK_PTG_CLOSE";
            action = "closeDialog 0";
        };

        class DashboardInfo: MKK_PTG_RscStructuredText {
            idc = 88108;
            x = 0.075;
            y = 0.742;
            w = 0.850;
            h = 0.072;
            text = "$STR_MKK_PTG_DASHBOARD_INFO";
            colorText[] = {0.78,0.88,0.95,1};
        };

        class SearchLabel: MKK_PTG_RscText {
            idc = 88050;
            x = 0.06;
            y = 0.145;
            w = 0.16;
            h = 0.025;
            text = "$STR_MKK_PTG_SEARCH";
        };

        class SearchEdit: MKK_PTG_RscEdit {
            idc = 88010;
            x = 0.06;
            y = 0.17;
            w = 0.18;
            h = 0.04;
            text = "";
            onKeyUp = QUOTE([] call FUNC(refreshVehicleList));
        };

        class SideLabel: MKK_PTG_RscText {
            idc = 88051;
            x = 0.06;
            y = 0.215;
            w = 0.16;
            h = 0.025;
            text = "$STR_MKK_PTG_SIDE";
        };

        class SideCombo: MKK_PTG_RscCombo {
            idc = 88011;
            x = 0.06;
            y = 0.24;
            w = 0.16;
            h = 0.04;
            onLBSelChanged = QUOTE([] call FUNC(refreshVehicleList));
        };

        class FactionLabel: MKK_PTG_RscText {
            idc = 88052;
            x = 0.06;
            y = 0.285;
            w = 0.16;
            h = 0.025;
            text = "$STR_MKK_PTG_FACTION";
        };

        class FactionCombo: MKK_PTG_RscCombo {
            idc = 88012;
            x = 0.06;
            y = 0.31;
            w = 0.16;
            h = 0.04;
            onLBSelChanged = QUOTE([] call FUNC(refreshVehicleList));
        };

        class TypeLabel: MKK_PTG_RscText {
            idc = 88054;
            x = 0.06;
            y = 0.355;
            w = 0.16;
            h = 0.025;
            text = "$STR_MKK_PTG_TYPE";
        };

        class TypeCombo: MKK_PTG_RscCombo {
            idc = 88014;
            x = 0.06;
            y = 0.38;
            w = 0.16;
            h = 0.04;
            onLBSelChanged = QUOTE([] call FUNC(refreshVehicleList));
        };

        class DistanceLabel: MKK_PTG_RscText {
            idc = 88055;
            x = 0.06;
            y = 0.515;
            w = 0.16;
            h = 0.025;
            text = "$STR_MKK_PTG_SPAWN_DISTANCE";
        };

        class SpawnDistanceEdit: MKK_PTG_RscEdit {
            idc = 88015;
            x = 0.06;
            y = 0.54;
            w = 0.16;
            h = 0.04;
            text = "30";
        };

        class DirectionLabel: MKK_PTG_RscText {
            idc = 88056;
            x = 0.06;
            y = 0.585;
            w = 0.16;
            h = 0.025;
            text = "$STR_MKK_PTG_DIRECTION_OFFSET";
        };

        class SpawnDirectionEdit: MKK_PTG_RscEdit {
            idc = 88016;
            x = 0.06;
            y = 0.61;
            w = 0.16;
            h = 0.04;
            text = "0";
        };

        class VehicleList: MKK_PTG_RscListbox {
            idc = 88020;
            x = 0.25;
            y = 0.17;
            w = 0.38;
            h = 0.44;
            onLBSelChanged = QUOTE(_this call FUNC(onVehicleSelected));
        };

        class StaticAmmoBoxLabel: MKK_PTG_RscText {
            idc = 88057;
            x = 0.25;
            y = 0.62;
            w = 0.24;
            h = 0.025;
            text = "$STR_MKK_PTG_COMPATIBLE_AMMO_BOX";
        };

        class StaticAmmoBoxCombo: MKK_PTG_RscCombo {
            idc = 88017;
            x = 0.25;
            y = 0.645;
            w = 0.38;
            h = 0.04;
        };

        class SpawnBtn: MKK_PTG_RscButton {
            idc = 88040;
            x = 0.06;
            y = 0.70;
            w = 0.26;
            h = 0.045;
            text = "$STR_MKK_PTG_SPAWN_EMPTY";
            action = QUOTE([false] call FUNC(onSpawnPressed));
        };

        class SpawnCrewBtn: MKK_PTG_RscButton {
            idc = 88041;
            x = 0.35;
            y = 0.70;
            w = 0.26;
            h = 0.045;
            text = "$STR_MKK_PTG_SPAWN_WITH_CREW";
            action = QUOTE([true] call FUNC(onSpawnPressed));
        };

        class CleanupBtn: MKK_PTG_RscButton {
            idc = 88044;
            x = 0.64;
            y = 0.70;
            w = 0.26;
            h = 0.045;
            text = "$STR_MKK_PTG_CLEANUP_RANGE";
            action = QUOTE([] call FUNC(onCleanupPressed));
        };

        class RefreshBtn: MKK_PTG_RscButton {
            idc = 88045;
            x = 0.06;
            y = 0.755;
            w = 0.26;
            h = 0.045;
            text = "$STR_MKK_PTG_REFRESH";
            action = QUOTE([true] call FUNC(refreshFilters));
        };

        class CopyClassBtn: MKK_PTG_RscButton {
            idc = 88047;
            x = 0.35;
            y = 0.755;
            w = 0.26;
            h = 0.045;
            text = "$STR_MKK_PTG_COPY_CLASS";
            action = QUOTE([] call FUNC(onCopyClassPressed));
        };

        class BackBtn: MKK_PTG_RscButton {
            idc = 88046;
            x = 0.64;
            y = 0.755;
            w = 0.26;
            h = 0.045;
            text = "$STR_MKK_PTG_BACK";
            action = QUOTE([] call FUNC(showDashboardView));
        };

        class TargetOverlayBackground: MKK_PTG_RscText {
            idc = 88300;
            x = 0.05;
            y = 0.05;
            w = 0.90;
            h = 0.85;
            colorBackground[] = {0.03,0.03,0.03,0.97};
        };

        class TargetOverlayHeader: MKK_PTG_RscText {
            idc = 88301;
            x = 0.06;
            y = 0.06;
            w = 0.62;
            h = 0.04;
            text = "$STR_MKK_PTG_CREATE_TARGET";
            colorText[] = {1,1,1,1};
        };

        class TargetOverlayAuthor: MKK_PTG_RscText {
            idc = 88302;
            x = 0.70;
            y = 0.06;
            w = 0.20;
            h = 0.04;
            text = "$STR_MKK_PTG_AUTHOR";
            colorText[] = {0.65,0.78,0.86,1};
        };

        class TargetModeLabel: MKK_PTG_RscText {
            idc = 88303;
            x = 0.06;
            y = 0.12;
            w = 0.18;
            h = 0.03;
            text = "$STR_MKK_PTG_TARGET_TYPE";
        };

        class TargetModeCombo: MKK_PTG_RscCombo {
            idc = 88310;
            x = 0.06;
            y = 0.15;
            w = 0.18;
            h = 0.04;
            onLBSelChanged = QUOTE([] call FUNC(refreshTargetList));
        };

        class TargetSearchLabel: MKK_PTG_RscText {
            idc = 88304;
            x = 0.06;
            y = 0.205;
            w = 0.18;
            h = 0.03;
            text = "$STR_MKK_PTG_SEARCH";
        };

        class TargetSearchEdit: MKK_PTG_RscEdit {
            idc = 88311;
            x = 0.06;
            y = 0.235;
            w = 0.18;
            h = 0.04;
            text = "";
            onKeyUp = QUOTE([] call FUNC(refreshTargetList));
        };

        class TargetDistanceLabel: MKK_PTG_RscText {
            idc = 88308;
            x = 0.06;
            y = 0.29;
            w = 0.18;
            h = 0.03;
            text = "$STR_MKK_PTG_SPAWN_DISTANCE";
        };

        class TargetDistanceEdit: MKK_PTG_RscEdit {
            idc = 88315;
            x = 0.06;
            y = 0.32;
            w = 0.18;
            h = 0.04;
            text = "5";
        };

        class TargetSectorLabel: MKK_PTG_RscText {
            idc = 88305;
            x = 0.06;
            y = 0.375;
            w = 0.18;
            h = 0.03;
            text = "$STR_MKK_PTG_TARGET_MOVE_SECTOR";
        };

        class TargetSectorEdit: MKK_PTG_RscEdit {
            idc = 88316;
            x = 0.06;
            y = 0.405;
            w = 0.18;
            h = 0.04;
            text = "50";
        };

        class TargetAirRadiusLabel: MKK_PTG_RscText {
            idc = 88306;
            x = 0.06;
            y = 0.375;
            w = 0.18;
            h = 0.03;
            text = "$STR_MKK_PTG_TARGET_AIR_RADIUS";
        };

        class TargetAirRadiusEdit: MKK_PTG_RscEdit {
            idc = 88317;
            x = 0.06;
            y = 0.405;
            w = 0.18;
            h = 0.04;
            text = "150";
        };

        class TargetAirHeightLabel: MKK_PTG_RscText {
            idc = 88307;
            x = 0.06;
            y = 0.46;
            w = 0.18;
            h = 0.03;
            text = "$STR_MKK_PTG_TARGET_AIR_HEIGHT";
        };

        class TargetAirHeightEdit: MKK_PTG_RscEdit {
            idc = 88318;
            x = 0.06;
            y = 0.49;
            w = 0.18;
            h = 0.04;
            text = "100";
        };

        class TargetListLabel: MKK_PTG_RscText {
            idc = 88309;
            x = 0.27;
            y = 0.12;
            w = 0.36;
            h = 0.03;
            text = "$STR_MKK_PTG_TARGET_SELECT";
        };

        class TargetList: MKK_PTG_RscListbox {
            idc = 88320;
            x = 0.27;
            y = 0.15;
            w = 0.36;
            h = 0.50;
            onLBSelChanged = QUOTE(_this call FUNC(onTargetSelected));
        };

        class TargetPreview: MKK_PTG_RscPicture {
            idc = 88330;
            style = 2096;
            x = 0.67;
            y = 0.15;
            w = 0.23;
            h = 0.20;
            text = "";
        };

        class TargetInfo: MKK_PTG_RscStructuredText {
            idc = 88331;
            x = 0.67;
            y = 0.37;
            w = 0.23;
            h = 0.28;
            text = "$STR_MKK_PTG_TARGET_SELECT_FIRST";
        };

        class TargetCreateBtn: MKK_PTG_RscButton {
            idc = 88340;
            x = 0.27;
            y = 0.70;
            w = 0.18;
            h = 0.05;
            text = "$STR_MKK_PTG_CREATE_TARGET";
            action = QUOTE([] call FUNC(onTargetSpawnPressed));
        };

        class TargetDeleteBtn: MKK_PTG_RscButton {
            idc = 88341;
            x = 0.48;
            y = 0.70;
            w = 0.18;
            h = 0.05;
            text = "$STR_MKK_PTG_DELETE_TARGETS";
            action = QUOTE([] call FUNC(onDeleteTargetsPressed));
            colorBackground[] = {0.24,0.08,0.08,0.95};
            colorBackgroundActive[] = {0.38,0.10,0.10,1};
        };

        class TargetCloseBtn: MKK_PTG_RscButton {
            idc = 88342;
            x = 0.69;
            y = 0.70;
            w = 0.18;
            h = 0.05;
            text = "$STR_MKK_PTG_CLOSE";
            action = QUOTE([] call FUNC(closeTargetOverlay));
        };

        class RearmOverlayBackground: MKK_PTG_RscText {
            idc = 88200;
            x = 0.05;
            y = 0.05;
            w = 0.90;
            h = 0.85;
            colorBackground[] = {0.03,0.03,0.03,0.97};
        };

        class RearmOverlayHeader: MKK_PTG_RscText {
            idc = 88201;
            x = 0.06;
            y = 0.06;
            w = 0.62;
            h = 0.04;
            text = "$STR_MKK_PTG_REARM";
            colorText[] = {1,1,1,1};
        };

        class RearmOverlayAuthor: MKK_PTG_RscText {
            idc = 88202;
            x = 0.70;
            y = 0.06;
            w = 0.20;
            h = 0.04;
            text = "$STR_MKK_PTG_AUTHOR";
            colorText[] = {0.65,0.78,0.86,1};
        };

        class RearmVehicleLabel: MKK_PTG_RscText {
            idc = 88203;
            x = 0.06;
            y = 0.12;
            w = 0.26;
            h = 0.03;
            text = "$STR_MKK_PTG_REARM_CURRENT_VEHICLE";
        };

        class RearmSlotLabel: MKK_PTG_RscText {
            idc = 88204;
            x = 0.35;
            y = 0.12;
            w = 0.15;
            h = 0.03;
            text = "$STR_MKK_PTG_REARM_CREW_POSITION";
        };

        class RearmWeaponLabel: MKK_PTG_RscText {
            idc = 88205;
            x = 0.51;
            y = 0.12;
            w = 0.15;
            h = 0.03;
            text = "$STR_MKK_PTG_REARM_WEAPONS";
        };

        class RearmMagazineLabel: MKK_PTG_RscText {
            idc = 88206;
            x = 0.67;
            y = 0.12;
            w = 0.23;
            h = 0.03;
            text = "$STR_MKK_PTG_REARM_MAGAZINES";
        };

        class RearmHint: MKK_PTG_RscStructuredText {
            idc = 88207;
            x = 0.06;
            y = 0.82;
            w = 0.84;
            h = 0.06;
            text = "$STR_MKK_PTG_REARM_NOTE";
        };

        class RearmVehiclePreview: MKK_PTG_RscPicture {
            idc = 88230;
            style = 2096;
            x = 0.06;
            y = 0.15;
            w = 0.26;
            h = 0.20;
            text = "";
        };

        class RearmVehicleInfo: MKK_PTG_RscStructuredText {
            idc = 88231;
            x = 0.06;
            y = 0.37;
            w = 0.26;
            h = 0.23;
            text = "";
        };

        class RearmSlotList: MKK_PTG_RscListbox {
            idc = 88220;
            x = 0.35;
            y = 0.15;
            w = 0.15;
            h = 0.29;
            onLBSelChanged = QUOTE(_this call FUNC(onRearmTurretSelected));
        };

        class RearmWeaponList: MKK_PTG_RscListbox {
            idc = 88221;
            x = 0.51;
            y = 0.15;
            w = 0.15;
            h = 0.29;
            onLBSelChanged = QUOTE(_this call FUNC(onRearmWeaponSelected));
        };

        class RearmMagazineList: MKK_PTG_RscListbox {
            idc = 88222;
            x = 0.67;
            y = 0.15;
            w = 0.23;
            h = 0.45;
            onLBSelChanged = QUOTE(_this call FUNC(onRearmMagazineSelected));
        };

        class RearmMagazineInfo: MKK_PTG_RscStructuredText {
            idc = 88232;
            x = 0.35;
            y = 0.46;
            w = 0.31;
            h = 0.14;
            text = "$STR_MKK_PTG_REARM_MAGAZINE_INFO_EMPTY";
            colorBackground[] = {0.08,0.08,0.08,0.95};
        };

        class RearmMagazineStatus: MKK_PTG_RscStructuredText {
            idc = 88233;
            x = 0.67;
            y = 0.61;
            w = 0.23;
            h = 0.06;
            text = "";
        };

        class RearmLoadBtn: MKK_PTG_RscButton {
            idc = 88240;
            x = 0.35;
            y = 0.70;
            w = 0.13;
            h = 0.05;
            text = "$STR_MKK_PTG_REARM_LOAD_NOW";
            action = QUOTE([] call FUNC(loadSelectedRearmMagazine));
            colorBackground[] = {0.08,0.18,0.24,0.95};
            colorBackgroundActive[] = {0.10,0.30,0.40,1};
        };

        class RearmClearWeaponBtn: MKK_PTG_RscButton {
            idc = 88243;
            x = 0.49;
            y = 0.70;
            w = 0.13;
            h = 0.05;
            text = "$STR_MKK_PTG_REARM_CLEAR_WEAPON";
            action = QUOTE([] call FUNC(clearSelectedRearmWeapon));
            colorBackground[] = {0.24,0.08,0.08,0.95};
            colorBackgroundActive[] = {0.38,0.10,0.10,1};
        };

        class RearmCopyMagazineClassBtn: MKK_PTG_RscButton {
            idc = 88241;
            x = 0.63;
            y = 0.70;
            w = 0.13;
            h = 0.05;
            text = "$STR_MKK_PTG_REARM_MAGAZINE_CLASS";
            action = QUOTE([] call FUNC(copySelectedRearmMagazineClass));
        };

        class RearmCloseBtn: MKK_PTG_RscButton {
            idc = 88242;
            x = 0.77;
            y = 0.70;
            w = 0.13;
            h = 0.05;
            text = "$STR_MKK_PTG_CLOSE";
            action = QUOTE([] call FUNC(closeRearmOverlay));
        };

    };
};

class MKK_PTG_SettingsDisplay {
    idd = 88800;
    movingEnable = 1;
    enableSimulation = 1;
    onLoad = QUOTE(_this call FUNC(initSettingsDisplay));
    onUnload = "uiNamespace setVariable ['mkk_ptg_settingsDisplay', displayNull]; uiNamespace setVariable ['mkk_ptg_objectStatusSettingsControls', []]; uiNamespace setVariable ['mkk_ptg_mapProjectileMarkerSettingsControls', []]; uiNamespace setVariable ['mkk_ptg_trajectorySettingsControls', []];";

    class controlsBackground {};
    class controls {};
};
