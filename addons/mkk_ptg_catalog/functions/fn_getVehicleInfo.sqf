/*
    Возвращает структурированную запись по classname.
*/
params [
    ["_className", ""]
];

private _catalog = missionNamespace getVariable ["mkk_ptg_catalogCache", []];
private _index = _catalog findIf {(_x # 0) isEqualTo _className};

if (_index < 0) exitWith {[]};
_catalog # _index
