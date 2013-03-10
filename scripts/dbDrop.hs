{-# LANGUAGE QuasiQuotes, TemplateHaskell, TypeFamilies, 
    OverloadedStrings, GADTs, FlexibleContexts #-}

import Foundation
import Application

main :: IO ()
main = do
  runDB $ deleteWhere ([] :: [Filter Task])
  runDB $ deleteWhere ([] :: [Filter TodoList])
  runDB $ deleteWhere ([] :: [Filter User])