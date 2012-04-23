define -> ({loadModule})->

  beforeEach ->
    loadModule
      # stub out the LocalStorage dependency by returning an empty object:
      'helpers/LocalStorage': -> {}
      (@TodoList)=>

  describe 'collection (TodoList)', ->
    it 'Can add Model instances as objects one at a time, or as arrays of models.', ->
      todos = new @TodoList()

      expect(todos.length).toBe(0)

      todos.add({ text: 'Clean the kitchen' })

      expect(todos.length).toEqual(1)

      # How would you add multiple models to the collection with a single method call?
      todos.add([{ text: 'Clean the kitchen' }, { text: 'task 2'}])

      expect(todos.length).toEqual(3)

    it 'Can have a comparator function to keep the collection sorted.', ->
      todos = new @TodoList()

      # Without changing the sequence of the Todo objects in the array, how would you
      # get the expectations below to pass?
      #
      # How is the collection sorting the models when they are added? (see TodoList.comparator)
      #
      # Hint: Could you change attribute values on the todos themselves?

      todos.add([{ text: 'Do the laundry',  order: 2},
                 { text: 'Clean the house', order: 1},
                 { text: 'Take a nap',      order: 3}])

      expect(todos.at(0).get('text')).toEqual('Clean the house')
      expect(todos.at(1).get('text')).toEqual('Do the laundry')
      expect(todos.at(2).get('text')).toEqual('Take a nap')

    # How are you supposed to know what Backbone objects trigger events? To the docs!
    # http://documentcloud.github.com/backbone/#FAQ-events
    it 'Fires custom named events when the contents of the collection change.', ->
      todos = new @TodoList();

      addModelCallback = jasmine.createSpy('-add model callback-')
      todos.bind('add', addModelCallback)

      # How would you get both expectations to pass with a single method call?
      todo = new Todo({text: 'pass this test'})
      todos.add(todo)

      expect(todos.length).toEqual(1)
      expect(addModelCallback).toHaveBeenCalled()

      removeModelCallback = jasmine.createSpy('-remove model callback-')
      todos.bind('remove', removeModelCallback)

      # How would you get both expectations to pass with a single method call?
      todos.remove(todo)

      expect(todos.length).toEqual(0)
      expect(removeModelCallback).toHaveBeenCalled()