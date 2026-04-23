/*
    Нормализует тип техники по classname.
*/
params [
    ["_className", ""]
];

if (_className isEqualTo "") exitWith {"Other"};

if (_className isKindOf "Tank") exitWith {"Tank"};
if (_className isKindOf "Wheeled_APC_F") exitWith {"APC"};
if (_className isKindOf "Tracked_APC_F") exitWith {"IFV"};
if (_className isKindOf "Car") exitWith {"Car"};
if (_className isKindOf "Truck_F") exitWith {"Truck"};
if (_className isKindOf "StaticWeapon") exitWith {"Static"};
if (_className isKindOf "Helicopter") exitWith {"Helicopter"};
if (_className isKindOf "Plane") exitWith {"Plane"};
if (_className isKindOf "Ship_F") exitWith {"Boat"};
if (_className isKindOf "UAV_01_base_F" || {_className isKindOf "UAV_06_base_F"} || {_className isKindOf "UAV"}) exitWith {"UAV"};

"Other"
