// Copy-and-pasted from jspsych.js (originally named JSON2CSV)
function ConvertToCSV(objArray) {
  var array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
  var line = '';
  var result = '';
  var columns = [];

  var i = 0;
  for (var j = 0; j < array.length; j++) {
    for (var key in array[j]) {
      var keyString = key + "";
      keyString = '"' + keyString.replace(/"/g, '""') + '",';
      if (!columns.includes(key)) {
        columns[i] = key;
        line += keyString;
        i++;
      }
    }
  }

  line = line.slice(0, -1);
  result += line + '\r\n';

  for (var i = 0; i < array.length; i++) {
    var line = '';
    for (var j = 0; j < columns.length; j++) {
      var value = (typeof array[i][columns[j]] === 'undefined') ? '' : array[i][columns[j]];
      var valueString = value + "";
      line += '"' + valueString.replace(/"/g, '""') + '",';
    }

    line = line.slice(0, -1);
    result += line + '\r\n';
  }

  return result;
  // this function is modified from StackOverflow:
  // http://stackoverflow.com/posts/3855394
}


// Save data locally as csv. Source: https://github.com/mholt/PapaParse/issues/175
function save_data(trial_data) {
  var blob = new Blob([ConvertToCSV(trial_data)]);
  if (window.navigator.msSaveOrOpenBlob) // IE hack; see http://msdn.microsoft.com/en-us/library/ie/hh779016.aspx
    window.navigator.msSaveBlob(blob, "your_data.csv");
  else {
    var a = window.document.createElement("a");
    a.href = window.URL.createObjectURL(blob, {
      type: "text/plain"
    });
    a.download = "your_data.csv";
    document.body.appendChild(a);
    a.click(); // IE: "Access is denied"; see: https://connect.microsoft.com/IE/feedback/details/797361/ie-10-treats-blob-url-as-cross-origin-and-denies-access
    document.body.removeChild(a);
  }
}