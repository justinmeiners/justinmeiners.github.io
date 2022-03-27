Understanding LINQ GroupBy
==========================

**09/26/20**

As a C# programmer, you are probably familiar with  `Select`, `Where`, and `Aggregate`,
the LINQ equivalents of the fundamental functional programming operations `map`, `filter`, and `reduce`. 
`GroupBy` is an equally useful function, which you may be less familiar with, but should definitely learn about.
It solves the following problem:
Given a list of items, partition them into groups so that equivalent elements are together.
For example, given a list of `Student`s in the school, we may want to
group them by `teacher` to build a class roster.

Functional programming aims to specify "what" needs to be done, rather than how to do it.
As a programmer, this helps shift your focus and concern to a higher level of abstraction,
leading to cleaner and more direct code.
`GroupBy` is a beautiful example of these principles.
It solves a general problem, in a reusable way, which would otherwise take a bit of thought to write correctly
by hand (as we shall see).
Furthmore, it combines harmoniously with the other LINQ operations.

### How to use GroupBy

With the brief description above in mind,
let's examine the method [signature][2]:

    IEnumerable<TResult> GroupBy<TSource, TKey, TElement, TResult> (
        IEnumerable<TSource> source,
        Func<TSource,TKey> keySelector,
        Func<TSource,TElement> elementSelector,
        Func<TKey,IEnumerable<TElement>,TResult> resultSelector,
        IEqualityComparer<TKey> comparer
    );

Bleh! That looks pretty meaningless and intimidating.
Ignore the generic types for now and I will explain the 4 functions that must be provided:

- `TKey keySelector(TSource item)` given an `item`, return a key which will determine which group to place this `item`. Typically this is a field on `item`.
- `TElement elementSelector(TSource item)` given an `item`, return the value that will actually be stored in the group,
  Often this returns a field on the item or the item itself. 
- `TResult resultSelector(TKey key, IEnumerable<TElement> contents)` after elements are grouped together,
this function will be called on each group to produce a final result. The `key` is the identifier for this group and the `contents` is an enumerable
object containing the results. Most often you will just return `contents`, but you may want to store the result in a new class.
- `int comparer(..)` provide a function so that keys can be compared.
   This can be left off for key types like integer and string which are already comparable.

With an understanding of the functions, the meaning of the 4 generic types is now clear:

- `TSource` the type of the input items.
- `TKey` the type of the key that will identify which group the item belongs to.
- `TElement` each item has the opportunity to be transformed before being put into a group.
   This type is the output of that transformation.   
- `TResult` The result type from obtaining a result from a group. If you were to return each group as an array, this type would be `[TElement]`.

### Example 1: Classroom roster by student id 

Let's try the example mentioned above.
Given a list of `Student` objects,
we want to group them by `teacher` to create class roster.
However, in this example, we don't need the whole student object,
we only want their student ids.

    List<Student> students = ...;
   
    students.GroupBy(
       s => s.teacher,                 // keySelector
       s => s.id,                      // elementSelector
       (teacher, ids) => ids.ToArray()  // resultSelector
    ).ToArray();

    // Result: [ [id1, id2, ..], [id1, id2] ] 

### Example 2: A histogram of purchases

Let's imagine we are building a personal finance application.
One useful tool would be a histogram showing purchases withn typical 
price ranges (for example $0-$10, $10-$20, etc), 
For each range, we would want to know the total number of purchaes, and their total value.
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
          return ValueTuple.Create(
             bucket,
             amounts.Count(),
             amounts.Sum()
          );
       }
    ).ToArray();
   
    // Result:
    // [ (bucket, number of purchases, total purchase amount), ... ]


**Note:** Assuming the range of buckets was known up front,
one could simply allocate an array with the proper
number of buckets and place each item directly.
But, `GroupBy` also works if the data is sparse and 
forgoes the awkward need to translate between bucket values and indices.
  
### Implementing GroupBy with sort and merge

That may be all you want to know about `GroupBy` now.
For those who are curious, let's talk about how it works and performs.
At first, grouping elements appears inherently complex. 
An initial idea might be to loop through each item, and then loop through all the other items to find matches.
This works, but is an `O(n^2)` algorithm so will quickly become unwieldy. 

The next natural implementation is to create a dictionary similar to `Dictionary<TKey, List<TElement>>`.
Iterate over each item in the list once, and insert it into the list corresponding to it's proper group.
This solution has pretty good `O` complexity, but comes with some practical performance problem.
The main concern is with how memory is used.
Depending on the dictionary implementation, it has a memory allocation which it must resize and copy as it grows.
Furthermore, each individual group array does the same thing!
This is expensive, and not friendly to the cache.

We can do bit better in elegance and practical performance by "sorting and merging".
First, `sort` elements by their key (`O(n log n)`).
After sorting, all the equivalent elements should be next to each other.
We can then apply a reduce-like operation to merge adjacent neighbors into a group `O(n)`.
This is a general technique which can solve a lot of algorithm problems (See [Stepanov's bigrams][3] for one other application).

Let's give it a try:

    public static IEnumerable<TResult> GroupBy<TSource, TKey, TElement, TResult> (
        IEnumerable<TSource> source,
        Func<TSource,TKey> keySelector,
        Func<TSource,TElement> elementSelector,
        Func<TKey,IEnumerable<TElement>,TResult> resultSelector
    ) where TKey: IComparable
    {
        var sorted = source.Select(item => ValueTuple.Create(keySelector(item), elementSelector(item))).ToList();
        if (sorted.Count == 0) yield break;
        sorted.Sort((a, b) => a.Item1.CompareTo(b.Item1));

        var startIndex = 0;
        var endIndex = 1;
        var groupKey = sorted[0].Item1;

        while (endIndex < sorted.Count)
        {
            var key = sorted[endIndex].Item1;
            if (!groupKey.Equals(key))
            {
                var group = Enumerable.Range(startIndex, endIndex - startIndex).Select(i => sorted[i].Item2);
                yield return resultSelector(groupKey, group);
                startIndex = endIndex;
                groupKey = key;
            }
            ++endIndex;
        }

        var finalGroup = Enumerable.Range(startIndex, endIndex - startIndex).Select(i => sorted[i].Item2);
        yield return resultSelector(groupKey, finalGroup);
    }

**Note:** this is almost certainly NOT how LINQ is exactly implemented (`TKey` is only required to have equality testing, not `IComparable`),
but their approach is similar. 

[2]: https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.groupby?view=netcore-3.1#definition
[3]: https://github.com/psoberoi/stepanov-conversations-course/blob/master/styles/fortran4.cpp
