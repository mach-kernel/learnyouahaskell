# Haskell Day 1

- http://learnyouahaskell.com/starting-out

## Gotchas
- There is no `!=`, it is just `/=`

## Function Invocation

- Use space literals to apply parameters to functions
  - `foo a b` -> `foo(a, b)`
  - The latter is _not_ valid Haskell!
- To convert operators that are otherwise postfix to infix, you can use the ``` backtick literal
  - `div 100 10` ->  `100 `div` 10`
- Infix operators are just aliases for functions that do the computation
	- `(+) 1 1` -> `1 + 1`
- Use parens to separate units of invocation
	- `foo(bar(baz))` -> `foo (bar baz)`

## Lists

- Lists look like this `[1,2,3,4]`
- The above is syntatic sugar for `1:2:3:[]`
	- "Append 3 to empty array, 2 to result, 1 to result"
- Lists are a homogenously typed data structures
	- You may only have lists of the same type
	- If you are wrapping lists of lists, the types that they encapsulate must all be the same. That is, a list of lists of strings may only be that.
- Strings are just syntatic sugar for lists of characters
	- All functions that apply to lists also apply to strings!
	- `head "foobar"` -> `f`
- Helpful list methods
	- `take` will pop the head off of the list and provide its value
	- `drop` will pop the head off of the list and return the remainder of the list
	- `maximum` and `minimum` work as expected
	- Set membership can be checked by invoking the `elem` function.
		- It is a common pattern to invoke `elem` in infix notation, as you are providing it two arguments, the value that you are checking for membership, and the list that you are going to do the lookup on.
		- `elem 1 [1, 2, 3]` -> `True`
		- `1 `elem` [1, 2, 3]` -> `True`

### Ranges

- Range notation looks like that of Ruby's, but it does not work the same way. 
- You can use ranges to construct a List in Haskell
	- `[1..20]` -> `[1,2,3...]`
	- It also works for ASCII character ranges (probably because they are numbers too, it only makes sense?)
		- `['a'..'c']` -> `['a','b','c']`
- You can also mix explicit definition of elements with ranges, so this is valid too!
	- `[1,2,3..5]` -> `[1,2,3,4,5]`
- The author of the book advises you not to use the range notation for floating point numbers due to base 2 -> base 10 imprecision

#### Manipulating Ranges

- Use `cycle` to endlessly loop elements in a repeating list.
	- `cycle [4,5,6]` -> `[4,5,6,4,5,6,4,...]`
	- The loop will never end so it must be sliced off with `take`.
		- Do not use `drop` here as the removing any elements from an infinite set and returning that set will provide you with the same issue you had in the first place!
- In contrast, `repeat` will operate only on one element. If you provide it a list, it will cycle that same list an infinite amount of times.
	- `cycle 1` -> `[1,1,1,1,1,1,1,...]`
	- `cycle [1,2]` -> `[[1,2],[1,2],...]`
	- The author suggests to just use `replicate`
- `replicate (n times) (element)` will replicate the element n times.
	- `replicate 3 5` -> `[5,5,5]`
	- Does `3 `replicate` 5` look cleaner?

### List comprehensions

- Example: Double each number in the set of natural numbers from 1 to 10
	- `[x*2 | x <- [1..10]]` -> `[2,4,6,8,10,12,14,16,18,20]`
- You can add predicates to comprehensions. The previous syntax just says apply anonymous function `x*2` to `x` which should be an element from range `[1..10]`.
	- If we wanted to only apply this comprehension for `x > 10`, we would do this...
	- `[x*2 | x <- [1..15], x > 10]` -> `[22,24,26,28,30]`
	- `x > 10` after the `,` is another anonymous function that returns a `Boolean`
- You can also use as many predicates as you want!
- ...and also use as many lists as you want
	- `[x * y | x <- [1..3], y <- [4..6], x > 1, y > 5]` -> `[12, 18]`
- You can define the list `length` function as a list comprehension
	- `length' x = sum [1 | _ <- x]`
	- The underscore is a placeholder since we do not need to ever define the variable for each element in the list
	- The comprehension will return a list of [1,1,1,1] with `n` elements for each element in the list `x` that is passed in
	- Sum will take a sum of `n` `1`s!
- Can be nested (book example)

```
ghci> let xxs = [[1,3,5,2,3,1,2,4,5],[1,2,3,4,5,6,7,8,9],[1,2,4,2,1,6,3,1,3,2,3,6]]  
ghci> [ [ x | x <- xs, even x ] | xs <- xxs]  
[[2,2,4],[2,4,6,8],[2,4,2,6,2,6]]  
```

### Using list comprehensions to sanitize strings

- This is pretty neat
	- `[ x | x <- "foobarFOOBAR", x `elem` ['A'..'Z']]`
	- "FOOBAR"

## Tuples
- Not homogenous
- Types: `(1,2)` matches type `(3,4)` but not `(1,2,3)` or `(5, 'foo', [1,2])`
- `fst` and `snd` apply to 2-tuples and give the first and second elements, respectively
- `zip` operates on two lists and returns a list of 2-tuples for matching elements (e.g. like how it works in Ruby)
	- `[1,2] `zip` [3,4]` -> `[(1,3), (2,4)]`
	- Haskell is lazy so you can zip infinite lists with finite ones, e.g., `["one", "two"] `zip` [1..]` will yield `[("one", 1), ("two", 2)]`
