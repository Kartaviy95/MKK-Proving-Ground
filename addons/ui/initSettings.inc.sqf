private _mapSmokeColor = profileNamespace getVariable ["mkk_ptg_mapSmokeColor", "ColorYellow"];
if !(_mapSmokeColor in ["ColorWhite", "ColorRed", "ColorGreen", "ColorYellow", "ColorBlue", "ColorOrange", "ColorPink"]) then {
    _mapSmokeColor = "ColorYellow";
};

if (isNil {missionNamespace getVariable "mkk_ptg_mapSmokeColor"}) then {
    missionNamespace setVariable ["mkk_ptg_mapSmokeColor", _mapSmokeColor];
};
