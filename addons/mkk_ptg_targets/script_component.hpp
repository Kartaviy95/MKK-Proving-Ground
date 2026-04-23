#define COMPONENT targets
#define COMPONENT_BEAUTIFIED Targets
#define PREFIX mkk_ptg

#define QUOTE(var1) #var1
#define DOUBLES(var1,var2) var1##_##var2
#define TRIPLES(var1,var2,var3) var1##_##var2##_##var3

#define FUNC(var1) TRIPLES(mkk,ptg,fnc_##var1)
#define GVAR(var1) TRIPLES(mkk,ptg,var1)
