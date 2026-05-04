#include "..\script_component.hpp"
/*
    Клиентский запрос глобального спавна.
    Важно: не remoteExec на сервер, потому что аддон может быть не загружен на dedicated server.
*/
params [
    ["_className", ""],
    ["_requestor", objNull],
    ["_withCrew", false],
    ["_distance", missionNamespace getVariable ["mkk_ptg_spawnDefaultDistance", 30]],
    ["_directionOffset", 0],
    ["_ammoBoxClass", ""]
];

if (_className isEqualTo "") exitWith {};
if (isNull _requestor) exitWith {};
if !([_requestor] call EFUNC(main,isAuthorized)) exitWith {
    [localize "STR_MKK_PTG_NO_ACCESS"] call EFUNC(main,showTimedHint);
};

private _maxDistance = missionNamespace getVariable ["mkk_ptg_spawnMaxDistance", 250];
_distance = (_distance max 1) min _maxDistance;
_directionOffset = _directionOffset % 360;

if (_ammoBoxClass isNotEqualTo "" && {
    !(_className isKindOf "StaticWeapon")
    || {!isClass (configFile >> "CfgVehicles" >> _ammoBoxClass)}
    || {!(_ammoBoxClass isKindOf "ReammoBox_F" || {_ammoBoxClass isKindOf "ReammoBox"})}
}) then {
    _ammoBoxClass = "";
};

[
    _className,
    _requestor,
    _withCrew,
    _distance,
    _directionOffset,
    _ammoBoxClass
] call FUNC(serverSpawnVehicle);
