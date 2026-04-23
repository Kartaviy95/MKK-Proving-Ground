/*
    Возвращает нацию по фракции.
*/
params [
    ["_factionClass", ""]
];

private _nationMap = missionNamespace getVariable ["mkk_ptg_nationMap", createHashMap];
if (_nationMap isEqualType createHashMap) then {
    if (_nationMap getOrDefault [_factionClass, ""] != "") exitWith {_nationMap get _factionClass};
};

"Unknown"
