private _mapSmokeColor = profileNamespace getVariable ["mkk_ptg_mapSmokeColor", "ColorYellow"];
if !(_mapSmokeColor in ["ColorWhite", "ColorRed", "ColorGreen", "ColorYellow", "ColorBlue", "ColorOrange", "ColorPink"]) then {
    _mapSmokeColor = "ColorYellow";
};

if (isNil {missionNamespace getVariable "mkk_ptg_mapSmokeColor"}) then {
    missionNamespace setVariable ["mkk_ptg_mapSmokeColor", _mapSmokeColor];
};

private _mapHeightMarkerColor = profileNamespace getVariable ["mkk_ptg_mapHeightMarkerColor", "ColorBlack"];
if !(_mapHeightMarkerColor in ["ColorBlue", "ColorGreen", "ColorYellow", "ColorOrange", "ColorPink", "ColorRed", "ColorBrown", "ColorKhaki", "ColorBlack", "ColorGrey", "ColorWhite"]) then {
    _mapHeightMarkerColor = "ColorBlack";
};

if (isNil {missionNamespace getVariable "mkk_ptg_mapHeightMarkerColor"}) then {
    missionNamespace setVariable ["mkk_ptg_mapHeightMarkerColor", _mapHeightMarkerColor];
};
