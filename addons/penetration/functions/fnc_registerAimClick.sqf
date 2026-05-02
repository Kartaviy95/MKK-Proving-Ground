#include "..\script_component.hpp"
/*
    Регистрирует выстрел по точке под курсором в orbit-камере.
*/
if !(hasInterface) exitWith {};
if (missionNamespace getVariable ["mkk_ptg_penetrationAimEHAdded", false]) exitWith {};

(findDisplay 46) displayAddEventHandler ["MouseButtonDown", {
    params ["_display", "_button"];
    if (_button != 0) exitWith {false};
    if !(missionNamespace getVariable ["mkk_ptg_penetrationCameraRunning", false]) exitWith {false};

    private _target = missionNamespace getVariable ["mkk_ptg_penetrationTarget", objNull];
    if (isNull _target) exitWith {false};

    private _ammoClass = missionNamespace getVariable ["mkk_ptg_penetrationAmmoClass", ""];
    if (_ammoClass isEqualTo "") exitWith {
        [localize "STR_MKK_PTG_SELECT_AMMO_FIRST"] call EFUNC(main,showTimedHint);
        true
    };

    private _mouse = getMousePosition;
    private _from = AGLToASL positionCameraToWorld [0, 0, 0];
    private _toWorld = screenToWorld _mouse;
    private _to = AGLToASL [_toWorld # 0, _toWorld # 1, 0];
    private _dir = vectorNormalized (_to vectorDiff _from);
    private _end = _from vectorAdd (_dir vectorMultiply 5000);
    private _hits = lineIntersectsSurfaces [_from, _end, player, objNull, true, 5, "GEOM", "FIRE"];

    private _impactPosASL = [];
    {
        if ((_x # 2) isEqualTo _target || {(_x # 3) isEqualTo _target}) exitWith {
            _impactPosASL = _x # 0;
        };
    } forEach _hits;

    if (_impactPosASL isEqualTo [] && {count _hits > 0}) then {
        _impactPosASL = (_hits # 0) # 0;
    };
    if (_impactPosASL isEqualTo []) then {
        _impactPosASL = getPosASL _target vectorAdd [0, 0, 1.2];
    };

    [_target, _ammoClass, player, _impactPosASL] remoteExecCall [QFUNC(serverFireTestShot), 2];

    [_target, _ammoClass] spawn {
        params ["_target", "_ammoClass"];
        uiSleep 1.5;
        [_target, _ammoClass] call FUNC(collectDamageReport);
    };

    true
}];

missionNamespace setVariable ["mkk_ptg_penetrationAimEHAdded", true];
