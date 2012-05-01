define [], ()->
  # Override the root tag of this node.
  # Similar to the tagName attribute of Backbone.View.
  tag:  "<li>"

  on:
    "click .check": (e...)-> @toggleDone(e...)
    "dblclick div.todo-text": (e...)-> @edit(e...)
    # exercise{{{ # add an event handler which deletes a TODO
    "click span.todo-destroy": (e...)-> @clear(e...)
    # }}}exercise
    "keypress .todo-input": (e...)-> @updateOnEnter(e...)
    "blur .todo-input": (e...)-> @close(e...)

  init: ->
    @class = @model.get('done') and 'done' or ''
    @model.bind('destroy', this.remove, this)
    @model.bind 'change', => @$el.empty().append @render @_

  render: (_)->
    text = @model.get 'text'
    checkbox_attrs =
      type: "checkbox"
    if @model.get('done')
      checkbox_attrs.checked = "checked"

    [
      _ 'div', { class: 'todo' + (if @model.get('done') then ' done' else '') },
        # exercise{{{
        _ '.display',
          _ 'input.check', checkbox_attrs
          _ '.todo-text', text
          _ 'span.todo-destroy'
        # }}}exercise
        _ '.edit',
          @input = $(_ 'input.todo-input', type: "text", value: text)
    ]

  toggleDone: ->
    @model.toggle()
    @$el.toggleClass 'done', @model.get('done')

  edit: ->
    @$el.addClass("editing")
    @input.focus()

  close: ->
    @model.save({text: @input.val()})
    @$el.removeClass("editing")

  updateOnEnter: (e)->
    if (e.keyCode == 13)
      @close()

  remove: ->
    @$el.remove()

  # exercise{{{
  clear: ->
    @model.destroy()
  # }}}exercise
