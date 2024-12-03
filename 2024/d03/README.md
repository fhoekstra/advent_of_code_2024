# No Nix solution?

This one is a classic regex problem, of which there's often a few with Advent Of Code.
While it seems like Nix has excellent regex-matching capabilities for paths (which are a separate type in Nix), the regex functions for strings are very lackluster.

The `builtins.match` function needs a pattern that matches the whole string, or it won't match anything. I have not found a `matchAll`.
I looked for advice on escaping (the advice was: use `''`, don't use backslashes, just use character classes for literals (like: `[(]`)), and then after a while I had made this, which only matched the last instance in the example (`"8,5"`):

```
nix-repl> with builtins; with { example_str=''xmul(2,4)%&mul[3,7]!@do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))'';}; match (''.*mul[(]([0-9]+,[0-9]+)[)].*'') example_str
> "8,5"
```

No problem, right? Just make the `.*` lazy by adding a `?` after the `*`. That's where I got stuck. Adding any question mark to the pattern causes a pattern invalid error.

So that's why this day is in Python.
