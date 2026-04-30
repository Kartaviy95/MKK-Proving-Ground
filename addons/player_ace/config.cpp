#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(COMPONENT);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {QUOTE(DOUBLES(PREFIX,player)), "ace_medical_damage"};
        skipWhenMissingDependencies = 1;
        VERSION_CONFIG;
    };
};

class ACE_Medical_Injuries {
    class damageTypes {
        class woundHandlers {
            GVAR(blockGodMode) = QEFUNC(player,blockAceMedicalDamage);
        };

        class bullet {
            class woundHandlers {
                GVAR(blockGodMode) = QEFUNC(player,blockAceMedicalDamage);
            };
        };

        class vehiclehit {
            class woundHandlers {
                GVAR(blockGodMode) = QEFUNC(player,blockAceMedicalDamage);
            };
        };

        class vehiclecrash {
            class woundHandlers {
                GVAR(blockGodMode) = QEFUNC(player,blockAceMedicalDamage);
            };
        };

        class drowning {
            class woundHandlers {
                GVAR(blockGodMode) = QEFUNC(player,blockAceMedicalDamage);
            };
        };

        class fire {
            class woundHandlers {
                GVAR(blockGodMode) = QEFUNC(player,blockAceMedicalDamage);
            };
        };
    };
};
