Boring Benefits of Lisp
=======================

**10/07/20**

Lisp (both Common Lisp and Scheme) advocates are famous for having extravagant reasons for why Lisp is their favorite language.
You might have heard claims that it's the [most powerful language][0],
due to feature like [macros][1] or [homioconicty][2].
Certainly, Lisp has no shortage of beautiful and thought provoking ideas,
but due to it's influence, most of its benefits have now been included
in modern languages.
But, fancy language abstractions [don't appeal to me][5],
so the whole meta-programming thing isn't compelling.
I am now interested in it for very simple and practical reasons;

1. Common Lisp and Scheme are both fully standardized language with specifications.
   Consequently, they are well understood, cross-platform, and has multiple implementations, including several with free licenses.
2. Lisp has great documentation, books, and learning resources. SICP is "the book" for Scheme.
   Common Lisp has several good ones.
3. Lisp is mature and extremely stable. Code be written once, and run again years later, without modification.
4. Lisp implementations are reasonably fast. The true believers claim Common Lisp is as fast as C. In general it's not even close, but for a high-level, dynamic, language, [it's pretty fast][4].
5. Lisp is well designed and follows solid computer science principles.
  It has a focused selection of features and an elegant evaluation model which make it easy to 
  write and compose functionality.
  
You might think, this list of features isn't remarkable or unique to Lisp,
and you would be correct.
In fact, this pattern was actually established by ANSI C first, and later adopted by Lisp.
But, the surprising thing is how few languages since have followed it's lead.
Of course each item in this list is somewhat of a spectrum; some languages do more than others,
but very few follow it to a degree that can be asserted with confidence.
Usually, you can say a language somewhat satisfies it, followed by a list of ugly qualifications.

Take Python for example. It's well designed, has great resources, is fairly stable.
It has an [elegant design][3] inspired by Lisp.
But, is it standardized? Kind of, they have a spec, but it has one defacto implementation.
The CPython project does whatever they want, and this defines what the language is, forcing others to follow along.
Alternative implementations exist, but they all have compatibility compromises.
Python is also not very fast. You can use a [JIT][6] implementation which makes it tolerable,
but that has its own quirks, and you can't use many libraries with it.

So are Lisp and C the only languages that are based on performance, robust standards, and free software?
No, but there aren't as many as you think.
Lisp just happens to be one of them, and it's a design that I enjoy using and learning about.


**Update: 4/30/21**: I recommend the article ["Tips for stable and portable software"][7] which  discusses principles of stability, not only at the language level, but in the whole stack. It shows
practical examples of things to look for in programming languages and Unix environments.


[0]: http://www.paulgraham.com/avg.html
[1]: http://gigamonkeys.com/book/macros-defining-your-own.html
[2]: https://en.wikipedia.org/wiki/Homoiconicity
[3]: https://norvig.com/python-lisp.html
[4]: https://benchmarksgame-team.pages.debian.net/benchmarksgame/fastest/lisp.html
[5]: https://justinmeiners.github.io/think-in-math/
[6]: https://www.pypy.org
[7]: https://begriffs.com/posts/2020-08-31-portable-stable-software.html
