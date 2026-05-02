#include "..\script_component.hpp"
/*
    Копирует classname выбранного боеприпаса теста пробития в буфер обмена.
*/
private _ammoClass = missionNamespace getVariable ["mkk_ptg_penetrationAmmoClass", ""];
if (_ammoClass isEqualTo "") exitWith {
    hint localize "STR_MKK_PTG_SELECT_AMMO_FIRST";
};

copyToClipboard _ammoClass;
hint format [localize "STR_MKK_PTG_AMMO_CLASS_COPIED", _ammoClass];
