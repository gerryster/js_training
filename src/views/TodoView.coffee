define [], ()->
  tagName:  "li",

  on: {
    "click .check": (e...)-> @toggleDone(e...)
    "dblclick div.todo-text": (e...)-> @edit(e...)
    "click span.todo-destroy": (e...)-> @clear(e...)
    "keypress .todo-input": (e...)-> @updateOnEnter(e...)
  }

  init: ->
    # this has a defect in that the first model is rendered twice because the model is changed when it is first created
    #@model.bind('change', this.render, this)
    @model.bind('destroy', this.remove, this)

  render: (_)->
    # get the root element of this cell and clear it out
    $(@el).empty()

    checkbox_attrs =
      type: "checkbox"
    if @model.done
      checkbox_attrs.checked = "checked"

    [
      _ 'div', { class: 'todo' + (if @model.done then 'done' else '') },
        _ '.display',
          _ 'input.check', checkbox_attrs
          _ '.todo-text'
          _ 'span.todo-destory'
        _ '.edit',
          _ 'input.todo-input', { type: "text", value: "" }

      #$(self.el).empty().template(TEMPLATE_URL + '/templates/item.html', self.model.toJSON(), () -> self.setText()
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
