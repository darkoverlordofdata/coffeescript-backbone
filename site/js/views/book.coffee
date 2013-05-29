window.app = window.app || {}

class window.app.BookView extends Backbone.View


	tagName: 'div'
	className: 'bookContainer'
	template: $('#bookTemplate').html()

	events: 
		'click .delete': 'deleteBook'

    
	deleteBook: ->
		# Delete model
		@model.destroy()

		# Delete view
		@remove()

	render: ->
		# tmpl is a function that takes a JSON object and returns html
		tmpl = _.template(@template)

		# @el is what we defined in tagName. use $el to get access to jQuery html() function
		@$el.html tmpl(@model.toJSON())

    # chainable
		@
