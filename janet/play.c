#include <emscripten.h>
#include "janet.h"

EMSCRIPTEN_KEEPALIVE
int run_janet(char *source) {
    // Initialize the virtual machine. Do this before any calls to Janet functions.
    janet_init();

    // Get the core janet environment. This contains all of the C functions in the core
    // as well as the code in src/boot/boot.janet.
    JanetTable *env = janet_core_env(NULL);

    // One of several ways to begin the Janet vm.
    int ret = janet_dostring(env, source, "playground", NULL);

    // Use this to free all resources allocated by Janet.
    janet_deinit();
    return ret;
}
