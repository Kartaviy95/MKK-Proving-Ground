#include "..\script_component.hpp"
/*
    Refreshes the vehicle rearm overlay lists.
*/
disableSerialization;

private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

private _vehicle = objectParent player;
if (isNull _vehicle) exitWith {[] call FUNC(closeRearmOverlay)};

uiNamespace setVariable ["mkk_ptg_rearmVehicle", _vehicle];

private _vehicleCfg = configOf _vehicle;
private _vehicleName = [getText (_vehicleCfg >> "displayName")] call EFUNC(common,localizeString);
if (_vehicleName isEqualTo "") then {_vehicleName = typeOf _vehicle};

(_display displayCtrl 88201) ctrlSetText format ["%1: %2", localize "STR_MKK_PTG_REARM", _vehicleName];
(_display displayCtrl 88230) ctrlSetText ([_vehicleCfg] call EFUNC(common,getPreviewPath));
(_display displayCtrl 88231) ctrlSetStructuredText parseText format ["<t color='#B8E0FF'>%1</t><br/><t size='0.85'>%2</t>", _vehicleName, typeOf _vehicle];

private _slotCtrl = _display displayCtrl 88220;
lbClear _slotCtrl;
lbClear (_display displayCtrl 88221);
lbClear (_display displayCtrl 88222);
(_display displayCtrl 88232) ctrlSetStructuredText parseText localize "STR_MKK_PTG_REARM_MAGAZINE_INFO_EMPTY";
(_display displayCtrl 88233) ctrlSetStructuredText parseText "";
uiNamespace setVariable ["mkk_ptg_rearmSelectedTurret", []];
uiNamespace setVariable ["mkk_ptg_rearmSelectedWeapon", ""];
uiNamespace setVariable ["mkk_ptg_rearmSelectedMagazine", ""];
uiNamespace setVariable ["mkk_ptg_rearmCompatibleMagazines", []];

private _fncTurretConfig = {
    params ["_baseCfg", "_path"];
    private _cfg = _baseCfg;
    {
        private _turrets = _cfg >> "Turrets";
        if (_x < count _turrets) then {
            _cfg = _turrets select _x;
        } else {
            _cfg = configNull;
        };
    } forEach _path;
    _cfg
};

private _fncSlotName = {
    params ["_cfg", "_path"];

    private _name = "";
    if (!isNull _cfg) then {
        _name = [getText (_cfg >> "gunnerName")] call EFUNC(common,localizeString);
        if (_name isEqualTo "") then {
            _name = [getText (_cfg >> "displayName")] call EFUNC(common,localizeString);
        };
        if (_name isEqualTo "") then {
            _name = configName _cfg;
        };

        private _role = "";
        if ((getNumber (_cfg >> "primaryGunner")) > 0) then {_role = localize "STR_MKK_PTG_REARM_GUNNER"};
        if ((getNumber (_cfg >> "primaryObserver")) > 0) then {_role = localize "STR_MKK_PTG_REARM_COMMANDER"};
        if ((getNumber (_cfg >> "primaryCommander")) > 0) then {_role = localize "STR_MKK_PTG_REARM_COMMANDER"};
        if (_role != "" && {(_name find _role) < 0}) then {
            _name = format ["%1 - %2", _role, _name];
        };
    };

    if (_name isEqualTo "") then {
        _name = format ["%1 %2", localize "STR_MKK_PTG_REARM_TURRET", _path];
    };

    _name
};

private _turretRows = [];
{
    private _path = _x;
    private _weapons = (_vehicle weaponsTurret _path) select {_x != ""};
    if (_driverWeapons isNotEqualTo [])  then {
        private _cfg = [_vehicleCfg, _path] call _fncTurretConfig;
        private _name = [_cfg, _path] call _fncSlotName;
        _turretRows pushBack [_name, _path, _weapons];
    };
} forEach (allTurrets [_vehicle, true]);

private _driverWeapons = (_vehicle weaponsTurret [-1]) select {_x != ""};
if (_driverWeapons isNotEqualTo []) then {
    _turretRows = [[localize "STR_MKK_PTG_REARM_DRIVER", [-1], _driverWeapons]] + _turretRows;
};

uiNamespace setVariable ["mkk_ptg_rearmTurrets", _turretRows];

{
    _x params ["_name", "_path"];
    private _index = _slotCtrl lbAdd _name;
    _slotCtrl lbSetData [_index, str _path];
} forEach _turretRows;

if ((lbSize _slotCtrl) > 0) then {
    _slotCtrl lbSetCurSel 0;
} else {
    (_display displayCtrl 88231) ctrlSetStructuredText parseText format ["<t color='#FFB8B8'>%1</t>", localize "STR_MKK_PTG_REARM_NO_WEAPONS"];
};
