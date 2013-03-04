{-# LANGUAGE OverloadedStrings #-}
module TodoListTest
       ( todoListSpecs
       ) where

import TestImport
import TestTools

todoListSpecs :: Specs
todoListSpecs = describe "Main Lists Page" $ do
  
  it "requires login" $ do
    needsLogin GET "/lists"