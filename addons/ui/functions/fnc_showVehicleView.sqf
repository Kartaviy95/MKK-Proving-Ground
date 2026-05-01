#include "..\script_component.hpp"
/*
    Показывает каталог и панель спавна техники.
*/
private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

{
    (_display displayCtrl _x) ctrlShow false;
} forEach [88100, 88101, 88102, 88105, 88106, 88107, 88108, 88109, 88110, 88111, 88112, 88113, 88114, 88115];

{
    (_display displayCtrl _x) ctrlShow true;
} forEach [
    88002, 88010, 88011, 88012, 88014, 88015, 88016, 88017, 88020, 88030, 88031,
    88040, 88041, 88044, 88045, 88046,
    88050, 88051, 88052, 88054, 88055, 88056, 88057
];

(_display displayCtrl 88003) ctrlSetText localize "STR_MKK_PTG_VEHICLE_SPAWN";

[] call FUNC(refreshStaticAmmoBoxes);
