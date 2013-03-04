{-# LANGUAGE OverloadedStrings #-}
module UserTest
       ( userSpecs
       ) where

import TestImport
import TestTools

userSpecs :: Specs
userSpecs = describe "User profile page" $ do
  -- fixme : test access to the User profile page
  
{-  
    it "requires login" $ do
      needsLogin GET "/lists"


    it "looks right" $ do
      doLogin "testuser" "testpassword"
      get_ "/"
      statusIs 200
      bodyContains "Welcome"
-}