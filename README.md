# purescript-web-file-directory-entries

[![Pursuit](http://pursuit.purescript.org/packages/purescript-web-file-directory-entries/badge)](http://pursuit.purescript.org/packages/purescript-web-file-directory-entries/)

Type definitions and implementation for the
[*File and Directory Entries API* WICG Draft Report](https://wicg.github.io/entries-api). This API is not a standard, and will
[probably never be a standard](https://developer.mozilla.org/en-US/docs/Web/API/File_and_Directory_Entries_API/Firefox_support).

This library is incomplete. It currently contains the useful read-only
portion of the *File and Directory Entries API* which
we needed to implement drag-and-drop file upload on a web page, where the
“file” being uploaded can be multiple files or an entire directory tree.

There is another portion of the *File and Directory Entries API* concerned
with writing to a file system, and that portion we have not yet implemented,
and we probably never will.

Pull requests welcome!

## References

* https://wicg.github.io/entries-api
* https://developer.mozilla.org/en-US/docs/Web/API/File_and_Directory_Entries_API/Introduction


## Usage Example

```purescript
import React.Basic.Events (EventHandler)
import React.Basic.DOM.Events (capture, dataTransfer)
import Data.Filterable (partitionMap)
import Effect.Aff (launchAff_)
import Web.FileAndDirectoryEntries (getEntries, readDirectory)

onDropHandler :: EventHandler
onDropHandler = capture dataTransfer $ maybe (pure unit) $ \dataTrans -> do
  let { left: files, right: dirs } = partitionMap identity $ getEntries dataTrans
  launchAff_ do
    for dirs $ \dir -> do
      { left: subfiles, right: subdirs } <- partitionMap identity <$> readDirectory dir
  ...
```

