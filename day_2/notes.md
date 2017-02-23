# Haskell Day 2

- http://learnyouahaskell.com/types-and-typeclasses

## Types and Typeclasses
- In Haskell, types are revealed in `ghci` via the `:t` command.
- The `::` literal notates "type of"
  - For example, `:t 'a'` would yield `'a' :: Char` which is to be read as 'a' is type of 'Char'

### As applied to functions
- Just as in mathematics, Haskell functions are defined as a map from input type to output type. 
- Types in Haskell are explicitly written starting with a capital case. 

```haskell
Prelude> removeNonUppercase st = [c | c <- st, c `elem` ['A'..'Z']]
Prelude> :t removeNonUppercase
removeNonUppercase :: [Char] -> [Char]
```

- The above was a good example of Haskell's type inference ability. I did not define the function types in and out before defining the function. To do so in a `.hs` source file, you can just declare `removeNonUppercase :: [Char] -> [Char]` before implementing the function.
	- This is called an "explicit type declaration"
	- It is considered good practice to do this when writing short functions (or maybe even any function in general)
- What happens if there is more than just one parameter going into the function?

```haskell
Prelude> addThree p1 p2 p3 = p1 + p2 + p3
Prelude> :t addThree
addThree :: Num a => a -> a -> a -> a
```

- Remember, in Haskell, functions are expressions too! If you can check the type of an expression with the `:t` command, and a function is an expression, you can try it out in GHCI if you are ever unsure of the type before "comitting" to your implementation. 

### Some common types

- `Int` is an integer, the size will be the standard `int32` on `i386` and `int64` on `x86_64`, but the type remains `Int`
- `Integer` is a bigint type that is not constrained to whatever your common integer limit is on your system.
- `Float` is for floating point numbers with single precision
- `Double` is also a floating point number with double precision
- `Bool` is just a boolean
- `Char` represents a single character, denoted by single quotes. A list of characters is a string, but in Haskell, it is represented as `[Char]`

### Type variables

- Recall the `head` function that we used on collections
	- `head [1,2,3]` yields `1`
	- `head ['a', 'b', 'c']` yields `'a'`
- How can it do this regardless of the type encapsulated in the collection? Let's take a look at what type the `head` function is...

```haskell
Prelude> :t head
head :: [a] -> a
```

- Recalling that earlier we said that all explicit types begin with capital letters, we know immediately that `a` is not a type. It is instead a _type variable_.
	- Type variables in Haskell are generally assigned a letter `a` `b` `c`, etc. 
- Functions that use type variables are _polymorphic_ functions in Haskell. Think of generics in other languages, except much more powerful.
- Let's take a look at some other functions. `fst` and `snd` return the first and second elements of a pair. This is what `ghci` thinks of them...

```haskell
Prelude> fst (1,2)
1
Prelude> :t fst
fst :: (a, b) -> a
```

- All this is saying is that `fst` takes a tuple of type `(a, b)` and returns something that is type `a`.
- What about something even more primitive than that, like the `+` function?

```haskell
Prelude> :t (+)
(+) :: Num a => a -> a -> a
```

- There should be a new symbol appearing, the `=>` is used to denote a _class constraint_.
- This means that any value `a` which is returned by this function should be of typeclass `Num`. 


### Some standard typeclasses

- `Eq` is used for testing equality. The functions its members implement are `==` and `/=`. All types except IO are part of the `Eq` typeclass in Haskell and can be compared, except for functions. 
- `Ord` is for types that have an ordering
	- All types except for functions are typeclassed as an `Ord`
	- Encapsulates all functionality for `>, >=, <, <=`
	- `Ordering` is a type that can be either `GT, LT` or `, EQ`.
	- `Prelude> :t (>) ||| (>) :: Ord a => a -> a -> Bool`
- `Show` can be used to present something as a string. All types except functions are a part of it. The most used function that deals with this typeclass is `show`.
	- `show :: Show a => a -> String`
	- It will take a type that is part of the `Show` typeclass then represent it as a string
	- `show 5` yields `"5"`
- `Read` is essentially the opposite of show. It takes a string and outputs a type that is within the `Read` typeclass.
	- My question: Can this be used to parse JSON, or as some kind of eval mechanism?
	- It seems that ghci doesn't want to execute `read "5"` but it will do so when you specify what type `read` should map to
	- `read "5" :: Int` yields `5`
	- Providing `:: Int` is called a _type annotation_
- `Enums` are sequentially ordered types. They have defined successors and predecessors (e.g. like an enumerator), `succ` and `pred`.
	- Types in this class are: `(), Bool, Char, Ordering, Int, Integer, Float, Double`
- `Bounded` members have upper and lower bounds.
	- All tuples that have members that are `Bounded` are also by extension of the same `Bounded` type
	- `maxBound` is a function that can be used to determine the bounds of a type, `minBound` the min.
		- `Prelude> maxBound :: Int` = `9223372036854775807` for x86_64
		- `maxBound :: Bounded a => a` is the `:t` signature for this function
		- It takes a type parameter of a `Bounded` and returns the highest value of that type
- `Num` is a numeric typeclass, its members have the capacity to act like numbers.
	- `Float, Int, Integer, Double` are all `Num` typeclassed.
	- Notice that mathematical functions like `(+)` work with all numerics: `(+) :: Num a => a -> a -> a`
	- To be a `Num`, a type must also be `Show` and `Eq` (you can show and compare them)
- `Integral` is a subclass of `Num` but only encapsulates whole (read: real and integral) numbers such as `Int` or `Integer`
- `Floating` is a subclass of `Num` for `Float` and `Double`-like typeclassesad

### Misc

The book says that `fromIntegral` is useful for dealing with numbers because it makes the interoperability of `Floating` and `Integral` numbers easier. Let's take a look at the function's type signature.

```haskell
Prelude> :t fromIntegral
fromIntegral :: (Num b, Integral a) => a -> b
```

It appears to take a `Numeric` `b` and an `Integral` `a`, but it returns a `Numeric`. This might not seem super useful at first, but let's try to add a `Floating` to a `Integral`. 

```haskell
-- Length is a Integral type
length [1,2,3] + 4.20
```

Attempting to do this in GHCI will yield a type issue. What if we use `fromIntegral` to "upcast" the `Integral` into an instance of its superclass?

```haskell
Prelude> fromIntegral 4
4
Prelude> foo = fromIntegral 4
Prelude> :t foo
foo :: Num b => b
```

OK, looks straightforward enough, let's try it now:

```haskell
Prelude> fromIntegral (length [1,2,3]) + 4.20
7.2
```

It worked!!!