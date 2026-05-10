class MKK_PTG_ExplosionDisplay {
    idd = 89000;
    movingEnable = 1;
    enableSimulation = 1;
    onLoad = QUOTE(_this call FUNC(initExplosionDisplay));
    onUnload = "uiNamespace setVariable ['mkk_ptg_explosionDisplay', displayNull];";

    class controlsBackground {
        class Background: MKK_PTG_RscText {
            idc = -1;
            x = 0.04;
            y = 0.04;
            w = 0.92;
            h = 0.88;
            colorBackground[] = {0.03,0.03,0.03,0.95};
        };

        class Header: MKK_PTG_RscText {
            idc = 89001;
            x = 0.055;
            y = 0.052;
            w = 0.42;
            h = 0.04;
            text = "$STR_MKK_PTG_CREATE_EXPLOSION";
            colorText[] = {1,1,1,1};
        };

        class Author: MKK_PTG_RscText {
            idc = 89002;
            x = 0.76;
            y = 0.052;
            w = 0.18;
            h = 0.04;
            text = "$STR_MKK_PTG_AUTHOR";
            colorText[] = {0.65,0.78,0.86,1};
        };

        class AmmoLabel: MKK_PTG_RscText {
            idc = -1;
            x = 0.055;
            y = 0.108;
            w = 0.25;
            h = 0.03;
            text = "$STR_MKK_PTG_TEST_AMMO";
        };

        class MapLabel: MKK_PTG_RscText {
            idc = -1;
            x = 0.325;
            y = 0.108;
            w = 0.45;
            h = 0.03;
            text = "$STR_MKK_PTG_EXPLOSION_MAP";
        };
    };

    class controls {
        class AmmoSearch: MKK_PTG_RscEdit {
            idc = 89010;
            x = 0.055;
            y = 0.145;
            w = 0.25;
            h = 0.04;
            text = "";
            onKeyUp = QUOTE([] call FUNC(refreshExplosionAmmoList));
        };

        class AmmoCategory: MKK_PTG_RscCombo {
            idc = 89011;
            x = 0.055;
            y = 0.195;
            w = 0.25;
            h = 0.04;
            onLBSelChanged = QUOTE([] call FUNC(refreshExplosionAmmoList));
        };

        class AmmoList: MKK_PTG_RscListbox {
            idc = 89020;
            x = 0.055;
            y = 0.245;
            w = 0.25;
            h = 0.34;
            onLBSelChanged = QUOTE(_this call FUNC(onExplosionAmmoSelected));
        };

        class AmmoInfo: MKK_PTG_RscStructuredText {
            idc = 89030;
            x = 0.055;
            y = 0.595;
            w = 0.25;
            h = 0.18;
            text = "$STR_MKK_PTG_EXPLOSION_AMMO_EMPTY";
        };

        class HeightLabel: MKK_PTG_RscText {
            idc = -1;
            x = 0.055;
            y = 0.790;
            w = 0.12;
            h = 0.035;
            text = "$STR_MKK_PTG_EXPLOSION_HEIGHT";
        };

        class HeightEdit: MKK_PTG_RscEdit {
            idc = 89031;
            x = 0.185;
            y = 0.790;
            w = 0.12;
            h = 0.04;
            text = "1000";
        };

        class Map: RscMapControl {
            idc = 89040;
            x = 0.325;
            y = 0.145;
            w = 0.62;
            h = 0.685;
            onMouseButtonClick = QUOTE(_this call FUNC(onExplosionMapClick));
        };

        class Note: MKK_PTG_RscStructuredText {
            idc = 89032;
            x = 0.325;
            y = 0.842;
            w = 0.44;
            h = 0.045;
            text = "$STR_MKK_PTG_EXPLOSION_NOTE";
        };

        class CloseBtn: MKK_PTG_RscButtonDanger {
            idc = 89050;
            x = 0.785;
            y = 0.842;
            w = 0.16;
            h = 0.04;
            text = "$STR_MKK_PTG_CLOSE";
            action = "closeDialog 0";
        };
    };
};
