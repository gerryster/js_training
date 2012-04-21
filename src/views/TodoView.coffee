define [], ()->
  # Override the root tag of this node.
  # Similar to the tagName attribute of Backbone.View.
  tag:  "<li>"

  on: {
    "click .check": (e...)-> @toggleDone(e...)
    "dblclick div.todo-text": (e...)-> @edit(e...)
    "click span.todo-destroy": (e...)-> @clear(e...)
    "keypress .todo-input": (e...)-> @updateOnEnter(e...)
  }

  init: ->
    # peter-review: the bind to the model below in intended to redraw this
    # view when the model changes.  That works fine for the Backbone.View
    # implementation because that render appends itself to "el".  However, in
    # the case of cell, render get passed the model object as the first
    # parameter.  Question: how should we re-render a cell?
    #@model.bind('change', this.render, this)
    @model.bind('destroy', this.remove, this)

  render: (_)->
    # get the root element of this cell and clear it out
    $(@el).empty()

    checkbox_attrs =
      type: "checkbox"
    if @model.get('done')
      checkbox_attrs.checked = "checked"

    [
      _ 'div', { class: 'todo' + (if @model.get('done') then ' done' else '') },
        _ '.display',
          _ 'input.check', checkbox_attrs
          _ '.todo-text'
          _ 'span.todo-destroy'
        _ '.edit',
          _ 'input.todo-input', { type: "text", value: "" }

    ]

  afterRender: ->
    @setText()

  setText: ->
    text = this.model.get('text')
    @$('.todo-text').text(text)
    @input = @$('.todo-input')
    # In this case the "_" in "_.bind" is the Underscore.js object.  See
    # http://documentcloud.github.com/underscore/#bind .
    @input.bind('blur', _.bind(@close, this)).val(text)

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
