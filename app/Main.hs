{-# LANGUAGE LambdaCase, OverloadedStrings #-}

module Main where

import Data.Text (Text)
import qualified Data.Text as Text
import qualified Data.Text.IO as TextIO
import qualified System.Environment as Env

import Niwatori
import Niwatori.Kana

main :: IO ()
main = do
  args <- getArgsText
  let separatedArgs = map sepKanas args
  mapM_ (TextIO.putStrLn . separatedsToText) separatedArgs

getArgsText :: IO [Text]
getArgsText = map Text.pack <$> Env.getArgs

separatedsToText :: [Either Char Kana] -> Text
separatedsToText = Text.concat . map elemText
  where
    elemText = \case
      Left ch ->
        Text.singleton ch
      Right (Kana ch romaji) ->
        Text.concat [Text.singleton ch, romaji]
