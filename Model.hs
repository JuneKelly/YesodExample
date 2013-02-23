module Model where

import Prelude
import Yesod
import Data.Text (Text)
import Database.Persist.Quasi
import Database.Persist.MongoDB hiding (master)
import Language.Haskell.TH.Syntax
import Yesod.Markdown (Markdown)
import Data.Time (UTCTime)
import Yesod.Auth.HashDB (HashDBUser(..))

-- You can define all of your database entities in the entities file.
-- You can find more information on persistent and how to declare entities
-- at:
-- http://www.yesodweb.com/book/persistent/

-- note that the UniqueUsername constraint on User will not work with Mongo,
-- to stop duplicate usernames from being entered you should create a 
-- unique index on the user collection like so:
-- db.user.ensureIndex({ username : 1}, { unique : true })
let mongoSettings = (mkPersistSettings (ConT ''MongoBackend))
                        { mpsGeneric = True
                        }
 in share [mkPersist mongoSettings]
    $(persistFileWith lowerCaseSettings "config/models")
    
instance HashDBUser (UserGeneric backend) where
  userPasswordHash = Just . userPassword
  userPasswordSalt = Just . userSalt
  setSaltAndPasswordHash s h u = u { userSalt     = s
                                   , userPassword = h
                                   }
