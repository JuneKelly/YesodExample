{-# LANGUAGE OverloadedStrings #-}
module TestTools (
    assertFailure,
    urlPath,
    needsLogin,
    doLogin,
    StdMethod(..),
) where

import TestImport
import qualified Data.ByteString as B
import Data.Text (Text, unpack, pack)
import Data.Text.Encoding (encodeUtf8, decodeUtf8)
import Network.URI (URI(uriPath), parseURI)
import Network.HTTP.Types (StdMethod(..), renderStdMethod)
import Network.Wai.Test (SResponse(..))

-- Adjust as necessary to the url prefix in the Testing configuration
testRoot :: B.ByteString
testRoot = "http://localhost:3000"

-- Force failure by swearing that black is white, and pigs can fly...
assertFailure :: String -> OneSpec conn ()
assertFailure msg = assertEqual msg True False

-- Convert an absolute URL (eg extracted from responses) to just the path
-- for use in test requests.
urlPath :: Text -> Text
urlPath = pack . maybe "" uriPath . parseURI . unpack

-- Internal use only - actual urls are ascii, so exact encoding is irrelevant
urlPathB :: B.ByteString -> B.ByteString
urlPathB = encodeUtf8 . urlPath . decodeUtf8

-- Stages in login process, used below
firstRedirect :: StdMethod -> B.ByteString -> OneSpec conn (Maybe B.ByteString)
firstRedirect method url = do
    doRequest (renderStdMethod method) url $ return ()
    extractLocation  -- We should get redirected to the login page

assertLoginPage :: B.ByteString -> OneSpec conn ()
assertLoginPage loc = do
    assertEqual "correct login redirection location"
                (testRoot `B.append` "/auth/login") loc
    get_ $ urlPathB loc
    statusIs 200
    bodyContains "Login"

submitLogin :: Text -> Text -> OneSpec conn (Maybe B.ByteString)
submitLogin user pass = do
    -- Ideally we would extract this url from the login form on the current page
    post (urlPathB testRoot `B.append` "/auth/page/hashdb/login") $ do
        byName "username" user
        byName "password" pass
    extractLocation  -- Successful login should redirect to the home page

extractLocation :: OneSpec conn (Maybe B.ByteString)
extractLocation = do
    statusIs 303
    withResponse ( \ SResponse { simpleHeaders = h } ->
                        return $ lookup "Location" h
                 )

-- Check that accessing the url with the given method requires login, and
-- that it redirects us to what looks like the login page.
--
needsLogin :: StdMethod -> B.ByteString -> OneSpec conn ()
needsLogin method url = do
    mbloc <- firstRedirect method url
    maybe (assertFailure "Should have location header") assertLoginPage mbloc

-- Do a login (using hashdb auth).  This just attempts to go to the home
-- url, and follows through the login process.  It should probably be the
-- first thing in each "it" spec.
--
doLogin :: Text -> Text -> OneSpec conn ()
doLogin user pass = do
    mbloc2 <- submitLogin user pass
    return ()