#include "..\script_component.hpp"
/*
    Removes the local timing HUD layer.
*/
if !(hasInterface) exitWith {};

private _layer = "mkk_ptg_mapTimingHudLayer" call BIS_fnc_rscLayer;
_layer cutText ["", "PLAIN"];
uiNamespace setVariable ["mkk_ptg_mapTimingHud", displayNull];
