define -> ->
  _ = -> throw 'Implement ME!'

  describe 'Learning CoffeeScript', ->

    it "Write a sort function", ->
      # write the sort function:
      sortMe = _

      expect(sortMe([1,5,2])).toEqual [1,2,5]

    it "combines to objects and creates an array for colliding keys", ->
      object1 =
        a: "Aye"
        b: "Bee"
      object2 =
        b: "Buzz"
        c: "Cool"

      # write the union function:
      union = _

      expect(union(object1, object2)).toEqual a: "Aye", b: ["Bee", "Buzz"], c: "Cool"

