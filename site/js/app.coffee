window.app = window.app || {}


$ ->
  $( '#releaseDate' ).datepicker()
  new window.app.LibraryView()

