{-# LANGUAGE PatternSynonyms #-}

module Niwatori.Kana
  ( Kana
  , pattern Kana
  , mkKana
  ) where

import Data.Text (Text)
import qualified Data.Text as Text

import NLP.Romkan

data Kana = Kana_ Char Text
  deriving (Eq, Show)

pattern Kana ch roma <- Kana_ ch roma

mkKana :: Char -> Maybe Kana
mkKana ch 
  | chText /= chRoma  = Just $ Kana_ ch chRoma
  | otherwise         = Nothing
  where
    chText = Text.pack [ch]
    chRoma = toRoma chText
