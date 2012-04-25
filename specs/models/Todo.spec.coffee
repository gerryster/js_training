define -> ({loadModule})->

  beforeEach ->
    # Define how the Todo module and it's dependencies should be loaded.  In
    # this case, Todo does not have any dependencies.  The code below is a
    # CoffeeScript shorthand for:
    #
    # loadModule (Todo) ->
    #   this.Todo = Todo
    #
    # The "fat" arrow (=>) tells CoffeeScript to use our "this" for the
    # callback and the @Todo as a function parameter is a shorthand for
    # automatically assigning that parameter as a member variable.
    loadModule (@Todo)=>

  describe 'model (Todo)', ->
    it 'A Model can have default values for its attributes.', ->
      todo = new @Todo()

      defaultAttrs =
        text: '',
        done : false,
        order: 0

      expect(defaultAttrs).toEqual(todo.attributes)

    it 'Attributes can be set on the model instance when it is created.', ->
      todo = new @Todo({ text: 'Get oil change for car.' })

      expectedText = 'Get oil change for car.'

      expect(expectedText).toEqual(todo.get('text'))

    it 'If it is exists, an initialize function on the model will be called when it is created.', ->
      todo = new @Todo({ text: 'Stop monkeys from throwing their own feces!' })

      # Why does the expected text differ from what is passed in when we create the Todo?
      # What is happening in Todo.initialize?
      # You can get this test passing without changing todos.js or the expected text.

      expect('Stop monkeys from throwing their own double rainbows!').toBe(todo.get('text'))

    it 'Fires a custom event when the state changes.', ->
      callback = jasmine.createSpy('-change event callback-')

      todo = new @Todo()

      todo.bind('change', callback)

      # How would you update a property on the todo here?
      # Hint: http://documentcloud.github.com/backbone/#Model-set
      todo.set('done', true)

      expect(callback).toHaveBeenCalled()

    it 'Can contain custom validation rules, and will trigger an error event on failed validation.', ->
      errorCallback = jasmine.createSpy('-error event callback-')

      todo = new @Todo()

      todo.bind('error', errorCallback)

      # What would you need to set on the todo properties to cause validation to fail?
      # Refer to Todo.validate in js/todos.js to see the logic.
      todo.set('done', 'bogus')

      errorArgs = errorCallback.mostRecentCall.args

      expect(errorArgs).toBeDefined()
      expect(errorArgs[0]).toBe(todo)
      expect(errorArgs[1]).toBe('Todo.done must be a boolean value.')