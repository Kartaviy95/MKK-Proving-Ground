#include "..\script_component.hpp"
/*
    Возвращает структурированную запись по classname.
*/
params [
    ["_className", ""]
];

private _entry = [];
private _catalogByClass = missionNamespace getVariable ["mkk_ptg_catalogByClass", createHashMap];
if (_catalogByClass isEqualType createHashMap) then {
    _entry = _catalogByClass getOrDefault [_className, []];
};
if (_entry isNotEqualTo []) exitWith {_entry};

private _catalog = missionNamespace getVariable ["mkk_ptg_catalogCache", []];
private _index = _catalog findIf {(_x # 0) isEqualTo _className};

if (_index < 0) exitWith {[]};
_catalog # _index
