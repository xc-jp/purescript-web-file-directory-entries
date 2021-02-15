-- | We could publish this module.
-- | https://wicg.github.io/entries-api
-- | https://developer.mozilla.org/en-US/docs/Web/API/File_and_Directory_Entries_API
module FileAndDirectoryEntries
  ( FileSystemFileEntry
  , FileSystemDirectoryEntry
  , getEntries
  , getFile
  , readDirectory
  , directoryName
  , fileName
  )
where

-- | https://developer.mozilla.org/en-US/docs/Web/API/DataTransfer

import Prelude

import Control.Promise (Promise, toAffE)
import Data.Either (Either(..))
import Data.Function.Uncurried (Fn3, runFn3)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, EffectFn3, runEffectFn1, runEffectFn3)
import Web.File.File (File)
import Web.HTML.Event.DataTransfer (DataTransfer)

foreign import dataTransferItemList :: DataTransfer -> Array DataTransferItem

-- | https://developer.mozilla.org/en-US/docs/Web/API/DataTransferItem/webkitGetAsEntry
-- | https://pursuit.purescript.org/search?q=webkitGetAsEntry
foreign import webkitGetAsEntry :: DataTransferItem -> FileSystemEntry

-- | https://developer.mozilla.org/en-US/docs/Web/API/DataTransferItemList
-- foreign import data DataTransferItemList

-- | https://developer.mozilla.org/en-US/docs/Web/API/DataTransferItem
foreign import data DataTransferItem :: Type

-- | https://developer.mozilla.org/en-US/docs/Web/API/FileSystemEntry
-- | https://pursuit.purescript.org/search?q=FileSystemEntry
foreign import data FileSystemEntry :: Type

-- | https://developer.mozilla.org/en-US/docs/Web/API/FileSystemFileEntry
-- | https://pursuit.purescript.org/search?q=FileSystemFileEntry
foreign import data FileSystemFileEntry :: Type

-- | https://developer.mozilla.org/en-US/docs/Web/API/FileSystemDirectoryEntry
-- | https://pursuit.purescript.org/search?q=FileSystemDirectoryEntry
foreign import data FileSystemDirectoryEntry :: Type

foreign import getEntriesImpl
  :: forall a b. Fn3
  (a -> Either FileSystemFileEntry FileSystemDirectoryEntry)
  (b -> Either FileSystemFileEntry FileSystemDirectoryEntry)
  DataTransfer
  (Array (Either FileSystemFileEntry FileSystemDirectoryEntry))

-- | Get the `DataTransfer` items as WebKit `FileSystemEntry` objects.
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

-- | Read all of the WebKit `FileSystemEntry` objects from a `FileSystemDirectoryEntry`,
-- | and return when finished.
-- | This must be asynchronous because `readEntries` is asynchronous.
-- | https://developer.mozilla.org/en-US/docs/Web/API/FileSystemDirectoryReader/readEntries
readDirectory :: FileSystemDirectoryEntry -> Aff (Array (Either FileSystemFileEntry FileSystemDirectoryEntry))
readDirectory directoryEntry =
  toAffE $ runEffectFn3 readDirectoryImpl Left Right directoryEntry

-- | https://developer.mozilla.org/en-US/docs/Web/API/FileSystemFileEntry/file
getFile :: FileSystemFileEntry -> Aff File
getFile entry = toAffE $ runEffectFn1 getFileImpl entry

foreign import getFileImpl :: EffectFn1 FileSystemFileEntry (Promise File)

-- | Actually this returns a `USVString`?
-- | https://developer.mozilla.org/en-US/docs/Web/API/FileSystemEntry/name
foreign import directoryName :: FileSystemDirectoryEntry -> String

-- | Actually this returns a `USVString`?
-- | https://developer.mozilla.org/en-US/docs/Web/API/FileSystemEntry/name
foreign import fileName :: FileSystemFileEntry -> String