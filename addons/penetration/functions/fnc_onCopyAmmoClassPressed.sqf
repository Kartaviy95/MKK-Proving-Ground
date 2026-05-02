#include "..\script_component.hpp"
/*
    Копирует classname выбранного боеприпаса теста пробития в буфер обмена.
*/
private _ammoClass = missionNamespace getVariable ["mkk_ptg_penetrationAmmoClass", ""];
if (_ammoClass isEqualTo "") exitWith {
    [localize "STR_MKK_PTG_SELECT_AMMO_FIRST"] call EFUNC(main,showTimedHint);
};

copyToClipboard _ammoClass;
[format [localize "STR_MKK_PTG_AMMO_CLASS_COPIED", _ammoClass]] call EFUNC(main,showTimedHint);
