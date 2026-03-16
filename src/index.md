---
pagetitle: Fram Programming Language
description-meta:
  Fram, an experimental programming language with lexical algebraic effect
  handlers and named parameters. It is being developed at the University of
  Wrocław.
title: Fram
abstract: |
  An experimental programming language equipped with lexical algebraic
  effect handlers and a powerful named parameter mechanism.
  Fram is currently being developed at the
  [Institute of Computer Science, University of Wrocław](https://ii.uni.wroc.pl).
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
  - title: Publications
    url: "/publications.html"
---

:::landing-features
## Features

Fram is a functional programming language with its roots in the ML family of
languages. As one of the design goals, we strive for a small set of features
that can express a wide range of programming constructs. Here we briefly
describe some of these features.

### Named Parameters

Many programming languages provide named function parameters, but Fram takes
this mechanism further by incorporating multiple language features into a
uniform named parameter mechanism.
These include regular named parameters, type parameters, optional parameters,
implicit parameters, records, and even module functors.
Additionally, using sections, you can declare your parameters once but use them
in several definitions.

For details, check out the tutorial sections on
[named parameters](https://doc.fram-lang.org/intro/named-parameters.html)
and
[modules](https://doc.fram-lang.org/intro/modules.html).

### Effect System

Apart from types, Fram statically tracks all side effects in a program,
ensuring effect safety. However, thanks to effect inference, the programmer
usually doesn't need to bother writing out effect annotations.
To learn the basics of Fram's effect system, see the
[effects tutorial](https://fram-lang.org/intro/effects.html).


### Algebraic Effects

Fram implements algebraic effect handlers, which can express computational
effects such as mutable state, exceptions, generators, backtracking, and
lightweight threads.
Since the code that uses the effect can be defined separately from
the effect's implementation (given by a handler), this approach
lends itself well to modularity and reuse.

Because Fram's effect handlers are lexically scoped, we avoid the risk
of accidental effect capture by a handler, further enhancing modularity.
And thanks to implicit parameters, no tedious parameter passing is needed
in order to connect the use of an effect with the correct handler.

For more information, see the tutorial section on
[effect handlers](https://doc.fram-lang.org/intro/effect-handlers.html).

:::

:::landing-code
```fram
{# Find Pythagorean triples. #}

data BT E =
  { flip : Unit ->[E] Bool
  , fail : {X} -> Unit ->[E] X
  }

method rec select (self : BT _) a b =
  if a > b then self.fail ()
  else if self.flip () then a
  else self.select (a + 1) b

parameter ~bt : BT _

let triples n =
  let a = ~bt.select 1 n
  let b = ~bt.select a n
  let c = ~bt.select b n
  in
  if a * a + b * b == c * c
  then (a, b, c)
  else ~bt.fail ()

let allTriples n =
  handle ~bt = BT
    { effect fail () = []
    , effect flip () =
        resume True + resume False
    }
    return triple => [triple]
  in
  triples n
```
:::
