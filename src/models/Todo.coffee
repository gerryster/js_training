define [], ()->
  # exercise{{{ NAUGHTY_WORDS = /crap|poop|hell|frogs/gi
  NAUGHTY_WORDS = /crap|poop|hell|frogs|feces/gi
  # }}}exercise

  sanitize = (str) ->
    str.replace(NAUGHTY_WORDS, 'double rainbows')

  Todo = Backbone.Model.extend
    defaults: ->
      text: '', # exercise{{{
      done:  false,
      # }}}exercise
      order: 0

    initialize: ->
      this.set({text: sanitize(this.get('text'))}, {silent: true})

    validate: (attrs)->
      if (attrs.hasOwnProperty('done') && !_.isBoolean(attrs.done))
        return 'Todo.done must be a boolean value.'

    toggle: ->
      this.save({done: !this.get("done")})

  # TODO(rgerry): do not assign TODO to window and fix the TodoList tests to
  # load this module.
  window.Todo = Todo
  return Todo