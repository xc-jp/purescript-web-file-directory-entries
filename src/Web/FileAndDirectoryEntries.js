"use strict";

exports.dataTransferItemList = (dataTransfer) => {
  const len = dataTransfer.items.length;
  const ret = new Array(len);
  for (var i=0;i<len;++i) {
    ret[i] = dataTransfer.items[i];
  }
  return ret;
}

exports.webkitGetAsEntry = (dataTransferItem) => {
  return dataTransferItem.webkitGetAsEntry();
}

exports.getEntriesImpl = (left, right, dataTransfer) => {
  const len = dataTransfer.items.length;
  const ret = new Array(len);
  for (var i=0;i<len;++i) {
    const item = dataTransfer.items[i];
    const entry = item.webkitGetAsEntry();
    if (entry.isFile) {
      ret[i] = left(entry);
    }
    else if (entry.isDirectory) {
      ret[i] = right(entry);
    }
    else throw("neither file nor directory");
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
          // At this point, we could call a progress callback with ret_.length.
          // progress :: Int -> Aff Unit
          // progress(ret_.length);
          readLoop();
        }
      });
    };
    readLoop();
  });
  // p.then(result => { return ret; });
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

exports.fileName = (f) => {
  return f.name;
}