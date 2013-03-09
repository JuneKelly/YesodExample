{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Main where

import Import
import Yesod.Default.Config
import Yesod.Test
import Application (makeFoundation)

import HomeTest
--import UserTest
import TodoListTest
import DatabaseHelper

main :: IO ()
main = do
    conf <- loadConfig $ (configSettings Testing) { csParseExtra = parseExtra }
    foundation <- makeFoundation conf
    app <- toWaiAppPlain foundation
    runTests app (connPool foundation) dropDB
    runTests app (connPool foundation) recreateDB
    runTests app (connPool foundation) homeSpecs
    --runTests app (connPool foundation) userSpecs
    runTests app (connPool foundation) todoListSpecs
