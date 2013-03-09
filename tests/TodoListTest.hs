{-# LANGUAGE OverloadedStrings #-}
module TodoListTest
       ( todoListSpecs
       ) where

import TestImport
import TestTools
import Yesod.Auth.HashDB (setPassword)
import Import hiding (runDB)
import Data.ByteString.Char8 (pack)

import System.IO (hPutStrLn, stderr)

todoListSpecs :: Specs
todoListSpecs = do
  describe "Main Lists Page" $ do
  
    it "requires login" $ do
      needsLogin GET "/lists"
      
    it "shows all todo lists" $ do
      doLogin "testuserone" "password"
      get_ "/lists"
      statusIs 200
      htmlAllContain "h1" "Your Todo Lists"
{-
  describe "List page" $ do
    
    it "should show a list of tasks" $ do
      doLogin "testuserone" "password"
      mUser <- runDB $ selectFirst 
                         [UserUsername ==. "testuserone"] []
      case mUser of
        Just (Entity k v) -> do
          todoList <- runDB $ selectFirst [TodoListOwner ==. k] []
          case todoList of
            Just (Entity k v) -> do
              let route = "/list/" ++ fromPersistValue $ unKey k
              liftIO $ hPutStrLn stderr $ k
              get_ $ pack $ route
              statusIs 200
            _ -> assertFailure "no list"
        _ -> do assertFailure "no user"
-}