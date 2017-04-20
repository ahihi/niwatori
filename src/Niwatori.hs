{-# LANGUAGE LambdaCase #-}

module Niwatori
  ( splitKanaTexts
  ) where

import Data.Text (Text)
import qualified Data.Text as Text
import NLP.Romkan

import Niwatori.Kana

splitMaybes :: [Maybe a] -> [[a]]
splitMaybes = go False
  where
    go wasJust = \case
      []         -> consEmptyIfWasJust []
      Nothing:xs -> consEmptyIfWasJust (go False xs)
      Just x:xs  -> mapFirst (x:) (go True xs)
      where
        consEmptyIfWasJust
          | wasJust   = ([]:)
          | otherwise = id
        mapFirst _ []     = []
        mapFirst f (x:xs) = f x : xs

splitKanaTexts :: Text -> [Text]
splitKanaTexts = map Text.pack . splitMaybes . map checkKana . Text.unpack
  where
    checkKana ch = fmap (const ch) (getKanaRoma ch)
