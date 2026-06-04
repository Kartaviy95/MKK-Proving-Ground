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

private _mapTimingColor = profileNamespace getVariable ["mkk_ptg_mapTimingColor", "ColorBlack"];
if !(_mapTimingColor in ["ColorBlue", "ColorGreen", "ColorYellow", "ColorOrange", "ColorPink", "ColorRed", "ColorBrown", "ColorKhaki", "ColorBlack", "ColorGrey", "ColorWhite"]) then {
    _mapTimingColor = "ColorBlack";
};

if (isNil {missionNamespace getVariable "mkk_ptg_mapTimingColor"}) then {
    missionNamespace setVariable ["mkk_ptg_mapTimingColor", _mapTimingColor];
};

private _mapTimingInterval = profileNamespace getVariable ["mkk_ptg_mapTimingInterval", 10];
if !(_mapTimingInterval isEqualType 0) then {
    _mapTimingInterval = 10;
};
_mapTimingInterval = round _mapTimingInterval;
if !(_mapTimingInterval in [5, 10, 15, 20, 30, 60]) then {
    _mapTimingInterval = 10;
};

if (isNil {missionNamespace getVariable "mkk_ptg_mapTimingInterval"}) then {
    missionNamespace setVariable ["mkk_ptg_mapTimingInterval", _mapTimingInterval];
};

private _mapTimingShowSpeed = profileNamespace getVariable ["mkk_ptg_mapTimingShowSpeed", false];
if !(_mapTimingShowSpeed isEqualType false) then {
    _mapTimingShowSpeed = false;
};

if (isNil {missionNamespace getVariable "mkk_ptg_mapTimingShowSpeed"}) then {
    missionNamespace setVariable ["mkk_ptg_mapTimingShowSpeed", _mapTimingShowSpeed];
};
