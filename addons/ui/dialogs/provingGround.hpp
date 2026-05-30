class MKK_PTG_MainDisplay {
    idd = 88000;
    movingEnable = 1;
    enableSimulation = 1;
    onLoad = QUOTE(_this call FUNC(initDisplay));
    onUnload = QUOTE([] call FUNC(onMainDisplayUnload));

    class controlsBackground {};
    class controls {
        class WebInterface: MKK_PTG_RscWebBrowser {
            idc = 88090;
            x = 0.05;
            y = 0.05;
            w = 0.90;
            h = 0.85;
        };
    };
};

class MKK_PTG_SettingsDisplay {
    idd = 88800;
    movingEnable = 1;
    enableSimulation = 1;
    onLoad = QUOTE(_this call FUNC(initSettingsDisplay));
    onUnload = "uiNamespace setVariable ['mkk_ptg_settingsDisplay', displayNull]; uiNamespace setVariable ['mkk_ptg_objectStatusSettingsControls', []]; uiNamespace setVariable ['mkk_ptg_mapProjectileMarkerSettingsControls', []]; uiNamespace setVariable ['mkk_ptg_trajectorySettingsControls', []]; uiNamespace setVariable ['mkk_ptg_hitpointInspectorSettingsControls', []];";

    class controlsBackground {};
    class controls {};
};
