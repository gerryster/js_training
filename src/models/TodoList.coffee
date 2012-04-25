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
      @filter (todo) ->
        todo.get('done')

    remaining: ->
      @without.apply(@, @done())

    nextOrder: ->
      if (!@length)
        return 1

      this.last().get('order') + 1
    # exercise{{{
    comparator: (todo)->
      todo.get('order')
    # }}}exercise
