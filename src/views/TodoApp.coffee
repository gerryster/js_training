define [], ()->

  on: # similar to the events method in Backbone.View
    #"keypress #new-todo":  "createOnEnter"
    "keyup #new-todo": (event) -> this.showTooltip(event)

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
    console.log("in showTooltip")
    tooltip = this.$(".ui-tooltip-top")
    val = @input.val()
    
    tooltip.fadeOut()
    
    if (this.tooltipTimeout)
        clearTimeout(this.tooltipTimeout)
    if (val == '' || val == this.input.attr('placeholder'))
       return
    
    show = -> tooltip.show().fadeIn()
    
    this.tooltipTimeout = _.delay(show, 1000)
