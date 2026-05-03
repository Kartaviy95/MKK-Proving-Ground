#include "..\script_component.hpp"
/*
    Возвращает значения масштаба UI/HUD с учетом формата монитора игрока и
    выбранного игроком размера интерфейса.

    mkk_ptg_hudSize хранится в profileNamespace через combo главного окна и
    дублируется в missionNamespace, чтобы scripts могли быстро читать значение.
*/
private _hudSize = missionNamespace getVariable ["mkk_ptg_hudSize", profileNamespace getVariable ["mkk_ptg_hudSize", 1]];
if !(_hudSize isEqualType 0) then {
    _hudSize = 1;
};
_hudSize = (_hudSize max 0.80) min 1.30;
missionNamespace setVariable ["mkk_ptg_hudSize", _hudSize];

private _aspect = if (safeZoneH > 0) then {safeZoneW / safeZoneH} else {16 / 9};

/*
    16:9 — нейтральный формат. На 4:3/5:4 все окно немного уменьшается, чтобы
    вертикальный стек помещался. На ultrawide добавляется только небольшой бонус,
    потому что safeZoneW уже дает больше места.
*/
private _aspectScale = if (_aspect < (16 / 9)) then {
    linearConversion [4 / 3, 16 / 9, _aspect, 0.92, 1.00, true]
} else {
    linearConversion [16 / 9, 21 / 9, _aspect, 1.00, 1.05, true]
};

private _scale = (_hudSize * _aspectScale) max 0.75 min 1.30;
/*
    Масштабирование шрифта намеренно сильнее масштабирования окна. HUD layers и
    camera overlays используют StructuredText, где небольшое числовое изменение
    прямоугольника control трудно заметить, поэтому выбранный игроком размер
    интерфейса должен давать заметно больший multiplier sizeEx / <t size=...>.
*/
private _fontScale = (linearConversion [0.85, 1.30, _hudSize, 0.90, 1.60, true] * _aspectScale) max 0.90 min 1.70;

[_scale, _fontScale, _aspect, _hudSize]
