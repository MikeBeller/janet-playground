

// emcc -s MODULARIZE=1 -o janet.js janet.c play.c -s "EXPORTED_FUNCTIONS=['_run_janet']" -s "EXTRA_EXPORTED_RUNTIME_METHODS=['ccall','cwrap']"
//  node noderepl.js
//

var factory = require('./janet.js'); 

factory().then(mod =>
    {
        var run_janet = mod.cwrap("run_janet", 'number', ['string']);
        run_janet('(print "hello")');
        //mod.asm.run_janet('3');
    }
);

