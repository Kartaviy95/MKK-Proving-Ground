#include "..\script_component.hpp"
/*
    Копирует classname выбранной техники в буфер обмена.
*/
private _className = missionNamespace getVariable ["mkk_ptg_currentSelection", ""];
if (_className isEqualTo "") exitWith {
    hint localize "STR_MKK_PTG_SELECT_VEHICLE_FIRST";
};

copyToClipboard _className;
hint format [localize "STR_MKK_PTG_CLASS_COPIED", _className];
