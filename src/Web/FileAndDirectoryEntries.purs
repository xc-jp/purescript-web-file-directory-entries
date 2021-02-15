-- | The *File and Directory Entries API* WICG Draft Report
-- | https://wicg.github.io/entries-api
-- | https://developer.mozilla.org/en-US/docs/Web/API/File_and_Directory_Entries_API
module Web.FileAndDirectoryEntries
  ( FileSystemFileEntry
  , FileSystemDirectoryEntry
  , getEntries
  , getFile
  , readDirectory
  , directoryName
  , directoryPath
  , fileName
  , filePath
  )
where

import Prelude

import Control.Promise (Promise, toAffE)
import Data.Either (Either(..))
import Data.Function.Uncurried (Fn3, runFn3)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, EffectFn3, runEffectFn1, runEffectFn3)
import Web.File.File (File)
import Web.HTML.Event.DataTransfer (DataTransfer)


-- | Represents a file in a file system.
-- |
-- | https://developer.mozilla.org/en-US/docs/Web/API/FileSystemFileEntry
foreign import data FileSystemFileEntry :: Type

-- | Represents a directory in a file system.
-- |
-- | https://developer.mozilla.org/en-US/docs/Web/API/FileSystemDirectoryEntry
foreign import data FileSystemDirectoryEntry :: Type

foreign import getEntriesImpl
  :: forall a b. Fn3
  (a -> Either FileSystemFileEntry FileSystemDirectoryEntry)
  (b -> Either FileSystemFileEntry FileSystemDirectoryEntry)
  DataTransfer
  (Array (Either FileSystemFileEntry FileSystemDirectoryEntry))

-- | Get the `DataTransfer` items as WebKit `FileSystemEntry` objects.
-- | If any of the `DataTransfer` items are not `FileSystemEntry` objects,
-- | then they will not be returned.
-- |
-- | https://developer.mozilla.org/en-US/docs/Web/API/DataTransferItem/webkitGetAsEntry
-- | https://developer.mozilla.org/en-US/docs/Web/API/DataTransfer
-- | https://developer.mozilla.org/en-US/docs/Web/API/FileSystemEntry
getEntries :: DataTransfer -> Array (Either FileSystemFileEntry FileSystemDirectoryEntry)
getEntries dataTransfer = runFn3 getEntriesImpl Left Right dataTransfer

foreign import readDirectoryImpl
  :: forall a b. EffectFn3
  (a -> Either FileSystemFileEntry FileSystemDirectoryEntry)
  (b -> Either FileSystemFileEntry FileSystemDirectoryEntry)
  FileSystemDirectoryEntry
  (Promise (Array (Either FileSystemFileEntry FileSystemDirectoryEntry)))

-- | Read all of the WebKit `FileSystemEntry` objects from a
-- | `FileSystemDirectoryEntry`.
-- | This must be asynchronous because `readEntries` is asynchronous.
-- |
-- | https://developer.mozilla.org/en-US/docs/Web/API/FileSystemDirectoryReader/readEntries
readDirectory :: FileSystemDirectoryEntry -> Aff (Array (Either FileSystemFileEntry FileSystemDirectoryEntry))
readDirectory directoryEntry =
  toAffE $ runEffectFn3 readDirectoryImpl Left Right directoryEntry

-- | Returns a File object which can be used to read data from the file
-- | represented by the directory entry.
-- |
-- | https://developer.mozilla.org/en-US/docs/Web/API/FileSystemFileEntry/file
getFile :: FileSystemFileEntry -> Aff File
getFile entry = toAffE $ runEffectFn1 getFileImpl entry

foreign import getFileImpl :: EffectFn1 FileSystemFileEntry (Promise File)

-- | The read-only name property of the FileSystemEntry interface returns
-- | a `USVString` specifying the entry's name.
-- |
-- | https://developer.mozilla.org/en-US/docs/Web/API/FileSystemEntry/name
foreign import directoryName :: FileSystemDirectoryEntry -> String

-- | A `USVString` object which provides the full, absolute path from the
-- | file system's root to the entry.
-- |
-- | https://developer.mozilla.org/en-US/docs/Web/API/FileSystemEntry/fullPath
foreign import directoryPath :: FileSystemDirectoryEntry -> String

-- | The read-only name property of the FileSystemEntry interface returns
-- | a `USVString` specifying the entry's name.
-- |
-- | https://developer.mozilla.org/en-US/docs/Web/API/FileSystemEntry/name
foreign import fileName :: FileSystemFileEntry -> String

-- | A `USVString` object which provides the full, absolute path from the
-- | file system's root to the entry.
-- |
-- | https://developer.mozilla.org/en-US/docs/Web/API/FileSystemEntry/fullPath
foreign import filePath :: FileSystemFileEntry -> String
