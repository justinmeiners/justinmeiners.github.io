Thinking styles from math
==========================

**11/18/2022**

A surprising lesson I learned from graduate school is that math is just very different than everything else I have tried learning in the past.
It has it's own style of thinking that has grown to be my [primary method](/think-in-math/) for solving hard problems. 
But, coming from a background in professional software development for years before, I expected a lot more of my core engineering skills to carry over.
Here I want to discuss some differences I noticed and their implications.

## Debugging and Proving

Debugging programs taught me to check my work with a radically empirical approach.
When something isn't working as expected, I "turn off" that part of my brain that makes assumptions about what it should be doing, and just directly examine the behavior of the program.
Usually it starts with, "does this line ever get called?", and grows increasingly more skeptical, "does 2+2 really equal 4?".
When the problem is tricky, no question is too stupid to ask.
The goal is to quickly find the gap in my mental model and accommodate it.
It's a simplified version of the scientific method, with a bit of a bias towards experimenting over hypothesizing.

Beginners struggle with debugging because they aren't as skeptical. 
They feel the computer is doing impossible or magical things outside their control.
Perhaps it's uncomfortable or unintuitive for them to question their understanding when it's already shaky.

However, this skill of "turning off" your judgment and only observing gets you almost nowhere in math.
Proving a theorem is all about building up new information from facts you know.
You have to look at it a conceptual object and assert with confidence, "This fits into X category. I know X category has this property. Therefore... ".
It's an active thinking process that takes constant energy and work.
While debugging is an exercise in humility, proving is all about making bold claims.

Even though it takes a lot of work, then end result is very satisfying.
In the process of proving you demonstrate that you know something in the truest way possible.
You don't just happen to hold a true opinion, but can explain, at increasing levels of detail, why it's true.

There is still an experimental aspect to math (some mathematicians prefer more experimentation than others), it just isn't like
interacting with a computer and passively observing output.
When you don't know where to go on a problem, you study examples and try to discern patterns.
This is very engaging work as you must be the one to construct the examples.
The most insight comes from exotic examples, that push things to the extreme, and take some creativity to come up with.

## Engineering and Discovery

Debugging is just one small part of programming, and is usually an easy part.
What about the engineering skills that go into designing programs, like determining goals, evaluating trade-offs, creating plans, prototyping solutions step by step?
In my experience, there just isn't a whole lot of these that are applicable either.

Occasionally it's helpful in math to plan out a strategy for approaching a larger theorem,
but you have no idea what will be true or false, so you can't get into much detail, or make many assumptions that rely on prior steps.
There aren't really trade-offs to speak of, except where you want to spend your time and effort.

Engineers solve problems by iteratively improving solutions to overcome key technical challenges in the project.
In each iteration, they determine components that worked and components that didn't, and it's a matter
of keeping what worked and fortifying or replacing the broken stuff.

Mathematicians obviously try a lot of potential solutions, but rarely is it componentized in the same way.
Either the whole approach worked or not.
The solution usually comes in the form of a key discovery, or a sudden flash of insight, after a lot of thought and experimentation.
This insight reveals the inter workings of the problem.

There is an alternative theory that programming is more like a craft than engineering, like woodworking, writing, or [painting](http://www.paulgraham.com/hp.html).
A craftsmen starts with a rough outline or plan, and then gradually improves individual portions of the work, occasionally making sweeping corrections across the entire piece.
Once again, I see very few parallels with math.
There is little hope to transform a false result into a true one, or to discover new insights with highly local refinements. 

Why is there such a big gap in these experiences?
It's hard to say.
Math is certainly more focused on discovery and questioning what is true, as opposed to constructing something.
This suggests a more direct encounter with constraints imposed by the world.
But, even this distinction isn't very clear, as engineering also requires dealing with natural trade-offs. 

## Meta-learning skills

All of this has changed how I think about meta-learning.
There is an idea that all fields are pretty much the same, except for details, and you can just transfer skills between them.
Perhaps you have heard the goal of university is to teach you "how to learn".
That just doesn't appear completely true.
Some things are similar enough for a transfer, but some are just different.

Despite differences I want to call out a meta-learning skill, which is used in math, that is hugely underrated in engineering and especially software.
That is deliberate practice combined with feedback or coaching.
Of course, it gets plenty of attention in sports and music.
But engineers argue that this doesn't matter for the kind of work they do.
Their low-level implementation skills could optimized, but they aren't the bottleneck.
Most of their effort is spent on tasks that are not focused on efficiency, and not even repeatable.
Consider tasks like conceptualizing the problem, gathering requirements, etc. 

Dan Luu has [responded](https://danluu.com/productivity-velocity/) to this, arguing that increased velocity significantly aids the other tasks, including simply being able to try more iterations in the same amount of time.
Read his article to get all the details.
I just want to add that math has been built up almost entirely of unique breakthroughs and discoveries, which rarely are the same as what's come before.
In other words, the solutions are even less repurposable than what engineers deal with.
Yet, mathematicians place significant weight in memorization, practice, coaching, and studying a variety of areas.

There are a few rationales for this.
Of course, practicing solving problems emulates the experience of actually making a mathematical discovery.
It's a pretty good emulation too, except that you have the assurance
there is a solution and that the teachers have tailored it to your skill level.

Another reason is making new breakthroughs is just easier if you are fluent with lower level concepts.
It's hard to do calculus, if you struggle with algebra.
Remember the discussion about how proving is difficult because you have to actively make new claims?
How do you get better at this process?
Either your learn the material more thoroughly so you can assert with more confidence from memory,
or learn adjacent material so you can perform logical consistency checks as you go.
Both of these are essentially just fluency.

Mathematicians also believe that the techniques used for old problems will become useful in the future.
Even if you never reproduce a proof exactly, it becomes a tool in your toolbox and a source of inspiration.
You may have noticed in college that math professors tend to have a "nack" for knowing what to try on a problem.
They seem to get right to the core issue while you are left thinking "I would never have thought of that".
Although it may appear that they must have known the answer, it's actually their trained intuition, built up from being required to solve a lot of problems in a short amount of time.

What would it like to adopt similar practices in programming?
Of course, we should look at speed of writing code, following problem solving procedures, workspace improvements, etc.
Coaching suggests a whole set of interesting opportunities to be explored.

But, I think at the most basic level it starts with mindset.
Do we want to work hard to get better?
There seems to be an attitude of avoiding learning at all costs, because it doesn't directly count as productivity.
Why don't we embrace curiosity and practice as a separate and worthwhile activity?
Why don't we make a systematic study of the programs that have come before?

