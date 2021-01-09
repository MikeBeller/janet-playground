(function() {
    function printRaw(text) {
        var element = window.Module.outputElement;
        if (element) {
            element.innerHTML += text;
            element.scrollTop = element.scrollHeight; // focus on bottom
        } else {
            console.log("No output element.  Tried to print: " + text);
        }
    }

    function htmlEscape(text) {
        //text = ansi_up.ansi_to_html(text);
        text = text.replace('\n', '<br>', 'g');
        return text;
    }

    function cleanContentEditableInput(text) {
        text = text.replace(/\u00A0/g, " ");
        return text;
    }

    function print(text) {
        if (arguments.length > 1) text = Array.prototype.slice.call(arguments).join(' ');
        printRaw(htmlEscape(text));
    }

    function run_janet_code(codeElement, outputElement) {
        outputElement.innerHTML = "";
        window.Module.outputElement = outputElement;
        let code = cleanContentEditableInput(codeElement.value);
        let result = window.run_janet(code);
        print("RESULT: " + result + "\n");
    }

    var Module = {
        outputElement: null,
        preRun: [],
        print: function(x) {
            print(x + '\n');
        },
        printErr: function(text) {
            if (arguments.length > 1) text = Array.prototype.slice.call(arguments).join(' ');
            printRaw('<span style="color:#E55;">' + htmlEscape(text + '\n') + '</span>')
        },
        postRun: [function() {
            window.run_janet_code = run_janet_code;
            window.run_janet = Module.cwrap("run_janet", 'number', ['string']);
        }],
    };

    window.Module = Module;
})();
