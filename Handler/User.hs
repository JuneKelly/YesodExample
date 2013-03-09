module Handler.User 
       (
        getShowUserR,
        getEditUserR,
        postEditUserR,
        getNewUserR,
        postNewUserR
       )
where

import Import
import Yesod.Auth.HashDB (setPassword)
import Yesod.Markdown

-- show user
getShowUserR :: UserId -> Handler RepHtml
getShowUserR userId = do
  muser <- maybeAuthId
  user <- runDB $ get404 userId
  defaultLayout $ do
    setTitle $ toHtml $ userFullName user
    $(widgetFile "user")
    
-- edit
userForm :: User -> Form User
userForm user =
  renderDivs $ User
  <$> pure (userUsername user) -- credentials are not editable, and 
  <*> pure (userPassword user) -- are derived from the User which
  <*> pure (userSalt user)     -- is passed to this Form
  <*> areq textField "Full Name" (Just $ userFullName user)
  <*> aopt markdownField "Description" (Just $ userDescription user)
  <*> pure (userAdmin user)
  <*> aopt emailField "Email" (Just $ userEmail user) 
    
getEditUserR :: Handler RepHtml
getEditUserR = do
  uid <- requireAuthId
  user <- runDB $ get404 uid
  (uForm, enctype) <- generateFormPost $ userForm user
  defaultLayout $ do
    setTitle "Edit Profile"
    $(widgetFile "edit-user")
  
postEditUserR :: Handler RepHtml
postEditUserR = do
  uid <- requireAuthId
  user <- runDB $ get404 uid
  ((res, uForm), enctype) <- runFormPost $ userForm user
  case res of
    FormSuccess u -> do
      let newDetails = 
            [ UserFullName =. (userFullName u),
              UserDescription =. (userDescription u),
              UserAdmin =. (userAdmin u),
              UserEmail =. (userEmail u) ]
      runDB $ update (uid) newDetails
      redirect $ ShowUserR uid
    _ -> do
      setMessage $ msgAlert "Error: something went wrong"
      defaultLayout $ do
        setTitle "Error"
        $(widgetFile "edit-user")
        
-- new users
data NewUser = NewUser { nUsername :: Text,
                         nFullName :: Text,
                         nPassword :: Text
                       }
               
newUserForm :: Form NewUser
newUserForm = renderDivs $ NewUser
              <$> areq textField "Username" Nothing
              <*> areq textField "Full Name" Nothing
              <*> areq textField "Password" Nothing
              
getNewUserR :: Handler RepHtml
getNewUserR = do
  (nuForm, _) <- generateFormPost newUserForm
  defaultLayout $ do
    setTitle "Sign up"
    $(widgetFile "newuser")
  
postNewUserR :: Handler RepHtml
postNewUserR = do
  ((result, nuForm), _) <- runFormPost newUserForm
  case result of
    FormSuccess nu -> do
      newb <- setPassword (nPassword nu) $
            User { userUsername = (nUsername nu), 
                   userPassword = "",
                   userSalt = "",
                   userFullName = (nFullName nu),
                   userDescription = Nothing,
                   userAdmin = False,
                   userEmail = Nothing
                 }
      nameTaken <- usernameTaken $ nUsername nu
      -- check username availability before insert
      -- avoid internal server error when using Mongo
      -- with a unique index on User collection
      if (nameTaken)
        then do
          setMessage $ msgAlert "That username is not available"
          defaultLayout $ do -- redisplay the page, keeping form data
            setTitle "Name Taken"
            $(widgetFile "newuser")
        else do
          _ <- runDB $ insert newb
          setMessage $ msgSuccess $ "Created User " <> nFullName nu
          redirect $ AuthR LoginR
    _ -> do
      setMessage $ msgError "Something went wrong"
      redirect HomeR

usernameTaken :: Text -> Handler Bool
usernameTaken name = do
  results <- runDB $ selectList [UserUsername ==. name] []
  case results of
    [] -> return False
    _  -> return True