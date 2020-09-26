# Understanding LINQ GroupBy

C# programmers are typically familiar with  `Select`, `Where`, and `Aggregate`, the LINQ equivalents of the core functional programming
operations `map`, `filter`, and `reduce`. 
But the equally important `GroupBy` isn't as well understood or often used.
Although you may guess from the name, the problem `GroupBy` solves is the following:
Given a list of items, we want to arrange the items so that equal elements are together.

For example, given a list of `Student` objects,
we may want to group them by `student.teacher`, and then obtain a list of `student.id`
corresponding to each teacher.

`GroupBy` is a beautiful piece functional programming which allows work to be specified in terms of "what"
should happen as opposed to "how" to do it.
It combines harmoniously with the other LINQ operations
leading to cleaner code that can be combined in modular ways.

### How to use GroupBy

With the brief description above in mind,
let's examine the method [signature][2], which is a little hairy and intimidating:

    IEnumerable<TResult> GroupBy<TSource, TKey, TElement, TResult> (
        IEnumerable<TSource> source,
        Func<TSource,TKey> keySelector,
        Func<TSource,TElement> elementSelector,
        Func<TKey,IEnumerable<TElement>,TResult> resultSelector,
        IEqualityComparer<TKey> comparer
    );

Ignore the generic types and focus on the 4 functions that must be provided:

- `TKey keySelector(TSource item)` given an `item`, return a key which will be used to decide which group to place this `item`.
  Usually this simply returns a field on `item`, but it can also generate a key, as we will see in a later example.
- `TElement elementSelector(TSource item)` given an `item`, return the value that will actually be stored in the group,
  Often this returns the item or a field on the item.
- `TResult resultSelector(TKey key, IEnumerable<TElement> contents)` after elements are grouped together,
this function will be called for each group. The `key` is the identifier for this group and the `contents` is an enumerable
object containing the results. Most often you will just return `contents`, but you may want to store the result in a new class.
- `int comparer(..)` provide a function so that keys can be compared. This can be left off for key types like integer and string which are comparable.

With an overview of the functions, the meaning of the 4 generic types is now clear:

- `TSource` the items in the collection we will be grouping.
- `TKey` from each item a key will be extracted to identity which group it belongs to.
- `TElement` each item has the opportunity to be transformed before being put into a group.
   This is the type of that transformation.   
- `TResult` The type representing each group. Typically a collection, but could be custom class.


### Example 1: Each teachers' students.

Once again, given a list of `Student` objects,
we may want to group them by `student.teacher`, and then obtain a list of `student.id`
corresponding to each teacher.

    List<Student> students = ...;
   
    students.GroupBy(
       s => s.teacher,        // keySelector
       s => s.id,             // elementSelector
       (teacher, ids) => ids  // resultSelector
    );

    // Result: [ [id1, id2, ..], [id1, id2] ] 


### Example 2: A Histogram of Purchases

Let's imagine we are building a personal finance application.
One report which might be useful is a histogram showing how many purchases
fall within each price range, 
so $10.75 and $12.37 both fall within then $10-20 range.
We want to find out the number of purchases, and the total value of these purchases.
We will use a tuple to store these calculations for each resulting bucket.

    struct Purchase {
       double amount;
       ...
    }

    List<Purchase> purchases = ...;
   
    purchases.GroupBy(
       p => (int)Math.Floor(p.amount / 10.0),    // keySelector
       p => p.amount,                            // elementSelector
       (bucket, amounts) => {                    // resultSelector
          return Tuple.Create(
             bucket,
             amounts.Count(),
             amounts.Sum()
          );
       }
    )
   
    // Result:
    // [ (bucket, number of purchases, total purchase amount), ... ]


Assuming the range of buckets was known up front, one could simply allocate an array with the proper
number of buckets and place each item directly.
But, this implementation is very robust, especially for sparse data sets, and 
forgoes the need to translate our bucket values to indices.
  
### Deep Dive: Implementing GroupBy with Sort and Merge

That may be all you want about `GroupBy` now.
Keep reading if you are curious about how it actually works or wonder
about it's performance.
Grouping elements appears to be an inherently complex task, at first.
An initial idea might be to loop through each item, and then loop through all the other items to find matches.
This works, but is an `O(n^2)` algorithm so we want to try a little harder.

The next natural implementation is to create
a dictionary in which each key contains the results of a group. Iterate over each item in the list once,
and put it in it's proper group.
This works just fine, but it seems a little kludgy.
Dictionaries are rarely uniform.
For each key you must check if a group is there and if not, create it,
then at the end you have to iterate over a dictionary to put the final groups
into an appropriate structure.

We can actually do bit better in elegance and often performance (not time complexity) as well.
The idea is to `sort` elements by their key (`O(n log n)`).
After sorting, all the equal elements that should be grouped together will be next to each other.
We can then apply a reduce-like operation to merge adjacent neighbors.

    public static IEnumerable<TResult> GroupBy<TSource, TKey, TElement, TResult> (
         IEnumerable<TSource> source,
         Func<TSource,TKey> keySelector,
         Func<TSource,TElement> elementSelector,
         Func<TKey,IEnumerable<TElement>,TResult> resultSelector
     ) {
         var sorted = source.Select(item => ValueTuple.Create(keySelector(item), elementSelector(item)))
                 .OrderBy(tup => tup.Item1);

         var start = sorted.First();
         var currentGroup = new List<TElement>()
         {
             start.Item2,
         };

         var groupKey = start.Item1;

         foreach (var x in sorted.Skip(1)) {
             if (x.Item1.Equals(groupKey)) {
               currentGroup.Add(x.Item2);
             } else {
                 yield return resultSelector(groupKey, currentGroup);
                 currentGroup = new List<TElement>()
                 {
                     x.Item2
                 };
                 groupKey = x.Item1;
             }
         };

         yield return resultSelector(groupKey, currentGroup);
     }


This pattern of "sorting and merging" is a powerful one.
See [Stepanov's bigrams][4] for an additional application.
Note that this is almost certainly not how LINQ is implemented (we don't give it a key comparer, just equality test),
but is instructive.

## More About LINQ

LINQ is a fantastic example of the usefulness of domain specific languages (DSL).
It's a mini language designed for manipulating and transforming data in collections,
taking advantage of the strong theoretical foundations of functional programming.
But the benefits of pure functions come with serious constraints.
With LINQ you can take advantage of them when they make sense and avoid them when they don't. (Common Lisp actually does the reverse,
the default style is somewhat functional and a "[goto style][1]" DSL is available for writing
performance code.)

Although languages like Lisp are built around the idea of [constructing DSLs][5],
it's difficult to see how a language with roots in C could be made similarly malleable.
In fact, a great deal of runtime and compiler infrastructure
needed to be added to C# in order to support LINQ, including `lambdas`
anonymous objects, etc. Jon Skeet suspects the C# team had an idea to completely
generalize data access,
and then built up a chain of dependent features to reach this goal.
To learn more about this process and the ideas behind LINQ 
I recommend Jon Skeet's book [C# in Depth][3].
I think you will enjoy it even if you are not interested in C# itself, as it is a joyful deep dive into practical language design and theory.


[1]: http://clhs.lisp.se/Body/m_prog_.htm#prog
[2]: https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.groupby?view=netcore-3.1#definition
[3]: https://www.manning.com/books/c-sharp-in-depth-fourth-edition?utm_source=affiliate&utm_medium=affiliate&a_aid=11033&a_bid=569211b4
[4]: https://github.com/psoberoi/stepanov-conversations-course/blob/master/styles/fortran4.cpp
[5]: http://www.paulgraham.com/onlisp.html
