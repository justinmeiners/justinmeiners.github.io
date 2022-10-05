# Almost Solving the Halting Problem

By: [Justin Meiners](https://github.com/justinmeiners)

The halting problem is to devise a method that can determine whether a given
Turing machine terminates in a finite amount of time. It is well-known to be
undecidable; no such method exists.

So if you ever come across a proof that solves it, you better be concerned.
In my master's thesis, I did just that. It turns out I didn't make a major
mistake, but I discovered that incompatibility is quite a subtle thing. The
details of the particular problem aren't important. They can be explained by
studying Turing machines themselves.

A Turing machine has a tape, a read/write head, and a finite state machine
controlling the head:

![a depiction of a turing machine](turing-machine.png)

My idea for solving the halting problem was to run the machine for some large
number of steps, then stop and conclude anything that runs longer must not
terminate. You might say there is no way to determine such a bound, but there
actually is.

A Turing machine has only finitely many non-blank squares. For a fixed state
machine `Q` and alphabet `S`, define `A(n, Q, S)` to be the set of Turing
machines in `Q` and `S` that halt and have exactly `n` non-blank squares. There
are at most `|S|^n` of these, so `A(n, Q, S)` is a finite set. So if we then let
`l(t)` be the number of steps `t` runs, `{ l(t) : t in A(n, Q, S) }` is finite
and thus has a maximum `M`.

So given any Turing machine with this criteria, we can run it for `M` steps, and
if it goes longer, then we know it will never terminate! We can even define a
function `f(S, Q, N)` which is the approximate `M` value for our inputs!

So why can't we do this? Well, we would actually have to be able to compute `f`
with a procedure. Even easier, just compute a function that bounds `f`. Since it
is impossible, we must conclude that `f` is larger than any of the functions we
can compute. Polynomials, exponentials, none are big enough. Maybe our program
could include a lookup table, but this would require infinite space and is not a
method at all.

This shows us that uncomputability is primarily a problem of growing too
quickly, not any kind of tricky correspondence. This also suggests why the
Ackermann function requires more sophisticated models of computation.

## References

Minsky Computation: finite and infinite machines. Chapter 8.
