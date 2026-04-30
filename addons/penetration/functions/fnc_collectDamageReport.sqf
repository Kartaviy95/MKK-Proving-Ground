#include "..\script_component.hpp"
/*
    Собирает отчет о повреждениях цели и экипажа.
*/
params [
    ["_target", objNull],
    ["_ammoClass", ""]
];

if (isNull _target) exitWith {};

private _vehicleClass = typeOf _target;
private _hitpoints = getAllHitPointsDamage _target;
private _names = _hitpoints param [0, []];
private _values = _hitpoints param [2, []];
private _hitText = "";

{
    private _damage = _values param [_forEachIndex, 0];
    if (_damage > 0.001) then {
        private _color = "#73d13d";
        if (_damage >= 0.35) then {_color = "#ffd666";};
        if (_damage >= 0.70) then {_color = "#ff4d4f";};

        private _filled = round ((_damage min 1) * 10);
        private _bar = "";
        for "_i" from 1 to 10 do {
            _bar = _bar + ([".", "|"] select (_i <= _filled));
        };

        _hitText = _hitText + format [
            "<t color='%1'>%2</t> %3 <t color='%1'>%4</t><br/>",
            _color,
            _x,
            _bar,
            [_damage, 3] call BIS_fnc_cutDecimals
        ];
    };
} forEach _names;

if (_hitText isEqualTo "") then {
    _hitText = localize "STR_MKK_PTG_NO_HITPOINT_DAMAGE";
};

private _crewText = "";
{
    private _state = [localize "STR_MKK_PTG_ALIVE", localize "STR_MKK_PTG_DEAD"] select !(alive _x);
    _crewText = _crewText + format ["%1: %2, %3 %4<br/>", name _x, _state, localize "STR_MKK_PTG_DAMAGE", [damage _x, 3] call BIS_fnc_cutDecimals];
} forEach crew _target;

if (_crewText isEqualTo "") then {
    _crewText = localize "STR_MKK_PTG_NO_CREW";
};

private _report = format [
    "<t size='1.1'>%1</t><br/><br/>%2: %3<br/>%4: %5<br/>%6: %7<br/><br/>%8:<br/>%9<br/><br/>%10:<br/>%11",
    localize "STR_MKK_PTG_DAMAGE_REPORT",
    localize "STR_MKK_PTG_CLASS",
    _vehicleClass,
    localize "STR_MKK_PTG_TEST_AMMO",
    _ammoClass,
    localize "STR_MKK_PTG_DAMAGE",
    [damage _target, 3] call BIS_fnc_cutDecimals,
    localize "STR_MKK_PTG_HITPOINTS",
    _hitText,
    localize "STR_MKK_PTG_CREW",
    _crewText
];

missionNamespace setVariable ["mkk_ptg_penetrationReport", _report];
[] call FUNC(updateReport);
