{-# LANGUAGE OverloadedStrings #-}
module HomeTest
    ( homeSpecs
    ) where

import TestImport
import TestTools

homeSpecs :: Specs
homeSpecs = describe "The Homepage" $ do
    it "should be shown at site root" $ do
      get_ "/"
      statusIs 200
      htmlAllContain "h1" "Welcome"
      htmlAllContain "p"  "This is an example of Yesod in action"
      
    it "should have appropriate menu items" $ do
      get_ "/"
      statusIs 200
      bodyContains "Home"
      bodyContains "Login"