{-# LANGUAGE OverloadedStrings #-}
module HomeTest
    ( homeSpecs
    ) where

import TestImport

homeSpecs :: Specs
homeSpecs =
  describe "The Homepage" $
    it "should be shown at site root" $ do
      get_ "/"
      statusIs 200
      htmlAllContain "h1" "Welcome"
      htmlAllContain "p"  "This is an example of Yesod in action" 