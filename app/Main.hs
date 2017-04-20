{-# LANGUAGE LambdaCase, OverloadedStrings, TemplateHaskell #-}

module Main where

import Data.Aeson
import Data.Aeson.Encode
import Data.Aeson.TH
import Data.Maybe
import Data.Text (Text)
import qualified Data.Text as Text
import qualified Data.Text.Lazy as TextLazy
import qualified Data.Text.Lazy.Builder as TextBuilder
import qualified Data.Text.IO as TextIO
import qualified System.Environment as Env

import Niwatori
import Niwatori.Kana

main :: IO ()
main = do
  args <- getArgsText
  let kanaTexts = concatMap splitKanaTexts args
  let kanaSeqs = catMaybes $ map mkKanaSeq kanaTexts

  if "--json" `elem` args
    then printJson kanaSeqs
    else mapM_ printHuman kanaSeqs

getArgsText :: IO [Text]
getArgsText = map Text.pack <$> Env.getArgs

printHuman :: KanaSeq -> IO ()
printHuman (KanaSeq text roma kanas) = do
  TextIO.putStr text
  TextIO.putStr " "
  TextIO.putStr roma
  TextIO.putStr " ("
  TextIO.putStr $ Text.intercalate " " $ map kanaAndRoma kanas
  TextIO.putStrLn ")"
  where
    kanaAndRoma (Kana ch roma) = Text.pack [ch] `Text.append` roma

printJson :: [KanaSeq] -> IO ()
printJson kanaSeqs = do
  let json = toJSON $ map getJson kanaSeqs
  TextIO.putStrLn $ TextLazy.toStrict $ TextBuilder.toLazyText $ encodeToTextBuilder json
  where
    getJson (KanaSeq text roma kanas) = KanaSeqJson text roma (map kanaJson kanas)
      where
        kanaJson (Kana ch roma) = KanaJson (Text.pack [ch]) roma

data KanaSeqJson = KanaSeqJson
  { kana :: Text
  , romaji :: Text
  , characters :: [KanaJson]
  }

data KanaJson = KanaJson
  { _kana :: Text
  , _romaji :: Text
  }

$(deriveJSON defaultOptions ''KanaSeqJson)
$(deriveJSON defaultOptions {fieldLabelModifier = tail} ''KanaJson)
