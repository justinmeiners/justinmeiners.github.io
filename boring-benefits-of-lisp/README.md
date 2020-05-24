Boring Benefits of Lisp
=======================

Lisp advocates are famous for having extravagant reasons for why Lisp is their favorite language.
You might have heard that its the [most powerful language][0],
due to feature like [macros][1] or [homioconicty][2].
Certainly, Common Lisp and Scheme have no shortage of beautiful ideas,
but due to their influence, most of their benefits have now been included
in modern languages.
I am now interested in it for very simple and practical reasons;

1. Lisp is a fully standardized language. Consequently, it is well understood, cross-platform, and has multiple implementations, including several with free licenses.
2. Lisp has great documentation, books, and learning resources. SICP is "the book" for Scheme. Common Lisp has several good ones.
3. Lisp is mature and extremely stable. Code be written once, and run again years later, without modification.
4. Lisp implementations are reasonably fast. The true believers say Common Lisp can be as fast as C, in general it's not even close, but for a high-level, dynamic, language, [it's pretty great][4].
5. Lisp is well designed and follows solid computer science principles.
  It has a focused selection of features and an elegant evaluation model which make it easy to 
  write and compose functionality.
  
These features don't appear that remarkable or unique to Lisp.
In fact, this pattern of requirements was actually established by ANSI C first, and later adopted by Lisp.
But, the surprising thing is how few languages since have followed the pattern.
Of course satisfaction lies on a spectrum; some languages do more than others,
but very few follow it to a degree that can be asserted with confidence.
Usually, you can say a language somewhat satisfies it, followed by a list of ugly qualifications.

Take Python for example. It's well designed, has great resources, is fairly stable.
It has an [elegant design][3] like Lisp.
But, is it standardized? Kind of, they have a spec, but it has one defacto implementation.
CPython does whatever they want, and others follow.
The alternative implementations all have compatibility compromises.
Neither is it fast, unless you use a JIT implementation which makes it tolerable, but that has its own quirks, and you can't use X library with it.

So are Lisp and C the only languages that do this? No, but there aren't as many as you think.
Lisp just happens to be one of them, and it's a design that I enjoy using and learning about.


[0]: http://www.paulgraham.com/avg.html
[1]: http://www.paulgraham.com/onlisp.html
[2]: https://en.wikipedia.org/wiki/Homoiconicity
[3]: https://norvig.com/python-lisp.html
[4]: https://benchmarksgame-team.pages.debian.net/benchmarksgame/fastest/lisp.html
