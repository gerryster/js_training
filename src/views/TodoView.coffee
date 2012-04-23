define [], ()->
  # Override the root tag of this node.
  # Similar to the tagName attribute of Backbone.View.
  tag:  "<li>"

  on:
    "click .check": (e...)-> @toggleDone(e...)
    "dblclick div.todo-text": (e...)-> @edit(e...)
    "click span.todo-destroy": (e...)-> @clear(e...)
    "keypress .todo-input": (e...)-> @updateOnEnter(e...)
    "blur .todo-input": (e...)-> @close(e...)
  

  init: ->
    @model.bind('destroy', this.remove, this)

    # peter-review: the bind to the model below in intended to redraw this
    # view when the model changes.  That works fine for the Backbone.View
    # implementation because that render appends itself to "el".  However, in
    # the case of cell, render get passed the model object as the first
    # parameter.  Question: how should we re-render a cell?
    # peter-answer: Short Answer: empty @el, call @render, and append result
    #               to @el.  I'd like to discuss the value of having a
    #               @rerender-like method.  cell originally had this, but was
    #               taken out because of the lack of personal usage and
    #               complexity of reregistering event handling (which may not
    #               be the case anymore with the implementation jQuery.on()).
    @model.bind 'change', => @$el.empty().append @render @_

  render: (_)->
    text = @model.get 'text'
    checkbox_attrs =
      type: "checkbox"
    if @model.get('done')
      checkbox_attrs.checked = "checked"

    [
      _ 'div', { class: 'todo' + (if @model.get('done') then ' done' else '') },
        _ '.display',
          _ 'input.check', checkbox_attrs
          _ '.todo-text', text
          _ 'span.todo-destroy'
        _ '.edit',
          @input = $(_ 'input.todo-input', type: "text", value: text)
    ]

  toggleDone: ->
    @model.toggle()

  edit: ->
    $(this.el).addClass("editing")
    @input.focus()

  close: ->
    @model.save({text: @input.val()})
    $(@el).removeClass("editing")

  updateOnEnter: (e)->
    if (e.keyCode == 13)
      @close()

  remove: ->
    $(@el).remove()

  clear: ->
    @model.destroy()
