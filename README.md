Yesod Example
=============

This is a (very) simple Yesod todo-list application.

- MongoDB backend
- HashDB Auth
- Gravatars
- integration testing with CasperJS
- Bootstrap integration
- Basic CRUD operations on User accounts, Todo lists and Tasks

The purpose of this repo is to show an example of a scaffolded Yesod 
site with some functionality beyond that of the examples in 
the (excellent) Yesod Book.
  
For the CasperJS tests, first run `mongorestore --drop` to populate the database, or use the json files in database/create/ with mongoimport to populate the local YesodExample database.