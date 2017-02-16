# Haskell Day 1

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

