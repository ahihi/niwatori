{-# LANGUAGE PatternSynonyms #-}

module Niwatori.Kana
  ( Kana
  , pattern Kana
  , KanaSeq
  , pattern KanaSeq
  , mkKana
  , mkKanaSeq
  , getKanaRoma
  ) where

import Data.Text (Text)
import qualified Data.Text as Text

import NLP.Romkan

data Kana = Kana_ Char Text
  deriving (Eq, Show)

pattern Kana ch roma <- Kana_ ch roma

mkKana :: Char -> Maybe Kana
mkKana ch = fmap (Kana_ ch) (getKanaRoma ch)

data KanaSeq = KanaSeq_ Text Text [Kana]
  deriving (Eq, Show)

pattern KanaSeq text roma kanas = KanaSeq_ text roma kanas

mkKanaSeq :: Text -> Maybe KanaSeq
mkKanaSeq text = fmap (KanaSeq_ text (toRoma text)) kanas
  where
    kanas = sequence . map mkKana . Text.unpack $ text

getKanaRoma :: Char -> Maybe Text
getKanaRoma ch
  | chText /= chRoma  = Just chRoma
  | otherwise         = Nothing
  where
    chText = Text.pack [ch]
    chRoma = toRoma chText
