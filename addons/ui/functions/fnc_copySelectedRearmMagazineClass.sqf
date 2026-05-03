#include "..\script_component.hpp"
/*
    Копирует только classname магазина, выбранного пользователем в меню перевооружения.
*/
private _magazine = uiNamespace getVariable ["mkk_ptg_rearmSelectedMagazine", ""];
if (_magazine isEqualTo "") exitWith {
    [localize "STR_MKK_PTG_REARM_SELECT_MAGAZINE"] call EFUNC(main,showTimedHint);
};

copyToClipboard _magazine;
[format [localize "STR_MKK_PTG_MAGAZINE_CLASS_COPIED", _magazine]] call EFUNC(main,showTimedHint);
