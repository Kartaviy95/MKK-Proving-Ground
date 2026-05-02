#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(COMPONENT);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            QUOTE(MAIN_ADDON)};
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"

class MKK_PTG_TrackingRscText {
    access = 0;
    type = 0;
    idc = -1;
    style = 0;
    x = 0;
    y = 0;
    w = 0.1;
    h = 0.1;
    colorBackground[] = {0,0,0,0};
    colorText[] = {1,1,1,1};
    text = "";
    shadow = 0;
    font = "RobotoCondensed";
    sizeEx = 0.032;
};

class MKK_PTG_TrackingRscStructuredText {
    type = 13;
    idc = -1;
    style = 0;
    text = "";
    size = 0.030;
    x = 0;
    y = 0;
    w = 0.1;
    h = 0.1;
    colorText[] = {1,1,1,1};

    class Attributes {
        font = "RobotoCondensed";
        color = "#FFFFFF";
        align = "left";
        shadow = 0;
    };
};

class RscTitles {
    class MKK_PTG_TrackingHUD {
        idd = -1;
        movingEnable = 0;
        duration = 100000;
        fadeIn = 0;
        fadeOut = 0;
        onLoad = "uiNamespace setVariable ['mkk_ptg_trackingHud', _this # 0];";
        onUnload = "uiNamespace setVariable ['mkk_ptg_trackingHud', displayNull];";

        class controls {
            class Panel: MKK_PTG_TrackingRscText {
                idc = 88300;
                x = 0.035;
                y = 0.055;
                w = 0.36;
                h = 0.28;
                colorBackground[] = {0.02,0.035,0.045,0.82};
            };

            class AccentTop: MKK_PTG_TrackingRscText {
                idc = 88301;
                x = 0.035;
                y = 0.055;
                w = 0.36;
                h = 0.004;
                colorBackground[] = {0.10,0.72,0.92,0.95};
            };

            class Text: MKK_PTG_TrackingRscStructuredText {
                idc = 88302;
                x = 0.050;
                y = 0.070;
                w = 0.33;
                h = 0.25;
                text = "";
                colorText[] = {1,1,1,1};
            };
        };
    };
};
