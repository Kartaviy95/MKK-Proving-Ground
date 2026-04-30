class MKK_PTG_PenetrationDisplay {
    idd = 88900;
    movingEnable = 1;
    enableSimulation = 1;
    onLoad = QUOTE(_this call FUNC(initDisplay));
    onUnload = "if !(missionNamespace getVariable ['mkk_ptg_penetrationClosingForCamera', false]) then {[] call ptg_penetration_fnc_stopOrbitCamera}; uiNamespace setVariable ['mkk_ptg_penetrationDisplay', displayNull];";

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
            idc = 88901;
            x = 0.06;
            y = 0.06;
            w = 0.38;
            h = 0.04;
            text = "$STR_MKK_PTG_PENETRATION_TEST";
            colorText[] = {1,1,1,1};
        };

        class Author: MKK_PTG_RscText {
            idc = 88902;
            x = 0.45;
            y = 0.06;
            w = 0.20;
            h = 0.04;
            text = "$STR_MKK_PTG_AUTHOR";
            colorText[] = {0.65,0.78,0.86,1};
        };

        class VehicleLabel: MKK_PTG_RscText {
            idc = -1;
            x = 0.06;
            y = 0.12;
            w = 0.26;
            h = 0.03;
            text = "$STR_MKK_PTG_TEST_VEHICLE";
        };

        class AmmoLabel: MKK_PTG_RscText {
            idc = -1;
            x = 0.36;
            y = 0.12;
            w = 0.24;
            h = 0.03;
            text = "$STR_MKK_PTG_TEST_AMMO";
        };

        class ReportLabel: MKK_PTG_RscText {
            idc = -1;
            x = 0.64;
            y = 0.12;
            w = 0.26;
            h = 0.03;
            text = "$STR_MKK_PTG_DAMAGE_REPORT";
        };
    };

    class controls {
        class VehicleSearch: MKK_PTG_RscEdit {
            idc = 88910;
            x = 0.06;
            y = 0.15;
            w = 0.26;
            h = 0.04;
            text = "";
            onKeyUp = QUOTE([] call FUNC(refreshVehicleList));
        };

        class VehicleList: MKK_PTG_RscListbox {
            idc = 88920;
            x = 0.06;
            y = 0.20;
            w = 0.26;
            h = 0.50;
        };

        class AmmoSearch: MKK_PTG_RscEdit {
            idc = 88911;
            x = 0.36;
            y = 0.15;
            w = 0.24;
            h = 0.04;
            text = "";
            onKeyUp = QUOTE([] call FUNC(refreshAmmoList));
        };

        class AmmoList: MKK_PTG_RscListbox {
            idc = 88921;
            x = 0.36;
            y = 0.20;
            w = 0.24;
            h = 0.50;
        };

        class Report: MKK_PTG_RscStructuredText {
            idc = 88931;
            x = 0.64;
            y = 0.15;
            w = 0.26;
            h = 0.55;
            text = "$STR_MKK_PTG_DAMAGE_REPORT_EMPTY";
        };

        class SpawnTargetBtn: MKK_PTG_RscButton {
            idc = 88940;
            x = 0.06;
            y = 0.73;
            w = 0.17;
            h = 0.04;
            text = "$STR_MKK_PTG_CREATE_TEST_TARGET";
            action = QUOTE([] call FUNC(serverCreateTarget));
        };

        class CameraBtn: MKK_PTG_RscButton {
            idc = 88941;
            x = 0.24;
            y = 0.73;
            w = 0.17;
            h = 0.04;
            text = "$STR_MKK_PTG_ORBIT_CAMERA";
            action = QUOTE([] call FUNC(startOrbitCamera));
        };

        class FireBtn: MKK_PTG_RscButton {
            idc = 88942;
            x = 0.42;
            y = 0.73;
            w = 0.17;
            h = 0.04;
            text = "$STR_MKK_PTG_FIRE_TEST_ROUND";
            action = QUOTE([] call FUNC(createTestShot));
        };

        class ResetBtn: MKK_PTG_RscButton {
            idc = 88943;
            x = 0.60;
            y = 0.73;
            w = 0.14;
            h = 0.04;
            text = "$STR_MKK_PTG_RESET_TEST";
            action = QUOTE([] call FUNC(resetTest));
        };

        class CloseBtn: MKK_PTG_RscButton {
            idc = 88944;
            x = 0.75;
            y = 0.73;
            w = 0.15;
            h = 0.04;
            text = "$STR_MKK_PTG_CLOSE";
            action = "closeDialog 0";
        };

        class Note: MKK_PTG_RscStructuredText {
            idc = 88932;
            x = 0.06;
            y = 0.79;
            w = 0.84;
            h = 0.06;
            text = "$STR_MKK_PTG_PENETRATION_NOTE";
        };
    };
};
