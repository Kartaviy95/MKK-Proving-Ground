#include "..\script_component.hpp"
/*
    Returns UI/HUD scale values adjusted for the player's monitor format and
    the player-selected interface size.

    mkk_ptg_hudSize is stored in profileNamespace by the main window combo and
    mirrored to missionNamespace so scripts can read it quickly.
*/
private _hudSize = missionNamespace getVariable ["mkk_ptg_hudSize", profileNamespace getVariable ["mkk_ptg_hudSize", 1]];
if !(_hudSize isEqualType 0) then {
    _hudSize = 1;
};
_hudSize = (_hudSize max 0.80) min 1.30;
missionNamespace setVariable ["mkk_ptg_hudSize", _hudSize];

private _aspect = if (safeZoneH > 0) then {safeZoneW / safeZoneH} else {16 / 9};

/*
    16:9 is neutral. On 4:3/5:4 the whole window is slightly reduced so the
    vertical stack fits. On ultrawide we only add a small bonus because safeZoneW
    already gives more space.
*/
private _aspectScale = if (_aspect < (16 / 9)) then {
    linearConversion [4 / 3, 16 / 9, _aspect, 0.92, 1.00, true]
} else {
    linearConversion [16 / 9, 21 / 9, _aspect, 1.00, 1.05, true]
};

private _scale = (_hudSize * _aspectScale) max 0.75 min 1.30;
/*
    Font scaling is intentionally stronger than window scaling. HUD layers and
    camera overlays use StructuredText, where a small numeric change in the
    control rectangle is hard to notice, so the player-selected interface size
    must produce a visibly larger sizeEx / <t size=...> multiplier.
*/
private _fontScale = (linearConversion [0.85, 1.30, _hudSize, 0.90, 1.60, true] * _aspectScale) max 0.90 min 1.70;

[_scale, _fontScale, _aspect, _hudSize]
