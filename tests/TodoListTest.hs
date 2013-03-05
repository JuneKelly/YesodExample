{-# LANGUAGE OverloadedStrings #-}
module TodoListTest
       ( todoListSpecs
       ) where

import TestImport
import TestTools
import Yesod.Auth.HashDB (setPassword)
import Database.Persist
import Model

todoListSpecs :: Specs
todoListSpecs = describe "Main Lists Page" $ do
  
  it "requires login" $ do
    needsLogin GET "/lists"
    
  it "shows all todo lists" $ do
    doLogin "testuser" "password"
    get_ "/lists"
    statusIs 200
    htmlAllContain "h1" "Your Todo Lists"