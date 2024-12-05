# No Nix solution?

This one is a classic regex problem, of which there's often a few with Advent Of Code.
~While it seems like Nix has excellent regex-matching capabilities for paths (which are a separate type in Nix), the regex functions for strings are very lackluster.~

I wrangled with `builtins.match` for a while, which is not ideal: it needs to match the whole string, and thus cannot return multiple matches for a single match group. It also apparently has a problem with `?` or lazy evaluation.
I completely missed `lib.split`, which [@ellyxir](https://github.com/ellyxir) [pointed out to me](https://github.com/fhoekstra/advent_of_code_2024/issues/1) after I had given up on regex in Nix and done this one in Python. `lib.split` has none of the problems that `builtins.match` has.

So that's why this day is in Python.
