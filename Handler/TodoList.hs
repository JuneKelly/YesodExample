module Handler.TodoList (
  getIndexTodoListR,
  postNewTodoListR,
  getTodoListR,
  postDelTodoListR,
  postNewTaskR,
  postDoneTaskR,
  postDeleteTaskR
) where

import Import

-- index
getIndexTodoListR :: Handler RepHtml
getIndexTodoListR = do
  uid <- requireAuthId
  lists <- runDB $ selectList [TodoListOwner ==. uid] []
  (tForm, enctype) <- generateFormPost $ newListForm uid
  defaultLayout $ do
    $(widgetFile "todolists")
    
-- show
getTodoListR :: TodoListId -> Handler RepHtml
getTodoListR listId = do
  uid <- requireAuthId
  todoList <- runDB $ get404 listId
  tasks <- runDB $ selectList [TaskTodoList ==. listId] []
  (taskForm, _) <- generateFormPost $ newTaskForm listId
  let owner = (todoListOwner todoList) == uid
  case owner of
    True -> defaultLayout $ do
      setTitle $ toHtml $ todoListTitle todoList
      $(widgetFile "todolist")
    False -> do
      setMessage $ msgAlert "Access Denied"
      redirect HomeR    

-- new list    
newListForm :: UserId -> Form TodoList
newListForm uid = 
  renderDivs $ TodoList
  <$> areq textField "Title" Nothing
  <*> pure uid
  
postNewTodoListR :: Handler RepHtml
postNewTodoListR = do
  uid <- requireAuthId
  ((res, _), _) <- runFormPost $ newListForm uid
  case res of
    FormSuccess todoList -> do
      _ <- runDB $ insert todoList
      setMessage $ msgSuccess $ (todoListTitle todoList) <> " created!"
      redirect IndexTodoListR
    _ -> do
      setMessage $ msgAlert "Something went wrong"
      redirect IndexTodoListR

-- new task
newTaskForm :: TodoListId -> Form Task
newTaskForm lid =
  renderDivs $ Task
  <$> areq textField FieldSettings
        { fsLabel = "Title"
        , fsTooltip = Nothing
        , fsId = Just "title-input"
        , fsName = Nothing
        , fsAttrs = [("class", "primary-input")]
        } Nothing
  <*> pure False
  <*> pure lid

postNewTaskR :: TodoListId -> Handler RepHtml
postNewTaskR listId = do
  uid <- requireAuthId
  todoList <- runDB $ get404 listId
  let owner = uid `isOwner` todoList
  ((res, _), _) <- runFormPost $ newTaskForm listId
  case (owner, res) of
    (True, FormSuccess task) -> do
      _ <- runDB $ insert task
      setMessage $ msgSuccess "Task added"
      redirect $ TodoListR listId
    (False, _) -> do
      setMessage $ msgAlert "Permission Denied"
      redirect HomeR
    (_, _) -> do
      setMessage $ msgAlert "Something went wrong"
      redirect HomeR

-- delete list
postDelTodoListR :: TodoListId -> Handler RepHtml
postDelTodoListR listId = do
  uid <- requireAuthId
  todoList <- runDB $ get404 listId
  unless (uid `isOwner` todoList) $ 
    permissionDenied "You cannot delete this list"
  runDB $ delete listId
  setMessage $ msgSuccess $ "Deleted " <> todoListTitle todoList
  redirect IndexTodoListR

-- mark task as done
postDoneTaskR :: TaskId -> Handler RepHtml
postDoneTaskR taskId = do
  uid <- requireAuthId
  task <- runDB $ get404 taskId
  let listId = taskTodoList task
  todoList <- runDB $ get404 listId
  unless (uid `isOwner` todoList) $
    permissionDenied "You cannot do that"
  runDB $ update taskId [TaskDone =. True]
  setMessage $ msgSuccess $ (taskTitle task) <> " done!"
  redirect (TodoListR listId)
  
-- delete task
postDeleteTaskR :: TaskId -> Handler RepHtml
postDeleteTaskR taskId = do
  uid <- requireAuthId
  task <- runDB $ get404 taskId
  todoList <- runDB $ get404 $ taskTodoList task
  case (uid `isOwner` todoList) of
    True -> do
      runDB $ delete taskId
      setMessage $ msgSuccess "Deleted task"
      redirect (TodoListR $ taskTodoList task)
    _ ->  do
      setMessage $ msgAlert "Access Denied"
      redirect (HomeR)
      
-- helpers
_Task :: TaskId
         -> Task
         -> Widget
_Task tId t = $(widgetFile "_Task")

isOwner :: UserId -> TodoList -> Bool
isOwner uId todoList
  | (todoListOwner todoList == uId) = True
  | otherwise = False