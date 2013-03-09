{-# LANGUAGE OverloadedStrings #-}
module TestImport
    ( module Yesod.Test
    , module Model
    , module Database.Persist
    , runDB
    , Specs
    ) where

import Yesod.Test
import Database.Persist.MongoDB hiding (master)
import Database.Persist hiding (get)

import Model

type Specs = SpecsConn Connection

runDB :: Action IO a -> OneSpec Connection a
runDB = runDBRunner runMongoDBPoolDef
