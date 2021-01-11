#include <emscripten.h>
#include "janet.h"

EMSCRIPTEN_KEEPALIVE
int run_janet(char *source) {
    // Initialize the virtual machine.
    janet_init();

    // Get the core janet environment. 
    JanetTable *env = janet_core_env(NULL);

    // Run the code in the source argument, and pretty-print the result
    Janet result;
    int ret = janet_dostring(env, source, "playground", &result);
    janet_printf("%j\n", result);

    // Free all resources associated with Janet
    janet_deinit();

    return ret;
}
