# global $, _, Backbone
TEMPLATE_URL = ''

NAUGHTY_WORDS = /crap|poop|hell|frogs|feces/gi

sanitize = (str) ->
    str.replace(NAUGHTY_WORDS, 'double rainbows')

window.Todo = Backbone.Model.extend(
    defaults: ->
        text: '',
        done:  false,
        order: 0
    
    initialize: ->
        this.set({text: sanitize(this.get('text'))}, {silent: true})
    
    validate: (attrs)->
        if (attrs.hasOwnProperty('done') && !_.isBoolean(attrs.done))
            return 'Todo.done must be a boolean value.'

    toggle: ->
        this.save({done: !this.get("done")})
)

window.TodoList = Backbone.Collection.extend(

    model: Todo
    
    url: '/todos/'

    done: ->
        this.filter (todo) ->
            todo.get('done')

    remaining: ->
        this.without.apply(this, this.done())
    
    nextOrder: ->
        if (!this.length)
            return 1

        this.last().get('order') + 1

    comparator: (todo)->
        todo.get('order')
)

window.TodoView = Backbone.View.extend(
    tagName:  "li",

    events: {
        "click .check"              : "toggleDone",
        "dblclick div.todo-text"    : "edit",
        "click span.todo-destroy"   : "clear",
        "keypress .todo-input"      : "updateOnEnter"
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
    )

window.TodoApp = Backbone.View.extend(
    todos: new TodoList()

    events:
        "keypress #new-todo":  "createOnEnter"
        "keyup #new-todo":     "showTooltip"
        "click .todo-clear a": "clearCompleted"

    initialize: (options)->
        console.log("in TodoApp.initialize")
        self = this
        parentElt = options.appendTo || $('body')
            
        TEMPLATE_URL = options.templateUrl || TEMPLATE_URL
        
        parentElt.template(
            TEMPLATE_URL + '/templates/app.html'
            {}
            ->
                self.setElement($('#todoapp'))
                
                self.input = self.$("#new-todo")

                self.todos.bind('add',   self.addOne, self)
                self.todos.bind('reset', self.addAll, self)
                self.todos.bind('all',   self.render, self)

                self.todos.fetch()
        )

    render: ->
        self = this
        data = {
            total:      self.todos.length
            done:       self.todos.done().length
            remaining:  self.todos.remaining().length
        }
        
        $('#todo-stats').empty().template(TEMPLATE_URL + '/templates/stats.html', data)
        
        return this

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

    showTooltip: (e)->
        tooltip = this.$(".ui-tooltip-top")
        val = this.input.val()
        
        tooltip.fadeOut()
        
        if (this.tooltipTimeout)
            clearTimeout(this.tooltipTimeout)
        if (val == '' || val == this.input.attr('placeholder'))
           return
        
        show = -> tooltip.show().fadeIn()
        
        this.tooltipTimeout = _.delay(show, 1000)
)