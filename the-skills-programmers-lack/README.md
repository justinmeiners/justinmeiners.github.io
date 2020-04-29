The Skills Poor Programmers Lack
--------------------------------
**02/22/2019**

Updated: **04/27/2020**

A friend and I had a discussion about the basic skills that are often lacking in experienced programmers. How can a programmer work for ten or twenty years and never learn to write good code? Too often they need close supervision to ensure they go down the right path, and can never be trusted to take technical leadership on larger tasks. It seems they are just good enough to get by in their job, but they never become *effective*. 

We thought about our experiences and came up with three fundamental skills that we find are most often missing. Note that these are not skills which take a considerable amount of talent or unique insight. Nor are they "trends" or "frameworks" to help you get a new job. They are basic fundamentals which are prerequisites to being a successful programmer.

## Understand how the language works

Programmers cannot write good code unless they understand what they are typing. At the most basic level, this means they need to understand the rules of their programming language well. It is obvious when a programmer doesn't because they solve problems in indirect ways and litter the code with unnecessary statements that they are clueless as to what they actually do. Their mental model of the program does not match with the actual behavior of the code.

You may have seen code which misunderstands how expressions work: (1)

    if isDelivered and isNotified:
        isDone = True
    else:
        isDone = false;

Instead of:

    isDone = isDelivered and isNotified

In JavaScript, this is often indicated by `new Promise` inside a `.then()`. In C++, it is attaching `virtual` to every method and destructor and creating every object with `new`. 

Debugging is also extremely difficult if you don't understand the language. You may add a line of code because it fixes a bug for reasons you don't understand. Bugs are mysteries that seem to appear organically, like dust on the shelves. The code has a mind of its own.

Understand the code you write. Know what every line does and why you put it there.

Once you understand the language well, its important to know about implementation; what goes on *inside* the computer or library? Do you know how the code gets to [assembly][6]? Do you know how a [closure captures variables][7]? Do you know how the [garbage collector][8] works? Do you know how a [map/dictionary][9] works? Do you know how an HTTP request is made?

Modern software and computers are too complex to know everything (2).
The idea is not not to be too clever, but to avoid doing silly things.
Silly mistakes result in sluggish code that is wasteful of system resources, or just does unexpected things.
Removing an item from the front of a C++ `vector` requires copying the entire vector which is worth thinking about in large cases.
Writing `map<string, map<string, ...>>` in C++ (a dictionary of dictionaries) creates a a self-balancing tree in which every node is a self-balancing tree, a data structure nobody would intentionally design. (3)

A muddy understanding of how things work is typical of beginners, but it is all too often a problem with experienced programmers if they are not curious and do not take time to learn how things work beyond their immediate job’s needs.
Learn just a bit more about the stuff you use most works.

## Anticipate problems

To write reliable code, you must be able to anticipate problems, not just patch individual use cases. I am shocked by the number of times I see code that puts the program in a broken state when a very likely error happens. 

I recently reviewed some code that made an HTTP request to notify a server of a state change in which the programmer assumed the HTTP request would always succeed. If it failed, (and we know how often HTTP requests fail), a database record was put into an invalid state. The questions they should have asked when writing this code are: What happens if this fails? Is there another opportunity to send the notification? When is the correct time to record the state change? Careful programmers think through the possible states and transitions of their program.

Using `sleep()`, cron jobs, or `setTimeout` is almost always wrong because it typically means you are waiting for a task to finish and don’t know how long it will take. What if it takes longer than you expect? What if the scheduler gives resources to another program? Will that break your program? It may take a little bit of effort to rig a proper event, but it is always worth it. 

Another common mistake I see is generating a random file or identifier and hoping that collisions will never happen (4). It is reasonable for an unlikely event to cause an error, but it is not ok if that puts your program in an unusable state. For example, if a successful login generates a session token and it collides with another token, you could reject the login and have the user try again. It is a freak accident that slightly inconveniences the user. On the other hand, what if you generate storage files with random names and you have a collision? You just lost someone’s data! “This probably won’t happen” is not a strategy for writing reliable code.

Unit testing can’t solve this problem either. It can help you stop and think about some inputs to write a test, but more than likely, the cases that you write tests are the ones you anticipated when you wrote the code! Unit testing cannot transform fragile code into reliable code.

Fragile code is often caused by a lack of experience regarding things that can go wrong, but it can also be the result of a long career of maintaining existing codebases. When working on a large existing system, you typically fix individual bugs and aren’t rewarded by your bosses for improving the system as a whole. You learn that programming is a never-ending patch. Increasing the `sleep()` time may fix the bug today, but never solve the underlying issue. 

## Organize and design systems

Even when armed with the other two skills, it's hard to be effective unless you can organize code into a system that makes sense. I believe OOP and relational database get a lot of flack because programmers tend to be bad at design, not because they are broken paradigms. You simply can't create rigid classes, schemas, and hierarchies without thinking them through. Design itself is too broad a topic to explore in this article (read [Fred Brooks](https://en.wikipedia.org/wiki/Fred_Brooks)), so I want to focus on a few specific attributes that well-designed software tends to have.

You may have heard a rule like ["don't make functions or classes too long"](http://number-none.com/blow/blog/programming/2014/09/26/carmack-on-inlined-code.html). However, the real problem is writing code that mixes unrelated ideas. Poorly designed software lacks conceptual integrity. Its concepts and division of responsibilities are not well defined. It usually looks like a giant Rube Goldberg machine that haphazardly sets state and triggers events.

Accordingly, good software is built from well-defined concepts with clear responsibilities. Mathematicians and [philosophers][3] spend a lot of time discussing definitions because a good definition allows them to capture and understand some truth about the world. Programmers should think similarly and spend a comparable amount of effort grappling with ideas before writing code.

Good programmers ask questions like:

- "What is this function's purpose?"
- "What does this data structure represent?"
- "Does this function actually represent two separate tasks?"
- "What is the responsibility of this portion of code? What shouldn't it 'know about'?" 
- "What is necessary to be in the public interface?"

Luckily the field is ripe with strategies to help you design code. [Design patterns](https://www.oodesign.com) and [SOLID](https://en.wikipedia.org/wiki/SOLID) can give you guidelines for designing classes. Functional programming encourages writing pure functions (input -> output and no side effects) and maintaining as little state as possible. [Model view controller](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/MVC.html) aims to separate UI and storage concerns from program logic. On the other hand, React components form conceptual units by combining the HTML, CSS, and JS into a single component. Unix rejects categories and says [everything is a file](https://en.wikipedia.org/wiki/Everything_is_a_file). All of these seemingly contradictory ideas are valid. The important thing is that the concepts make sense and map closely to the problem you are solving.

Software that is well-designed is also software that is easy to change. Of course, it's too much to ask it to satisfy requirements that contradict its original intent. But, it should accommodate changes that are natural evolutions. A common mistake I see is solving a problem for a few cases, instead of N cases. (If you have a variable called `button3`.) Another is treating everything as a special case using `switch` statements instead of using polymorphism. (5)

I think the best way to learn about design is to write and study a lot of programs. Programmers who work only on old programs never learn to write new ones. The studying part is key too. Programmers who only work on small temporary projects (like an agency) may get by without ever improving how to design programs. Good design comes gradually with experience, but only if you think about it and try to improve.

There are no tricks or rules that you can follow to guarantee you will write good software. As Alex Stepanov said, "think, and then the code will be good."

[1]: https://en.wikipedia.org/wiki/Cache_coherence
[2]: https://preshing.com/20120625/memory-ordering-at-compile-time/
[3]: https://en.wikipedia.org/wiki/Categories_(Aristotle)
[5]: https://gist.github.com/Dobiasd/fa27e3efb8b08fc81791d7f8e51ac5ca
[6]: http://inst.eecs.berkeley.edu/~cs61c/sp15/
[7]: https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-21.html#%_sec_3.2
[8]: https://en.wikipedia.org/wiki/Cheney%27s_algorithm
[9]: http://opendatastructures.org/ods-python/


1. There may be some cases where the previous style is preferred.
   This example is only an illustration.

2. I was shocked when I wrote some multithreaded code and first faced bugs due to
   [Cache coherence][1] and [instruction reordering][2]! 

3. A reader corrected me about the performance of modern `map` implementations.
   Map of map is just as good as alternatives, like map of pair.
   I think it is a good illustration of code being suprising,
   but perhaps I am doing a bit too much early optimization :)
   See his [benchmark][5].

4. There are ways to do this sort of thing correctly using cryptographic hashes.

5. Once again, this is just an example. Switching on type may be perfectly appropriate.



