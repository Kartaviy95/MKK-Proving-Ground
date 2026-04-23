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
            w = 0.50;
            h = 0.04;
            text = "MKK Proving Ground";
            colorText[] = {1,1,1,1};
        };

        class ResultCount: MKK_PTG_RscText {
            idc = 88002;
            x = 0.42;
            y = 0.16;
            w = 0.18;
            h = 0.03;
            text = "Найдено: 0";
        };

        class VehicleImage: MKK_PTG_RscPicture {
            idc = 88030;
            x = 0.67;
            y = 0.16;
            w = 0.23;
            h = 0.18;
            text = "";
        };

        class VehicleInfo: MKK_PTG_RscStructuredText {
            idc = 88031;
            x = 0.67;
            y = 0.35;
            w = 0.23;
            h = 0.32;
            text = "Выберите технику";
        };
    };

    class controls {
        class SearchEdit: MKK_PTG_RscEdit {
            idc = 88010;
            x = 0.06;
            y = 0.12;
            w = 0.18;
            h = 0.04;
            text = "";
            onKeyUp = QUOTE([] call FUNC(refreshVehicleList));
        };

        class SideCombo: MKK_PTG_RscCombo {
            idc = 88011;
            x = 0.06;
            y = 0.18;
            w = 0.16;
            h = 0.04;
            onLBSelChanged = QUOTE([] call FUNC(refreshVehicleList));
        };

        class FactionCombo: MKK_PTG_RscCombo {
            idc = 88012;
            x = 0.06;
            y = 0.24;
            w = 0.16;
            h = 0.04;
            onLBSelChanged = QUOTE([] call FUNC(refreshVehicleList));
        };

        class NationCombo: MKK_PTG_RscCombo {
            idc = 88013;
            x = 0.06;
            y = 0.30;
            w = 0.16;
            h = 0.04;
            onLBSelChanged = QUOTE([] call FUNC(refreshVehicleList));
        };

        class TypeCombo: MKK_PTG_RscCombo {
            idc = 88014;
            x = 0.06;
            y = 0.36;
            w = 0.16;
            h = 0.04;
            onLBSelChanged = QUOTE([] call FUNC(refreshVehicleList));
        };

        class VehicleList: MKK_PTG_RscListbox {
            idc = 88020;
            x = 0.25;
            y = 0.12;
            w = 0.38;
            h = 0.64;
            onLBSelChanged = QUOTE(_this call FUNC(onVehicleSelected));
        };

        class SpawnBtn: MKK_PTG_RscButton {
            idc = 88040;
            x = 0.06;
            y = 0.72;
            w = 0.16;
            h = 0.04;
            text = "Spawn Empty";
            action = QUOTE([false] call FUNC(onSpawnPressed));
        };

        class SpawnCrewBtn: MKK_PTG_RscButton {
            idc = 88041;
            x = 0.06;
            y = 0.77;
            w = 0.16;
            h = 0.04;
            text = "Spawn With Crew";
            action = QUOTE([true] call FUNC(onSpawnPressed));
        };

        class StaticTargetBtn: MKK_PTG_RscButton {
            idc = 88042;
            x = 0.25;
            y = 0.77;
            w = 0.18;
            h = 0.04;
            text = "Spawn Static Target";
            action = QUOTE([player] remoteExecCall [ARR_2(QQEFUNC(targets,spawnInfantryTarget),2)]);
        };

        class InfantryTargetBtn: MKK_PTG_RscButton {
            idc = 88043;
            x = 0.44;
            y = 0.77;
            w = 0.19;
            h = 0.04;
            text = "Spawn Infantry Target";
            action = QUOTE([player] remoteExecCall [ARR_2(QQEFUNC(targets,spawnInfantryTarget),2)]);
        };

        class CleanupBtn: MKK_PTG_RscButton {
            idc = 88044;
            x = 0.67;
            y = 0.72;
            w = 0.23;
            h = 0.04;
            text = "Cleanup Range";
            action = QUOTE([] call FUNC(onCleanupPressed));
        };

        class RefreshBtn: MKK_PTG_RscButton {
            idc = 88045;
            x = 0.67;
            y = 0.77;
            w = 0.11;
            h = 0.04;
            text = "Refresh";
            action = QUOTE([] call FUNC(refreshFilters));
        };

        class CloseBtn: MKK_PTG_RscButton {
            idc = 88046;
            x = 0.79;
            y = 0.77;
            w = 0.11;
            h = 0.04;
            text = "Close";
            action = "closeDialog 0";
        };
    };
};
