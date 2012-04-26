define ->
# exercise{{{

  init: ->
    @todos = @model
    @todos.bind 'all', => @$el.empty().append @render @_

  on:
    "click .todo-clear a": (event...) -> @clearCompleted(event...)

  render: (_)-> [
    if @model.length
      _ 'span.todo-count',
        _ 'span.number', remaining = @model.remaining().length
        _ 'span.word', ( if remaining == 1 then ' item' else ' items' ) + ' left'

    if num_done = @model.done().length
      _ 'span.todo-clear',
        _ 'a', { href: "#" }, 'Clear ',
          _ 'span.number-done', num_done
          _ 'span', ' completed'
          _ 'span.word-done', if num_done == 1 then ' item' else ' items'
  ]

  clearCompleted: ->
    _.each @todos.done(), (todo)-> todo.destroy()
# }}}exercise
