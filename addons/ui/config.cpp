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


class MKK_PTG_RscText {
    access = 0;
    type = 0;
    idc = -1;
    style = 0;
    linespacing = 1;
    colorBackground[] = {0,0,0,0};
    colorText[] = {1,1,1,1};
    text = "";
    shadow = 0;
    font = "RobotoCondensed";
    SizeEx = 0.032;
};

class MKK_PTG_RscStructuredText {
    type = 13;
    idc = -1;
    style = 0;
    text = "";
    size = 0.032;
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

class MKK_PTG_RscPicture {
    access = 0;
    type = 0;
    idc = -1;
    style = 48;
    colorBackground[] = {0,0,0,0};
    colorText[] = {1,1,1,1};
    font = "RobotoCondensed";
    sizeEx = 0;
    lineSpacing = 0;
    text = "";
    fixedWidth = 0;
    shadow = 0;
};

class MKK_PTG_RscEdit {
    access = 0;
    type = 2;
    style = 0x00 + 0x40;
    x = 0;
    y = 0;
    h = 0.04;
    w = 0.2;
    text = "";
    sizeEx = 0.03;
    font = "RobotoCondensed";
    shadow = 0;
    colorText[] = {1,1,1,1};
    colorSelection[] = {0.2,0.2,0.2,1};
    autocomplete = "";
    colorBackground[] = {0.1,0.1,0.1,0.9};
};

class MKK_PTG_RscButton {
    access = 0;
    type = 1;
    text = "";
    colorText[] = {1,1,1,1};
    colorDisabled[] = {0.5,0.5,0.5,1};
    colorBackground[] = {0.1,0.1,0.1,0.95};
    colorBackgroundDisabled[] = {0.2,0.2,0.2,0.8};
    colorBackgroundActive[] = {0.2,0.2,0.2,1};
    colorFocused[] = {0.2,0.2,0.2,1};
    colorShadow[] = {0,0,0,0};
    colorBorder[] = {0,0,0,1};
    soundEnter[] = {"",0.09,1};
    soundPush[] = {"",0.09,1};
    soundClick[] = {"",0.09,1};
    soundEscape[] = {"",0.09,1};
    style = 2;
    x = 0;
    y = 0;
    w = 0.095589;
    h = 0.039216;
    shadow = 0;
    font = "RobotoCondensed";
    sizeEx = 0.032;
    offsetX = 0;
    offsetY = 0;
    offsetPressedX = 0;
    offsetPressedY = 0;
    borderSize = 0;
};

class MKK_PTG_RscCombo {
    access = 0;
    type = 4;
    style = 0;
    colorSelect[] = {1,1,1,1};
    colorText[] = {1,1,1,1};
    colorBackground[] = {0.1,0.1,0.1,0.95};
    colorScrollbar[] = {1,0,0,1};
    colorDisabled[] = {0.5,0.5,0.5,1};
    colorPicture[] = {1,1,1,1};
    colorPictureSelected[] = {1,1,1,1};
    colorPictureDisabled[] = {0.5,0.5,0.5,1};
    colorPictureRight[] = {1,1,1,1};
    colorPictureRightSelected[] = {1,1,1,1};
    colorPictureRightDisabled[] = {0.5,0.5,0.5,1};
    colorTextRight[] = {1,1,1,1};
    colorSelectRight[] = {1,1,1,1};
    colorSelect2[] = {1,1,1,1};
    colorSelect2Right[] = {1,1,1,1};
    color[] = {1,1,1,1};
    colorActive[] = {1,0,0,1};
    maxHistoryDelay = 1;
    soundSelect[] = {"",0.1,1};
    soundExpand[] = {"",0.1,1};
    soundCollapse[] = {"",0.1,1};
    wholeHeight = 0.45;
    font = "RobotoCondensed";
    sizeEx = 0.032;
    shadow = 0;
    x = 0;
    y = 0;
    w = 0.12;
    h = 0.04;
    class ComboScrollBar {
        color[] = {1,1,1,1};
    };
};

class MKK_PTG_RscListbox {
    type = 5;
    style = 16;
    font = "RobotoCondensed";
    sizeEx = 0.032;
    rowHeight = 0.04;
    colorText[] = {1,1,1,1};
    colorBackground[] = {0.08,0.08,0.08,0.95};
    colorSelect[] = {1,1,1,1};
    colorSelect2[] = {1,1,1,1};
    colorSelectBackground[] = {0.2,0.2,0.2,1};
    colorSelectBackground2[] = {0.2,0.2,0.2,1};
    soundSelect[] = {"",0.1,1};
    period = 0;
    maxHistoryDelay = 1;
    autoScrollSpeed = -1;
    autoScrollDelay = 5;
    autoScrollRewind = 0;
    colorDisabled[] = {1,1,1,0.25};
};

#include "dialogs\\provingGround.hpp"
