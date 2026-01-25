---
pagetitle: Fram Programming Language
description-meta:
  Fram, an experimental programming language with lexical algebraic effects
  and named parameters. It is being developed at the University of Wrocław.
title: Fram
abstract: |
  An experimental programming language equipped with lexical algebraic
  effects and a powerful named parameter mechanism. Fram is currently being
  developed at the [Institute of Computer Science, University of
  Wrocław](https://ii.uni.wroc.pl).
link-standout:
  title: Feature Overview
  url: "#features"
links-nav:
  - title: Tutorial
    url: "https://doc.fram-lang.org/intro/installation.html"
  - title: Reference Manual
    url: "https://doc.fram-lang.org/ref/notation.html"
  - title: Implementation
    url: "https://github.com/fram-lang/dbl"
---

## Features

Fram is a functional programming language with its roots in the ML family of
languages, and the basic syntax should feel familiar to programmers comfortable
with languages such as OCaml or SML. Following in that tradition, Fram is
strongly typed and features type inference and let-polymorphism.
```fram
let id x = x
let p = (id 42, id True)
```

Building on this well-established foundation, Fram also implements [lexical
algebraic effects](#algebraic-effects) and has a unique take on [named
parameters](#named-parameters).

### Named Parameters

Named parameters are used in Fram to express a wide variety of language
features through a uniform and simple mechanism. It subsumes named function
parameters, optional parameters, implicit parameters, named type parameters
and explicit type application, records, and even a form of module functors.

In line with standard ML-polymorphism, identifiers in Fram have schemes.
For example, the scheme of `id` above is `{type X} -> X -> X`{.fram},
where `{type X} -> ...`{.fram} indicates that `id` is polymorphic,
and binds `X`{.fram} within the type following `->`.
Each use of `id` is then automatically instantiated with an appropriate type.

Instead of relying on ML-polymorphism, it is possible to write an equivalent
definition that binds the type parameter explicitly in curly braces.
```fram
let id {type X} (x : X) = x
```

Unlike many popular languages, Fram supports *named* type parameters.
The previous syntax `{type X}`{.fram} denotes an *anonymous* type parameter,
such that the name `X`{.fram} is not accessible to the users of the function.
If the programmer instead writes `{X}`{.fram}, the parameter can be optionally
used to explicitly instantiate the function with the desired type. This
explicit type application is similarly written in curly braces, as follows.
```fram
let id {X} (x : X) = x

let p = (id {X=Int} 42, id {X=Bool} True)

# The type can still be inferred.
let x = id 42
```

The braces syntax is more versatile than that, however. It is also used
for regular named parameters.
```fram
let linear {a : Int, b : Int} x = a * x + b

let const b = linear {b, a = 0}
```

All named parameters must be provided, and the code below is invalid.
```fram
linear {b = 42} # Error!
```

However, optional parameters can be used if it should be possible to omit
the argument.
```fram
let greet {?name} () =
  match name with
  | Some n => "Hello, " + n + "!"
  | None   => "Hello, world!"
  end

let greeting = greet () # "Hello, world!"
```

```fram
let foo {~n} = ~n

let baz x =
    let ~n = 42
    # ~n is passed implicitly.
    1 + x + foo
```

For more information on Fram's named parameter mechanism, head over to the
[named parameter tutorial](https://fram-lang.org/intro/named-parameters.html).

### Algebraic Effects

As one of the main design goals, Fram supports algebraic effects with lexical
effect handlers. These offer a generalization of many control flow mechanisms,
such as exceptions, generators, and coroutines.

Programmers can define custom effects.
