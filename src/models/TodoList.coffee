define [
  'models/Todo'
  'helpers/LocalStorage'
], (Todo,LocalStorage)->
  TodoList = Backbone.Collection.extend

    model: Todo

    # Use HTML5 local storage instead of saving models to a web server.
    localStorage: new LocalStorage("TodoList")

    url: '/todos/'

    done: ->
      this.filter (todo) ->
        todo.get('done')

    remaining: ->
      this.without.apply(this, this.done())

    nextOrder: ->
      if (!this.length)
        return 1

      this.last().get('order') + 1

    comparator: (todo)->
      todo.get('order')
