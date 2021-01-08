(function() {
  var printRaw = (function () {
    var element = $("#output")[0];
    //if (element) element.textContent = '';
    return function (text) {
      if (element) {
        element.innerHTML += text;
        element.scrollTop = element.scrollHeight; // focus on bottom
      }
    }
  })();

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

  function run_code() {
        $('#output').first().text("");
        let codeEl = $('#code').first();
        let code = cleanContentEditableInput(codeEl.val());
        //console.log("RUNNING: " + code);
        var run_janet = Module.cwrap("run_janet", 'number', ['string']);
        let result = run_janet(code);
        print("RESULT: " + result + "\n");
  }

  var Module = {
    preRun: [],
    print: function(x) {
      print(x + '\n');
    },
    printErr: function(text) {
      if (arguments.length > 1) text = Array.prototype.slice.call(arguments).join(' ');
    printRaw('<span style="color:#E55;">' + htmlEscape(text + '\n') + '</span>')
    },
    postRun: [function() {
        window.run_code = run_code;
    }],
  };

  window.Module = Module;
})();
