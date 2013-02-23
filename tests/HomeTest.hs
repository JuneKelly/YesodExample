{-# LANGUAGE OverloadedStrings #-}
module HomeTest
    ( homeSpecs
    ) where

import TestImport

homeSpecs :: Specs
homeSpecs =
  describe "These are some example tests" $
    it "loads the index and checks it looks right" $ do
      get_ "/"
      statusIs 200
      htmlAllContain "h1" "Hi There"