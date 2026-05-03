#include "..\script_component.hpp"
/*
    Запоминает выбранную цель и обновляет карточку.
*/
params ["_control", "_selectedIndex"];

private _className = "";
if (_selectedIndex >= 0) then {
    _className = _control lbData _selectedIndex;
};
missionNamespace setVariable ["mkk_ptg_targetSelection", _className];
[] call FUNC(updateTargetPreview);
