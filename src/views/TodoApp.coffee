define [
  'models/TodoList'
  'cell!./TodoView'
  'cell!./Stats'
], (TodoList, TodoView, Stats)->

  todos: new TodoList()

  on: # similar to the events method in Backbone.View
    "keypress #new-todo": (event...) ->  @createOnEnter(event...)
    "keyup #new-todo": (event...) -> @showTooltip(event...)
    "click .todo-clear a": (event...) -> @clearCompleted(event...)

  init: ->
    @todos.fetch()

    # When these events happen on the TodoList collection, call the following
    # methods on this object:
    @todos.bind('add', @addOne, this)
    @todos.bind('reset', @addAll, this)

  afterRender: ->
    @input = @$("#new-todo")
    @addAll()

    # for debugging TodoView: set the todo input and trigger pressing the enter key
    #console.log("forcing 'foo' as the first todo")
    #@input.val('foo\n')
    #@createOnEnter({keyCode: 13})

  render: (_)-> [
    _ 'h1', "Todos"

    _ '.content',
      _ '#create-todo',
        _ 'input#new-todo',
          placeholder: "What needs to be done?",
          type: "text",
        _ 'span.ui-tooltip-top', { style: "display:none;" }, 'Press Enter to save this task'

    _ '#todos',
      _ 'ul#todo-list'

    _ Stats, model: @todos
  ]

  showTooltip: (e)->
    tooltip = @$(".ui-tooltip-top")
    val = @input.val()

    tooltip.fadeOut()

    if (@tooltipTimeout)
        clearTimeout(@tooltipTimeout)
    if (val == '' || val == @input.attr('placeholder'))
       return

    show = -> tooltip.show().fadeIn()

    @tooltipTimeout = _.delay(show, 1000)

  addOne: (todo)->
    @$("#todo-list").append(@_(TodoView, model: todo))

  addAll: ->
    # Note: we pass this in as the second parameter to each so that addOne is
    # run in the context of this object and not the global object (window).
    @todos.each(@addOne, this)

  createOnEnter: (e)->
    text = @input.val()

    if (!text || e.keyCode != 13)
      return

    @todos.create({text: text, done: false, order: @todos.nextOrder()})
    @input.val('')

  clearCompleted: ->
    _.each(@todos.done(), (todo)-> todo.destroy())
    return false
