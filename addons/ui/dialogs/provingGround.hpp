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
            colorBackground[] = {0.03,0.03,0.03,0.95};
        };

        class Header: MKK_PTG_RscText {
            idc = 88001;
            x = 0.06;
            y = 0.06;
            w = 0.38;
            h = 0.04;
            text = "$STR_MKK_PTG_MOD_NAME";
            colorText[] = {1,1,1,1};
        };

        class Author: MKK_PTG_RscText {
            idc = 88004;
            x = 0.45;
            y = 0.06;
            w = 0.20;
            h = 0.04;
            text = "$STR_MKK_PTG_AUTHOR";
            colorText[] = {0.65,0.78,0.86,1};
        };

        class SectionTitle: MKK_PTG_RscText {
            idc = 88003;
            x = 0.06;
            y = 0.105;
            w = 0.40;
            h = 0.035;
            text = "$STR_MKK_PTG_SELECT_FUNCTION";
            colorText[] = {0.72,0.88,1,1};
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
        class DashboardVehicleBtn: MKK_PTG_RscButton {
            idc = 88100;
            x = 0.10;
            y = 0.19;
            w = 0.24;
            h = 0.08;
            text = "$STR_MKK_PTG_VEHICLE_SPAWN";
            action = QUOTE([] call FUNC(showVehicleView));
            colorBackground[] = {0.08,0.18,0.24,0.95};
            colorBackgroundActive[] = {0.10,0.30,0.40,1};
        };

        class DashboardTeleportBtn: MKK_PTG_RscButton {
            idc = 88101;
            x = 0.38;
            y = 0.19;
            w = 0.24;
            h = 0.08;
            text = "$STR_MKK_PTG_TELEPORT";
            action = QUOTE([] call FUNC(startTeleport));
        };

        class DashboardTrackingBtn: MKK_PTG_RscButton {
            idc = 88102;
            x = 0.10;
            y = 0.30;
            w = 0.24;
            h = 0.08;
            text = "$STR_MKK_PTG_PROJECTILE_TRACKING";
            action = QUOTE([] call FUNC(toggleTracking));
        };

        class DashboardCleanupBtn: MKK_PTG_RscButton {
            idc = 88105;
            x = 0.10;
            y = 0.52;
            w = 0.24;
            h = 0.08;
            text = "$STR_MKK_PTG_CLEANUP_RANGE";
            action = QUOTE([] call FUNC(onCleanupPressed));
            colorBackground[] = {0.24,0.08,0.08,0.95};
            colorBackgroundActive[] = {0.38,0.10,0.10,1};
        };

        class DashboardPenetrationBtn: MKK_PTG_RscButton {
            idc = 88109;
            x = 0.66;
            y = 0.19;
            w = 0.24;
            h = 0.08;
            text = "$STR_MKK_PTG_PENETRATION_TEST";
            action = QUOTE([] call EFUNC(penetration,openDisplay));
            colorBackground[] = {0.08,0.18,0.24,0.95};
            colorBackgroundActive[] = {0.10,0.30,0.40,1};
        };

        class DashboardTrajectoryBtn: MKK_PTG_RscButton {
            idc = 88110;
            x = 0.38;
            y = 0.30;
            w = 0.205;
            h = 0.08;
            text = "$STR_MKK_PTG_TRAJECTORY_LINES";
            action = QUOTE([] call EFUNC(tracking,toggleTrajectoryLines));
        };

        class DashboardTrajectorySettingsBtn: MKK_PTG_RscPictureButton {
            idc = 88118;
            x = 0.59;
            y = 0.30;
            w = 0.03;
            h = 0.08;
            text = "\a3\ui_f\data\igui\cfg\simpletasks\types\repair_ca.paa";
            action = QUOTE([] call FUNC(toggleTrajectorySettings));
        };

        class DashboardRefreshBtn: MKK_PTG_RscButton {
            idc = 88106;
            x = 0.38;
            y = 0.52;
            w = 0.24;
            h = 0.08;
            text = "$STR_MKK_PTG_REFRESH_CATALOG";
            action = QUOTE([true] call FUNC(refreshFilters));
        };

        class DashboardMapMarkerBtn: MKK_PTG_RscButton {
            idc = 88111;
            x = 0.66;
            y = 0.30;
            w = 0.205;
            h = 0.08;
            text = "$STR_MKK_PTG_MAP_PROJECTILE_MARKERS";
            action = QUOTE([] call EFUNC(tracking,toggleMapProjectileMarkers));
        };

        class DashboardMapMarkerSettingsBtn: MKK_PTG_RscPictureButton {
            idc = 88119;
            x = 0.87;
            y = 0.30;
            w = 0.03;
            h = 0.08;
            text = "\a3\ui_f\data\igui\cfg\simpletasks\types\repair_ca.paa";
            action = QUOTE([] call FUNC(toggleMapProjectileMarkerSettings));
        };

        class DashboardMapMarkerAmmoBtn: MKK_PTG_RscButton {
            idc = 88112;
            x = 0.10;
            y = 0.41;
            w = 0.24;
            h = 0.08;
            text = "$STR_MKK_PTG_MAP_MARKER_AMMO";
            action = QUOTE([] call EFUNC(tracking,toggleMapProjectileMarkerAmmo));
        };

        class DashboardInfiniteAmmoBtn: MKK_PTG_RscButton {
            idc = 88113;
            x = 0.38;
            y = 0.41;
            w = 0.24;
            h = 0.08;
            text = "$STR_MKK_PTG_INFINITE_AMMO";
            action = QUOTE([] call EFUNC(player,toggleInfiniteAmmo));
        };

        class DashboardGodModeBtn: MKK_PTG_RscButton {
            idc = 88114;
            x = 0.66;
            y = 0.41;
            w = 0.24;
            h = 0.08;
            text = "$STR_MKK_PTG_GOD_MODE";
            action = QUOTE([] call EFUNC(player,toggleGodMode));
        };

        class DashboardHitpointInspectorBtn: MKK_PTG_RscButton {
            idc = 88116;
            x = 0.66;
            y = 0.52;
            w = 0.24;
            h = 0.08;
            text = "$STR_MKK_PTG_HITPOINT_INSPECTOR";
            action = QUOTE([] call FUNC(toggleHitpointInspector));
            colorBackground[] = {0.08,0.18,0.24,0.95};
            colorBackgroundActive[] = {0.10,0.30,0.40,1};
        };

        class DashboardCameraBtn: MKK_PTG_RscButton {
            idc = 88120;
            x = 0.10;
            y = 0.63;
            w = 0.24;
            h = 0.08;
            text = "$STR_MKK_PTG_CAMERA";
            action = QUOTE([] call FUNC(startMapCamera));
            colorBackground[] = {0.08,0.18,0.24,0.95};
            colorBackgroundActive[] = {0.10,0.30,0.40,1};
        };

        class DashboardCloseBtn: MKK_PTG_RscButton {
            idc = 88107;
            x = 0.38;
            y = 0.63;
            w = 0.24;
            h = 0.08;
            text = "$STR_MKK_PTG_CLOSE";
            action = "closeDialog 0";
        };

        class DashboardObjectStatusBtn: MKK_PTG_RscButton {
            idc = 88115;
            x = 0.10;
            y = 0.41;
            w = 0.205;
            h = 0.08;
            text = "$STR_MKK_PTG_OBJECT_STATUS_DISPLAY";
            action = QUOTE([] call FUNC(toggleObjectStatusDisplay));
            colorBackground[] = {0.08,0.18,0.24,0.95};
            colorBackgroundActive[] = {0.10,0.30,0.40,1};
        };

        class DashboardObjectStatusSettingsBtn: MKK_PTG_RscButton {
            idc = 88117;
            x = 0.31;
            y = 0.41;
            w = 0.03;
            h = 0.08;
            text = "\a3\ui_f\data\igui\cfg\simpletasks\types\repair_ca.paa";
            action = QUOTE([] call FUNC(toggleObjectStatusSettings));
            style = 48 + 0x800;
            colorBackground[] = {0.08,0.18,0.24,0.95};
            colorBackgroundActive[] = {0.10,0.30,0.40,1};
        };

        class DashboardInfo: MKK_PTG_RscStructuredText {
            idc = 88108;
            x = 0.10;
            y = 0.74;
            w = 0.80;
            h = 0.08;
            text = "$STR_MKK_PTG_DASHBOARD_INFO";
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
    };
};
