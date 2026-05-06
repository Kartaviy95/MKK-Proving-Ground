#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(COMPONENT);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            QUOTE(MAIN_ADDON),
            QUOTE(DOUBLES(PREFIX,ui)),
            QUOTE(DOUBLES(PREFIX,catalog)),
            QUOTE(DOUBLES(PREFIX,spawn)),
            QUOTE(DOUBLES(PREFIX,tracking))
        };
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"

class MKK_PTG_RscButton;
class MKK_PTG_RscButtonDanger;
class MKK_PTG_RscEdit;
class MKK_PTG_RscListbox;
class MKK_PTG_RscPicture;
class MKK_PTG_RscStructuredText;
class MKK_PTG_RscText;

#include "dialogs\penetrationTest.hpp"

class RscTitles {
    class MKK_PTG_PenetrationReportHUD {
        idd = -1;
        movingEnable = 0;
        duration = 100000;
        fadeIn = 0;
        fadeOut = 0;
        onLoad = "uiNamespace setVariable ['mkk_ptg_penetrationHud', _this # 0];";
        onUnload = "uiNamespace setVariable ['mkk_ptg_penetrationHud', displayNull];";

        class controls {
            class Report: MKK_PTG_RscStructuredText {
                idc = 88980;
                x = 0.68;
                y = 0.04;
                w = 0.30;
                h = 0.34;
                text = "$STR_MKK_PTG_DAMAGE_REPORT_EMPTY";
                colorText[] = {1,1,1,1};
            };

            class ExitHint: MKK_PTG_RscStructuredText {
                idc = 88981;
                x = 0.68;
                y = 0.39;
                w = 0.30;
                h = 0.06;
                text = "$STR_MKK_PTG_ORBIT_EXIT_HINT";
                colorText[] = {1,1,1,1};
            };
        };
    };
};
