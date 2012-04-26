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
      # exercide{{{
      todos.add([{ text: 'Clean the kitchen' }, { text: 'task 2'}])
      # }}}exercise

      expect(todos.length).toEqual(3)

    it 'Can have a comparator function to keep the collection sorted.', ->
      todos = new @TodoList()

      # Without changing the sequence of the Todo objects in the array, how would you
      # get the expectations below to pass?
      #
      # Hint: Backbone collections can define custom comparators:
      # http://documentcloud.github.com/backbone/#Collection-comparator
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
      # exercise{{{
      todo = new @TodoList::model({text: 'pass this test'})
      todos.add(todo)
      # }}}exercise

      expect(todos.length).toEqual(1)
      expect(addModelCallback).toHaveBeenCalled()

      removeModelCallback = jasmine.createSpy('-remove model callback-')
      todos.bind('remove', removeModelCallback)

      # How would you get both expectations to pass with a single method call?
      # exercise{{{
      todos.remove(todo)
      # }}}exercise

      expect(todos.length).toEqual(0)
      expect(removeModelCallback).toHaveBeenCalled()

    describe 'remaining', ->
      it 'returns the empty list for no todos', ->
        expect(new @TodoList().remaining().length).toEqual 0

      it 'returns the empty list for one done todos', ->
        todos = new @TodoList()
        todos.add { done: true }
        expect(todos.remaining().length).toEqual 0

      it 'returns the todo for one unfinished todo', ->
        todos = new @TodoList()
        unfinished = new @TodoList::model {text: "not done", done: false}
        todos.add unfinished
        expect(todos.remaining().length).toEqual 1
        expect(todos.remaining()).toEqual [unfinished]

      it 'returns the unfinished todos given a list of finished an unfinished todos', ->
        todos = new @TodoList()
        unfinished1 = new @TodoList::model {text: "not done 1", done: false}
        todos.add unfinished1
        todos.add new @TodoList::model {text: "finished 1", done: true}
        unfinished2 = new @TodoList::model {text: "not done 2", done: false}
        todos.add unfinished2
        todos.add new @TodoList::model {text: "finished 2", done: true}

        expect(todos.remaining().length).toEqual 2
        expect(todos.remaining()).toEqual [unfinished1, unfinished2]
