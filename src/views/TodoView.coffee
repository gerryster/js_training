define [], ()->
  TodoView = Backbone.View.extend
    tagName:  "li",

    events: {
      "click .check"        : "toggleDone",
      "dblclick div.todo-text"  : "edit",
      "click span.todo-destroy"   : "clear",
      "keypress .todo-input"    : "updateOnEnter"
    }

    initialize: ->
      this.model.bind('change', this.render, this)
      this.model.bind('destroy', this.remove, this)

    render: ->
      self = this
      
      $(self.el).empty().template(TEMPLATE_URL + '/templates/item.html', self.model.toJSON(), () -> self.setText()
      )
      
      return this

    setText: ->
      text = this.model.get('text')
      this.$('.todo-text').text(text)
      this.input = this.$('.todo-input')
      this.input.bind('blur', _.bind(this.close, this)).val(text)

    toggleDone: ->
      this.model.toggle()

    edit: ->
      $(this.el).addClass("editing")
      this.input.focus()

    close: ->
      this.model.save({text: this.input.val()})
      $(this.el).removeClass("editing")

    updateOnEnter: (e)->
      if (e.keyCode == 13)
        this.close()

    remove: ->
      $(this.el).remove()

    clear: ->
      this.model.destroy()
