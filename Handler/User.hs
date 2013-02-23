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
  <$> pure (userUsername user)
  <*> pure (userPassword user)
  <*> pure (userSalt user)
  <*> areq textField "Full Name" (Just $ userFullName user)
  <*> aopt textField "Description" (Just $ userDescription user)
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
  ((res, _), _) <- runFormPost newUserForm
  case res of
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
      _ <- runDB $ insert newb
      setMessage $ msgSuccess "User created"
      redirect HomeR
    _ -> do
      setMessage $ msgError "Something went wrong"
      redirect HomeR