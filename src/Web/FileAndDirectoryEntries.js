"use strict";

exports.getEntriesImpl = (left, right, dataTransfer) => {
  const len = dataTransfer.items.length;
  const ret = new Array();
  for (var i=0;i<len;++i) {
    const item = dataTransfer.items[i];
    const entry = item.webkitGetAsEntry();
    if (entry.isFile) {
      ret.push(left(entry));
    }
    else if (entry.isDirectory) {
      ret.push(right(entry));
    }
    else { // neither file nor directory
    }
  }
  return ret;
}

exports.readDirectoryImpl = (left, right, directoryEntry) => {
  return new Promise((resolve,reject) => {
    const ret = new Array();
    const reader = directoryEntry.createReader();
    // This whole crazy promise thing is because `readEntries` seems to be async?
    // So we have to force it to resolve before we return.
    //
    // https://wicg.github.io/entries-api/#api-directoryreader
    // EXAMPLE 9
    const readLoop = () => {
      reader.readEntries((entries) => {
        const len = entries.length
        if (entries.length === 0) {
          resolve(ret);
        }
        else {
          for (var i=0;i<len;++i) {
            const entry = entries[i];
            if (entry.isFile) {
              ret.push(left(entry));
            }
            else if (entry.isDirectory) {
              ret.push(right(entry));
            }
            else throw("neither file nor directory");
          }
          // At this point, we could call a progress callback with ret.length.
          // progress :: Int -> Aff Unit
          // progress(ret.length);
          readLoop();
        }
      });
    };
    readLoop();
  });
}

// https://wicg.github.io/entries-api/#api-fileentry
// EXAMPLE 12
exports.getFileImpl = (entry) => {
  return new Promise((resolve,reject) => {
    entry.file(resolve, reject);
  })
}

exports.directoryName = (d) => {
  return d.name;
}

exports.directoryPath = (d) => {
  return d.fullPath;
}

exports.fileName = (f) => {
  return f.name;
}

exports.filePath = (f) => {
  return f.fullPath;
}
