{-# LANGUAGE OverloadedStrings #-}

import System.Process (readProcess)
import Control.Concurrent (threadDelay)
import Crypto.Hash.SHA256 (hash)
import qualified Data.ByteString.Char8 as BS
import Data.ByteString.Base16 (encode)
import Data.Time.Clock
import Data.Time.Format
import System.Locale (defaultTimeLocale)
import System.IO (appendFile)

logFile :: FilePath
logFile = "/home/dein_user/clipboard.log"

interval :: Int
interval = 2 * 1000000  -- Mikrosekunden (2 Sekunden)

-- Clipboard auslesen
getClipboard :: IO String
getClipboard = do
    result <- readProcess "wl-paste" ["-n"] ""
    return $ trim result
  where
    trim = reverse . dropWhile (`elem` "\n\r") . reverse

-- SHA256 Hash
sha256Hash :: String -> String
sha256Hash s = BS.unpack $ encode $ hash $ BS.pack s

-- Loggen
logClipboard :: String -> IO ()
logClipboard content = do
    now <- getCurrentTime
    let timestamp = formatTime defaultTimeLocale "%Y-%m-%d %H:%M:%S" now
    appendFile logFile $ "[" ++ timestamp ++ "]\n" ++ content ++ "\n\n"

-- Hauptloop
loop :: String -> IO ()
loop lastHash = do
    content <- getClipboard
    let currentHash = sha256Hash content
    if not (null content) && currentHash /= lastHash
        then do
            logClipboard content
            putStrLn $ "Neuer Clipboard-Inhalt geloggt: " ++ take 30 content ++ "..."
            loop currentHash
        else do
            threadDelay interval
            loop lastHash

main :: IO ()
main = loop ""

