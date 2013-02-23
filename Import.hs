module Import
    ( module Import
    ) where

import           Prelude              as Import hiding (head, init, last,
                                                 readFile, tail, writeFile)
import           Yesod                as Import hiding (Route (..))

import           Control.Applicative  as Import (pure, (<$>), (<*>))
import           Data.Text            as Import (Text)

import           Foundation           as Import
import           Model                as Import
import           Settings             as Import
import           Settings.Development as Import
import           Settings.StaticFiles as Import
import Text.Blaze.Html (preEscapedToHtml)
import Data.Time as Import (UTCTime, getCurrentTime, formatTime)
import System.Locale as Import (defaultTimeLocale)
import Network.Gravatar as Import hiding (NotFound, def)
import Yesod.Auth as Import
import Control.Monad as Import (unless)

#if __GLASGOW_HASKELL__ >= 704
import           Data.Monoid          as Import
                                                 (Monoid (mappend, mempty, mconcat),
                                                 (<>))
#else
import           Data.Monoid          as Import
                                                 (Monoid (mappend, mempty, mconcat))

infixr 5 <>
(<>) :: Monoid m => m -> m -> m
(<>) = mappend
#endif

-- helpers
msgAlert :: Text -> Html
msgAlert msg =
    preEscapedToHtml $
        "<div class='alert'>"
        <> msg <> "</div>"

msgSuccess :: Text -> Html
msgSuccess msg =
    preEscapedToHtml $
        "<div class='alert alert-success'>"
        <> (msg) <> "</div>"

msgError :: Text -> Html
msgError msg =
    preEscapedToHtml $
        "<div class='alert alert-error'>"
        <> msg <> "</div>"

msgInfo :: Text -> Html
msgInfo msg =
    preEscapedToHtml $
        "<div class='alert alert-info'>"
        <> msg <> "</div>"

-- gravatar
getGravatar :: Text -> Html
getGravatar email = toHtml $ gravatar options email 
  where options =
          GravatarOptions { gSize = Just $ Size 128,
                            gDefault = Nothing,
                            gForceDefault = ForceDefault False,
                            gRating = Nothing
                          }