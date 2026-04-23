#include "..\script_component.hpp"
/*
    Запрашивает очистку полигона на сервере.
*/
[] remoteExecCall [QEFUNC(spawn,cleanupRange), 2];
