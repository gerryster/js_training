define -> ->
  __ = -> throw 'Implement ME!'

  describe 'Learning CoffeeScript', ->

    describe 'a sort function', ->
      # write the sort function:
      #
      # Hint: if you don't want to write a sort function from scratch see
      # http://documentcloud.github.com/underscore/#sortBy.  All of the
      # underscore methods are available in this context from the "_" variable.
      #
      # Also note that CoffeeScript does not have the ternary operator
      # (foo ? "bar": "baz") but (if foo then "bar" else "baz") works.
      sortMe = (list, ascending)->
        _.sortBy list, (num)->
          if(ascending) then num else -num

      it "ascending", ->
        expect(sortMe([1,5,2,-3], true)).toEqual [-3,1,2,5]
      it "descending", ->
        expect(sortMe([1,5,2,-3], false)).toEqual [5,2,1,-3]

    it "combines two objects and creates arrays for colliding keys", ->
      object1 =
        a: "Aye"
        b: "Bee"
      object2 =
        b: "Buzz"
        c: "Cool"

      # write the union function:
      #
      # Hint: read about the "of" operator in http://coffeescript.org/#loops .
      # Also, JavaScript objects can be treated very similar to Ruby hashes so
      # keys can be dynamically retrieved at runtime with the following syntax:
      #  value = object["property"]
      union = (a,b) ->
        result = {}
        result[key] = value for key, value of a

        for key,value of b
          if result[key] is undefined
            result[key] = value
          else
            valueArray = [result[key], value]
            result[key] = valueArray
        return result

      expect(union(object1, object2)).toEqual a: "Aye", b: ["Bee", "Buzz"], c: "Cool"

