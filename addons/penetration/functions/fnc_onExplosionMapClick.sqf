#include "..\script_component.hpp"
/*
    Fires selected ammo at the clicked map position.
*/
params ["_ctrlMap", "_button", "_xPos", "_yPos"];

if (_button != 0) exitWith {false};

private _display = ctrlParent _ctrlMap;
private _ammoClass = missionNamespace getVariable ["mkk_ptg_explosionAmmoClass", ""];
if (_ammoClass isEqualTo "") exitWith {
    [localize "STR_MKK_PTG_SELECT_AMMO_FIRST"] call EFUNC(main,showTimedHint);
    true
};

private _height = parseNumber ctrlText (_display displayCtrl 89031);
if (_height <= 0) exitWith {
    [localize "STR_MKK_PTG_EXPLOSION_BAD_HEIGHT"] call EFUNC(main,showTimedHint);
    true
};

private _cfg = configFile >> "CfgAmmo" >> _ammoClass;
private _triggerDistance = [_cfg, "triggerDistance", 0] call EFUNC(common,getSafeConfigNumber);
private _submunitionAmmo = [_cfg, "submunitionAmmo", ""] call EFUNC(common,getSafeConfigText);
if (_submunitionAmmo != "" && {_triggerDistance > 0} && {_height <= (_triggerDistance + 5)}) exitWith {
    [format [localize "STR_MKK_PTG_EXPLOSION_HEIGHT_TOO_LOW", _triggerDistance]] call EFUNC(main,showTimedHint);
    true
};

private _pos2D = _ctrlMap ctrlMapScreenToWorld [_xPos, _yPos];
private _shotResult = [_ammoClass, _pos2D, _height, player] call FUNC(createExplosionAtMapClick);
private _projectile = if (_shotResult isEqualType [] && {count _shotResult > 0}) then {_shotResult # 0} else {objNull};
private _willOpenTrackingCamera = _shotResult isEqualType [] && {count _shotResult > 1} && {_shotResult # 1};

[format [localize "STR_MKK_PTG_EXPLOSION_CREATED", _ammoClass, round _height]] call EFUNC(main,showTimedHint);

if (!isNull _projectile && {_willOpenTrackingCamera}) then {
    missionNamespace setVariable ["mkk_ptg_explosionRestoreAmmo", _ammoClass];
    missionNamespace setVariable ["mkk_ptg_explosionRestoreHeight", ctrlText (_display displayCtrl 89031)];
    missionNamespace setVariable ["mkk_ptg_explosionRestoreSearch", ctrlText (_display displayCtrl 89010)];
    private _ctrlCategory = _display displayCtrl 89011;
    private _categoryIdx = lbCurSel _ctrlCategory;
    missionNamespace setVariable ["mkk_ptg_explosionRestoreCategory", if (_categoryIdx >= 0) then {_ctrlCategory lbData _categoryIdx} else {""}];
    missionNamespace setVariable ["mkk_ptg_explosionReopenAfterTracking", true];

    _display closeDisplay 2;

    [] spawn {
        private _isTrackingActive = {
            private _state = missionNamespace getVariable ["mkk_ptg_trackingState", createHashMap];
            _state isEqualType createHashMap && {count _state > 0}
        };

        private _startTimeout = diag_tickTime + 2;
        waitUntil {
            uiSleep 0.05;
            [] call _isTrackingActive || {diag_tickTime > _startTimeout}
        };

        waitUntil {
            uiSleep 0.1;
            !([] call _isTrackingActive)
        };

        if (missionNamespace getVariable ["mkk_ptg_explosionReopenAfterTracking", false]) then {
            missionNamespace setVariable ["mkk_ptg_explosionReopenAfterTracking", false];
            if (hasInterface && {isNull (findDisplay 89000)} && {isNull (findDisplay 88000)} && {isNull (findDisplay 88900)}) then {
                createDialog "MKK_PTG_ExplosionDisplay";
            };
        };
    };
};
true
