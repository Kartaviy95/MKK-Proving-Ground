#include "..\script_component.hpp"
/*
    Нормализует тип техники по classname.
*/
params [
    ["_className", ""]
];

if (_className isEqualTo "") exitWith {"$STR_MKK_PTG_TYPE_OTHER"};

if (_className isKindOf "Tank") exitWith {"$STR_MKK_PTG_TYPE_TANK"};
if (_className isKindOf "Wheeled_APC_F") exitWith {"$STR_MKK_PTG_TYPE_APC"};
if (_className isKindOf "Tracked_APC_F") exitWith {"$STR_MKK_PTG_TYPE_IFV"};
if (_className isKindOf "Car") exitWith {"$STR_MKK_PTG_TYPE_CAR"};
if (_className isKindOf "Truck_F") exitWith {"$STR_MKK_PTG_TYPE_TRUCK"};
if (_className isKindOf "StaticWeapon") exitWith {"$STR_MKK_PTG_TYPE_STATIC"};
if (_className isKindOf "Helicopter") exitWith {"$STR_MKK_PTG_TYPE_HELICOPTER"};
if (_className isKindOf "Plane") exitWith {"$STR_MKK_PTG_TYPE_PLANE"};
if (_className isKindOf "Ship_F") exitWith {"$STR_MKK_PTG_TYPE_BOAT"};
if (_className isKindOf "UAV_01_base_F" || {_className isKindOf "UAV_06_base_F"} || {_className isKindOf "UAV"}) exitWith {"$STR_MKK_PTG_TYPE_UAV"};

"$STR_MKK_PTG_TYPE_OTHER"
