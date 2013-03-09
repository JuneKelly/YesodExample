{-# LANGUAGE OverloadedStrings #-}
module DatabaseHelper where

import TestImport
import TestTools
import Yesod.Auth.HashDB (setPassword)

dropDB :: Specs
dropDB = describe "drop database" $ do
  
  it "should clear all database tables" $ do
    runDB $ deleteWhere ([] :: [Filter Task])
    runDB $ deleteWhere ([] :: [Filter TodoList])
    runDB $ deleteWhere ([] :: [Filter User])

recreateDB :: Specs
recreateDB = describe "recreate test database" $ do
  
  it "should populate the test database" $ do
    -- Users
    uOne <- setPassword "password" $
               User { userUsername = "testuserone"
                    , userFullName = "Testuser One"
                    , userDescription = Just "Description"
                    , userAdmin = True
                    , userEmail = Just "testuserone@example.com"
                    }
    uTwo <- setPassword "password" $
               User { userUsername = "testusertwo"
                    , userFullName = "Testuser Two"
                    , userDescription = Just "Description"
                    , userAdmin = False
                    , userEmail = Just "testusertwo@example.com"
                    }
    uidOne <- runDB $ insert uOne
    uidTwo <- runDB $ insert uTwo
    
    -- TodoLists and Tasks
    listOne <- runDB $ insert $
                 TodoList { todoListTitle = "List One"
                          , todoListOwner = uidOne
                          }
    taskOne <- runDB $ insert $
                Task { taskTitle = "Task One"
                     , taskDone = False
                     , taskTodoList = listOne
                     }
    taskTwo <- runDB $ insert $
                Task { taskTitle = "Task Two"
                     , taskDone = False
                     , taskTodoList = listOne
                     }
    _ <- runDB $ insert $
                   TodoList { todoListTitle = "List Two"
                            , todoListOwner = uidOne
                            }
    listThree <- runDB $ insert $
                   TodoList { todoListTitle = "List Three"
                            , todoListOwner = uidTwo
                            }
    return ()
                          
                 
      