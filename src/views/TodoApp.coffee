define [
  'models/TodoList'
  'cell!./TodoView'
  'cell!./Stats'
], (TodoList, TodoView, Stats)->

  todos: new TodoList()

  on: # similar to the events method in Backbone.View
    "keypress #new-todo": (event...) ->  @createOnEnter(event...)

  init: ->
    @todos.fetch()

    # When these events happen on the TodoList collection, call the following
    # methods on this object:
    @todos.bind('add', @addOne, this)
    @todos.bind('reset', @addAll, this)

  afterRender: ->
    @$input = @$("#new-todo")
    # exercise{{{ # do something which adds all of the @todos to the DOM
    @addAll()
    # }}}exercise

    # for debugging TodoView: set the todo input and trigger pressing the enter key
    #console.log("forcing 'foo' as the first todo")
    #@$input.val('foo\n')
    #@createOnEnter({keyCode: 13})

  render: (_)-> [
    _ 'h1', "Todos"

    _ '.content',
      _ '#create-todo',
        _ 'input#new-todo',
          placeholder: "What needs to be done?",
          type: "text",

    _ '#todos',
      _ 'ul#todo-list'

    _ Stats, model: @todos
  ]

  addOne: (todo)->
    @$("#todo-list").append(@_(TodoView, model: todo))

  # exercise{{{
  addAll: ->
    # Note: we pass this in as the second parameter to each so that addOne is
    # run in the context of this object and not the global object (window).
    @todos.each(@addOne, this)
  # }}}exercise

  createOnEnter: (e)->
    text = @$input.val()

    if (!text || e.keyCode != 13)
      return

    @todos.create({text: text, done: false, order: @todos.nextOrder()})
    @$input.val('')

