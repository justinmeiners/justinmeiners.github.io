using System;
using System.Collections.Generic;
using System.Linq;

namespace test
{
    class Program
    {
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
    

        static void Main(string[] args)
        {
            int[] nums = {1, 2, 7, 3, 4, 1, 20, 8, 3, 5, 7};

            var result = GroupBy(
                nums,
                x => x % 2 == 0,
                x => x,
                (key, group) => (group.Count(), group.ToArray())
            ).ToList();
            
            result.ForEach(tup => Console.WriteLine( string.Join(",", tup.Item2)));
        }
    }
}
