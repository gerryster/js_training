define [], ()->
  render: (_)-> [
    _ '.title',
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
