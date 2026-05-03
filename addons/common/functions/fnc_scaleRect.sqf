#include "..\script_component.hpp"
/*
    Преобразует старые UI-координаты 0..1 в текущие safeZone-координаты.

    Важно: все controls преобразуются через общий масштабированный layout rect,
    а не масштабируются независимо вокруг собственных центров. Это удерживает
    combo boxes/buttons внутри основного фона и не дает controls уйти за пределы
    окна при увеличении размера интерфейса.
*/
params ["_rect", ["_scale", -1], ["_clamp", true], ["_baseLayout", [0.05, 0.05, 0.90, 0.85]]];
_rect params ["_x", "_y", "_w", "_h"];
_baseLayout params ["_baseX", "_baseY", "_baseW", "_baseH"];

if (_scale < 0) then {
    _scale = ([] call FUNC(getHudScale)) # 0;
};

private _margin = 0.006;
private _layoutW = (_baseW * _scale) min (1 - (_margin * 2));
private _layoutH = (_baseH * _scale) min (1 - (_margin * 2));
private _layoutCenterX = _baseX + (_baseW / 2);
private _layoutCenterY = _baseY + (_baseH / 2);
private _layoutX = (_layoutCenterX - (_layoutW / 2)) max _margin min (1 - _margin - _layoutW);
private _layoutY = (_layoutCenterY - (_layoutH / 2)) max _margin min (1 - _margin - _layoutH);

private _nx = if (_baseW > 0) then {(_x - _baseX) / _baseW} else {_x};
private _ny = if (_baseH > 0) then {(_y - _baseY) / _baseH} else {_y};
private _nw = if (_baseW > 0) then {_w / _baseW} else {_w};
private _nh = if (_baseH > 0) then {_h / _baseH} else {_h};

private _sx = _layoutX + (_nx * _layoutW);
private _sy = _layoutY + (_ny * _layoutH);
private _sw = _nw * _layoutW;
private _sh = _nh * _layoutH;

if (_clamp) then {
    if (_sx < _margin) then {_sx = _margin;};
    if (_sy < _margin) then {_sy = _margin;};
    if ((_sx + _sw) > (1 - _margin)) then {_sw = (1 - _margin - _sx) max 0.001;};
    if ((_sy + _sh) > (1 - _margin)) then {_sh = (1 - _margin - _sy) max 0.001;};
};

[
    safeZoneX + (_sx * safeZoneW),
    safeZoneY + (_sy * safeZoneH),
    _sw * safeZoneW,
    _sh * safeZoneH
]
