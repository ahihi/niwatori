module Niwatori
    ( sepKana
    , sepKanas
    ) where

import Data.Text (Text)
import qualified Data.Text as Text
import NLP.Romkan

import Niwatori.Kana

sepKana :: Char -> Either Char Kana
sepKana ch = case mkKana ch of
  Nothing   -> Left ch
  Just kana -> Right kana

sepKanas :: Text -> [Either Char Kana]
sepKanas = Text.foldr (\ch es -> sepKana ch : es) []
