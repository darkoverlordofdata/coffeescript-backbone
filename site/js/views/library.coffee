window.app = window.app || {}

class window.app.LibraryView extends Backbone.View

	el: $('#books')

	initialize: ->
		@collection = new window.app.Library()
		@collection.fetch()
		@render()

		@listenTo @collection, 'add', @renderBook 
		@listenTo @collection, 'reset', @render 
	

	events: 
		'click #add': 'addBook'
	

	addBook: (e) ->
		e.preventDefault()

		formData = {}

		$('#addBook div').children('input').each (i, el) =>

			if  $(el).val() isnt ""

				if el.id is 'keywords'
					formData[el.id] = []
					_.each $( el).val().split( ' ' ), (keyword) =>

						formData[el.id].push 'keyword': keyword

				else if el.id is 'releaseDate'
					formData[el.id] = $('#releaseDate').datepicker('getDate').getTime()

				else
					formData[el.id] = $(el).val()

		@collection.create formData
	

	# render library by rendering each book in its collection
	render: ->
		@collection.each (item) =>
			@renderBook item
		@
	

	# render a book by creating a BookView and appending the
	# element it renders to the library's element
	renderBook: (item) ->
		bookView = new window.app.BookView(model: item)
		@$el.append bookView.render().el

