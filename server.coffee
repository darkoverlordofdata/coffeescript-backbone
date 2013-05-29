

# Module dependencies.
application_root = __dirname

express = require( 'express' )    # Web framework
path = require( 'path' )          # Utilities for dealing with file paths
mongoose = require( 'mongoose' )  # MongoDB integration


# Create server
app = express()

#Connect to database
mongoose.connect 'mongodb://localhost/library_database'

#Schemas
Keywords = new mongoose.Schema(keyword: String)

Book = new mongoose.Schema
  title       : String
  author      : String
  releaseDate : Date
  keywords    : [ Keywords ]

# Models
BookModel = mongoose.model( 'Book', Book )


# Configure server
app.configure ->
  # parses request body and populates request.body
  app.use express.bodyParser()

  # checks request.body for HTTP method overrides
  app.use express.methodOverride()

  # perform route lookup based on url and HTTP method
  app.use app.router

  # Where to serve static content
  app.use express.static(path.join(application_root, 'site'))

  # Show all errors in development
  app.use express.errorHandler(dumpExceptions: true, showStack: true)


# Routes
app.get '/api', (request, response) ->
  response.send 'Library API is running'


# Get a list of all books
app.get '/api/books', (request, response) ->
  BookModel.find (err, books) ->
    if !err
      response.send books
    else
      console.log err


#Get a single book by id
app.get '/api/books/:id', (request, response) ->
  BookModel.findById request.params.id, (err, book) ->
    if !err
      response.send book
    else
      console.log err


#Insert a new book
app.post '/api/books', (request, response) ->
  book = new BookModel
    title       : request.body.title
    author      : request.body.author
    releaseDate : request.body.releaseDate
    keywords    : request.body.keywords

  book.save (err) ->
    if !err
      console.log 'created'
    else
      console.log err

  response.send book

#Update a book
app.put '/api/books/:id', (request, response) ->
  console.log 'Updating book ' + request.body.title
  BookModel.findById request.params.id, (err, book) ->
    book.title        = request.body.title
    book.author       = request.body.author
    book.releaseDate  = request.body.releaseDate
    book.keywords     = request.body.keywords

    book.save (err) ->
      if !err
        console.log 'book updated'
      else
        console.log err

      response.send book


#Delete a book
app.delete '/api/books/:id', (request, response) ->
  console.log 'Deleting book with id: ' + request.params.id
  BookModel.findById request.params.id, (err, book) ->
    book.remove (err) ->
      if !err
        console.log 'Book removed'
        response.send ''
      else
        console.log err


#Start server
port = 4711
app.listen port, ->
  console.log 'Express server listening on port %d in %s mode', port, app.settings.env

