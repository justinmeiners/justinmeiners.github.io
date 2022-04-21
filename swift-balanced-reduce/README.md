Swift Proposal: Balanced Binary Reduction
=========================================

**By:** Justin Meiners
**06/14/2021**

## Introduction

Swift's `reduce` can be used to accumulate elements in a sequence.
For example:
    
    [1.0, 2.0, 3.0, 4.0].reduce(0.0, +)

If we visualize the expression tree for this operation
it's essentially linear.
You can think of it as a binary tree which is completely unbalanced.

     -----3.0----6.0---10.0
    /     /      /    /
    1.0   2.0   3.0  4.0


Assuming the binary operation is associative then we can choose which
order to evalulate arguments in.
For example, we could image a function `balancedReduce` which rearranges
the order of evaluation to the following:


          10.0
        /      \
       /         \
      3.0       7.0
     /  \      /    \
    1.0  2.0  3.0  4.0


We haven't changed the result at all, just the order it's evaluated in.
It's mathematically equivalent.
However, there are lot's
of good computational reasons why one might want to do this.

## Example Applications

These are just a few to illustrate it is a general problem:

1. Adding up many floating point results (as in my example above).
   Adding small numbers to larger numbers produced poor numerical results.
   Given a long enough list of values of similar magnitutdes
   this is guarenteed to happen.
   
   In contrast a balanced evaluation of such values will
   only add similarly sized values. (Intermediate results which are
   the result of adding equal numbers of values together).

2. Merge sort can be written by applying the binary operation
   of "merge sorted list" to a sequence of lists:

       [ [a1], [a2], ... [an] ]

    If you do this with `reduce` it is essentially insertion sort,
    one element is inserted into the growing list at a time.
    If you use a `balancedReduce` it will only merge lists
    that are roughly the same size, giving a proper
    `O(n log(n))` merge.

3. It can be used to solve the problem of finding the smallest
   element, and second smallest element, in a sequence
   in the optimal number of comparisons.
   (Described in 5.3.3 of Volume 3 of Art of Computer Programming).

## Proposed changes.

This capability can be added with a simple extension to `Sequences`
of `Equatable` types.

    extension Sequence where Element: Equatable {
        func balancedReduce(
            zero: Element,
            operation op: (Element, Element) -> Element
        ) -> Element{
            var counter = Array(repeating: zero, count: 32)
            
            for x in self {
                let carry = BinaryCounter.add(to: &counter,
                                              x: x,
                                              zero: zero,
                                              operation: op)
                
                assert(carry == zero, "reduced too many things")
            }
     
            return BinaryCounter.reduce(counter: &counter,
                                        zero: zero,
                                        operation: op)
        }
    }

    struct BinaryCounter {
        private init() {}
        
        static func add<C: MutableCollection>(
            to counter: inout C,
            x: C.Element,
            zero: C.Element,
            operation op: (C.Element, C.Element) -> C.Element
        ) -> C.Element where C.Element: Equatable {
            
            var i = counter.startIndex
            let end = counter.endIndex
            
            var carry = x
            while i != end {
                if counter[i] == zero {
                    counter[i] = carry
                    return zero
                }
                
                carry = op(counter[i], carry)
                counter[i] = zero
                i = counter.index(after: i)
            }
            
            return carry
        }
        
        static func reduce<C: MutableCollection>(
            counter: inout C,
            zero: C.Element,
            operation op: (C.Element, C.Element) -> C.Element
        ) -> C.Element where C.Element: Equatable {
            
            var i = counter.startIndex
            let end = counter.endIndex
            
            // find first non-zero
            while i != end && counter[i] == zero {
                i = counter.index(after: i)
            }
            
            if i == end {
                return zero
            }
            
            var x = counter[i]
            i = counter.index(after: i)
            assert(x != zero)

            while i != end {
                if counter[i] != zero {
                    x = op(x, counter[i])
                }
                i = counter.index(after: i)
            }
            
            return x
        }
    }



The implentation is very efficent, adding very few additional
computaitons and using an additional piece of memory, roughly
of size `log(n)`.

## Application examples


This implementation of merge sort
is just for fun to show how it works.

    func mergeSorted<T>(
        _ a: [T],
        _ b: [T]
    ) -> [T] where T: Comparable  {
        var i = a.startIndex
        var j = b.startIndex
        
        var out: [T] = []
        
        while i != a.endIndex && j != b.endIndex {
            if b[j] < a[i] {
                out.append(b[j])
                j = a.index(after: j)
            } else {
                out.append(a[i])
                i = a.index(after: i)
            }
        }
        
        if j != a.endIndex {
            out.append(contentsOf: b.suffix(from: j))
        } else {
            out.append(contentsOf: a.suffix(from: i))
        }
        
        return out
    }
    
    func mergeSort<S: Sequence>(
        _ items: S
    ) -> [S.Element] where S.Element: Comparable {
        
        let singletons: [[S.Element]] = items.map { [$0] }
        let zero: [S.Element] = []
        
        return singletons.balancedFold(zero: zero, operation: mergeSorted)
    }


## Questions/Concerns

**It's too theoretical**

All of the theory is hidden inside,
outside it looks like just `fold`/`reduce`.
If you don't know what it does, it still gives expected results.


Furthmore, it can be benefecial even if you don't
copmletely understand it.
For example, advice could be given to "use this one to add up large lists of `float`"
and it would benefit them.

**The zero parameter is weird. Should it be nil instead?**

I am unsure.
My assumption was that introducing `nil` in the intermediate
computation adds a lot of boxing/unboxing.

**The name is bad/wrong**

I am not attached to the name and happy to hear recommendations.

**Can we make the 32/64 parameter less arbitary?**

Of course `2^64` is the max of a 64 bit integer.
Arrays of more than `2^64` elements are probably already disallowed.
That's assuming every element is a byte,
so `2^32` seems like a reasonable upper bound assumption for the size
of a sequence.

It could be a parameter, although this seems like a messy detail
to expose.

## References

I learned about this techinque from Alex Stepanov, the author 
of C++ STL.
It is described in the book ["Elements of Programming"][eop]
chapter 11.2.

There is a related concept in C++.
[std::accumlate][std-accumulate] 
does a normal left fold,
[std::reduce][std-reduce]
is allowed to associate its arguments 
in any order it prefers.
It additionally requires the operation is commutative,
which I do not think is necessary for this.
It appears `std::reduce` is primarily to facilitate parallel
computation, but it demonstrates two similar operations
whose results only differ on their association order.

[eop]: http://elementsofprogramming.com/
[std-accumulate]: https://en.cppreference.com/w/cpp/algorithm/accumulate
[std-reduce]: https://en.cppreference.com/w/cpp/algorithm/reduce

