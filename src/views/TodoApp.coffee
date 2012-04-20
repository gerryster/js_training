define [
  'models/TodoList'
  'views/TodoView'
], (TodoList, TodoView)->

  todos: new TodoList()

  on: # similar to the events method in Backbone.View
    # peter-review: Backbone.Views events are set up so that the values of the hash are strings of the method of this object to call when the events fire.  I could have in-lined these methods in on: but that seemed like a lot of clutter.  Is there a better way to do this?
    "keypress #new-todo": (event...) ->  @createOnEnter(event...)
    "keyup #new-todo": (event...) -> @showTooltip(event...)
    "click .todo-clear a": (event...) -> @clearCompleted(event...)

  init: ->
    @todos.bind('add', @addOne, this)
    @todos.bind('reset', @addAll, this)
    @todos.bind('all', @render, this)

    @todos.fetch()

  afterRender: ->
    @input = @$("#new-todo")

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
    _ '#todo-stats'
  ]

  showTooltip: (e)->
    tooltip = this.$(".ui-tooltip-top")
    val = @input.val()
    
    tooltip.fadeOut()
    
    if (this.tooltipTimeout)
        clearTimeout(this.tooltipTimeout)
    if (val == '' || val == this.input.attr('placeholder'))
       return
    
    show = -> tooltip.show().fadeIn()
    
    this.tooltipTimeout = _.delay(show, 1000)

  addOne: (todo)->
    view = new TodoView({model: todo})
    this.$("#todo-list").append(view.render().el)

  addAll: ->
    this.todos.each(this.addOne)

  createOnEnter: (e)->
    text = this.input.val()
      
    if (!text || e.keyCode != 13)
      return
      
    this.todos.create({text: text, done: false, order: this.todos.nextOrder()})
    this.input.val('')

  clearCompleted: ->
    _.each(this.todos.done(), (todo)-> todo.destroy())
    return false
