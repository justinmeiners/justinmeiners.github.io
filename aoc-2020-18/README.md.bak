Advent of Code 2020 Day 18: Rethinking Operator Precendence
===========================================================

**12/27/20**

Part 2 of  [AOC Day 18][1] asks 
you to evaluate some math expressions, but with a twist.
`+` has a greater operator precendence than `*`.
(This is opposite of how we typically read math):

    2 * 3 + (4 * 5)
    2 * 3 + 20
    2 * 23
    46

The standard method for expression evaluation is the [shunting yard][2] algorithm.
This is the *right* and efficient way to solve this problem.
But, it's also not very obvious or natural.
It's hard to imagine how you would think if it yourself,
and doesn't really match how people actually see mathematical expressions.

I want to show off an alternative solution demonstrating
how you could think of it yourself.
This approach is quite "lispy", making heavy use of a symbol/expression
tree manipulation and would be harder in some languages than others.

**Thinking about Precendence**

What does operator precedence actually mean?
It tells us the *order in which to evaluate operators*.
So naively we should just do all the additions first, and then the multiplications.
Can we program that?
We certainly can, but doing just one operation at a time,
means at each step we produce an intermediate result which is itself a math expression, just simplified a bit.
For example given the expression:

     (1 + 2 * 3 + 4)

We first evaluate all the `+` to produce:

    (3 * 7)

And then we evaluate all the '*' to produce:

    (21)

After evaluting every operator, we should get a list containing a single number.

Below is some code which does just that.
The input `chain` is an expression (list of numbers and operators)
and `allowed` is the operator we want to evaluate.
    
    (defun simplify-chain (chain allowed)
      (prog ((result '())
             (op nil)
             (l nil)
             (r nil))

            (setf l (car chain))
            (setf chain (cdr chain))

            loop
            (setf op (car chain))
            (setf chain (cdr chain))

            (setf r (car chain))
            (setf chain (cdr chain))

            (if (eq op allowed)
                
                ; evaluate the operation.
                ; put the result back in the expression

                (setf l (funcall op l r))

                ; not an operation we want to evaluate right now.
                ; put it's symbols back in an the expression
                (progn (push l result)
                       (push op result)
                       (setf l r)))

            (if (consp chain)
                (go loop))

            (push l result)
            (return (reverse result))))

**Handling Parenthesis**

That is quite straightforward! 
All the trickiness is fiddling with infix.
But, there is one problem.
Due to paranthesis the operands may not be "ready" to evaluate.
If we have:

    3 + (2 * 4)

We can't apply the `+` operation until the `(2 * 4)` is taken care of.
But evaulating `(2 * 4)` is something we could do directly.
There are only finitely many nested
statements, so eventually following paranthesis must end with a list containing only numbers and operators.
This is clearly a recursive problem!
We need to evaluate all the paranthesized statements in a list, before we can evaulate
the list itself.


The algorithm for evaulation looks like the following:

- To evaluate a number or symbol, just return it. (base case)
- To evaluate a list:

  1. evaluate every entry in the list. (take care of paranthesis)
  2. simplfy the expression by appyling each operator in order. (simplify chain)
  3. Return the only item left in the list.

Let's write an eval function which does this, building upon simplify chain:

    (defun eval-expr (expr)
      (if (listp expr)
            (car (reduce #'simplify-chain 
                         '(+ *)
                         :initial-value (mapcar #'eval-expr expr)))
            expr))

To summarize `simplify-chain` takes mathematical expressions
and returns expressions that are simpler, while `eval-expr` always returns a number.
Note that this works for any number of operators and adjusting
precendence is as simple as changing the order of the `'(+ *)` list.


[1]: https://adventofcode.com/2020/day/18
[2]: https://en.wikipedia.org/wiki/Shunting-yard_algorithm
