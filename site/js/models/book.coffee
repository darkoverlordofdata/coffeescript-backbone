window.app = window.app || {}

class window.app.Book extends Backbone.Model

	defaults:
		coverImage  : 'img/placeholder.png'
		title       : 'No title'
		author      : 'Unknown'
		releaseDate : 'Unknown'
		keywords    : 'None'

	idAttribute   : '_id'
