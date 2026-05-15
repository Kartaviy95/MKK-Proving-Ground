#include "..\script_component.hpp"
/*
    Сажает игрока в слот стрелка и дает WASD-управление движением техники.
*/
if !(hasInterface) exitWith {};

params [
    ["_vehicle", objNull]
];

[] call FUNC(stopCrewDriverControl);

if (isNull _vehicle) exitWith {};

private _driver = driver _vehicle;
if (isNull _driver) exitWith {
    [localize "STR_MKK_PTG_CREW_CONTROL_NO_DRIVER"] call EFUNC(main,showTimedHint);
};

private _gunnerPath = [];
{
    _x params ["_unit", "_role", "_cargoIndex", "_turretPath"];
    private _roleLower = toLower _role;
    if (isNull _unit && {_turretPath isNotEqualTo []} && {_roleLower in ["gunner", "turret"]}) exitWith {
        _gunnerPath = _turretPath;
    };
} forEach fullCrew [_vehicle, "", true];

if (_gunnerPath isEqualTo []) then {
    {
        _x params ["_unit", "_role", "_cargoIndex", "_turretPath"];
        if (isNull _unit && {_turretPath isNotEqualTo []}) exitWith {
            _gunnerPath = _turretPath;
        };
    } forEach fullCrew [_vehicle, "", true];
};

if (_gunnerPath isEqualTo []) exitWith {
    [localize "STR_MKK_PTG_CREW_CONTROL_NO_GUNNER"] call EFUNC(main,showTimedHint);
};

unassignVehicle player;
player assignAsTurret [_vehicle, _gunnerPath];
player moveInTurret [_vehicle, _gunnerPath];

if (vehicle player isNotEqualTo _vehicle) exitWith {
    [localize "STR_MKK_PTG_CREW_CONTROL_NO_GUNNER"] call EFUNC(main,showTimedHint);
};

closeDialog 0;

missionNamespace setVariable ["mkk_ptg_crewDriverControlState", createHashMapFromArray [
    ["vehicle", _vehicle],
    ["driver", _driver],
    ["gunnerPath", _gunnerPath]
]];
missionNamespace setVariable ["mkk_ptg_crewDriverControlRunning", true];
_vehicle allowCrewInImmobile true;
_vehicle setUnloadInCombat [true, false];
_vehicle setFuel 1;
_vehicle engineOn true;
_driver enableAI "PATH";
_driver setBehaviour "COMBAT";
_driver setSpeedMode "FULL";

[] spawn {
    waitUntil {
        uiSleep 0.02;
        !(missionNamespace getVariable ["mkk_ptg_crewDriverControlRunning", false]) || {!isNull (findDisplay 46)}
    };
    if !(missionNamespace getVariable ["mkk_ptg_crewDriverControlRunning", false]) exitWith {};

    private _display = findDisplay 46;
    private _keyDownEH = _display displayAddEventHandler ["KeyDown", {
        params ["_display", "_key"];
        if !(missionNamespace getVariable ["mkk_ptg_crewDriverControlRunning", false]) exitWith {false};

        private _controlKeys = [DIK_W, DIK_S, DIK_A, DIK_D, DIK_UP, DIK_DOWN, DIK_LEFT, DIK_RIGHT, DIK_LSHIFT, DIK_RSHIFT];
        if !(_key in _controlKeys) exitWith {false};

        private _actions = ["turnLeft", "turnRight", "moveBack", "moveForward", "moveFastForward"];
        if ({inputAction _x > 0} count _actions > 0) then {
            enableSentences false;
            [] spawn {
                uiSleep 1;
                enableSentences true;
            };
        };
        false
    }];
    missionNamespace setVariable ["mkk_ptg_crewDriverControlEHs", [_keyDownEH]];
};

[localize "STR_MKK_PTG_CREW_CONTROL_READY"] call EFUNC(main,showTimedHint);

[] spawn {
    while {missionNamespace getVariable ["mkk_ptg_crewDriverControlRunning", false]} do {
        private _state = missionNamespace getVariable ["mkk_ptg_crewDriverControlState", createHashMap];
        private _vehicle = _state getOrDefault ["vehicle", objNull];
        private _driver = _state getOrDefault ["driver", objNull];
        if (
            isNull _vehicle
            || {isNull _driver}
            || {driver _vehicle isNotEqualTo _driver}
            || {vehicle player isNotEqualTo _vehicle}
        ) exitWith {};

        _vehicle allowCrewInImmobile true;
        _vehicle setUnloadInCombat [true, false];
        _driver setSpeedMode "FULL";
        _driver enableAI "PATH";

        if (player isEqualTo driver _vehicle) then {
            {
                _vehicle lockTurret [_x, false];
            } forEach allTurrets _vehicle;
            if (cameraView isNotEqualTo "external") then {
                player switchCamera "GUNNER";
            };
        };

        uiSleep 0.05;
    };

    if (missionNamespace getVariable ["mkk_ptg_crewDriverControlRunning", false]) then {
        [] call FUNC(stopCrewDriverControl);
    };
};
