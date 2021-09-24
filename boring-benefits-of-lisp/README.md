Boring Benefits of Lisp
=======================

**10/07/20**

Lisp advocates are famous for having elaborate reasons for why Lisp is their favorite language.
You might have heard that it's the [most powerful language][0],
thanks to features like [macros][1], first class functions, and [homioconicity][2].
Certainly, Lisp has no shortage of beautiful and influential ideas.
But, almost every modern language has copied it's most productive features.
Are there still compelling reasons to use it in production?

For me there are. But, my interest is much more boring and practical.
Fancy language abstractions [don't appeal to me][5],
so the whole meta-programming isn't as important.
What I do care about is a reliable and stable ecosystem which
allows me to write quality code that can last for a long time.
Consider the following features:

- **Standards:** Common Lisp and Scheme are both fully standardized language with specifications.
   Consequently, they are well understood, cross-platform, and have diverse implementations,
    including several with free licenses.
- **Documentation:**  [SICP][sicp] is "the book" for Scheme and computer science.
    Common Lisp has several great books worth reading even if you don't care about Lisp (see [PAIP][paip]).
    The [CLHS][clhs] is as reliable and thorough as any language.
- **Stability:** Lisp has been around since the 60s and the ANSI standard about 30 years.
    It is extremely stable. Code be written once, and run again years later, without modification.
- **Efficiency:** Lisp implementations are reasonably fast.
    The true believers claim Common Lisp is as fast as C,
    it's probably much closer to Java.
    But, for a high-level, dynamic, language, [it's pretty fast][lisp-benchmark].
- **Design:** Lisp is well designed and founded on solid computer science principles.
  It has a focused selection of features and an elegant evaluation model which make it easy to 
  write and compose functionality.
  
You might think this list of features isn't remarkable or unique to Lisp.
That's certainly true.
C did them first, and established them as the recipe for releasing a successful language.
Languages since have followed various steps, but the surprising thing
is how few of them actually ended up with all the ingredients.
Of course each item in this list is somewhat of a spectrum; some languages do more than others,
but very few languages follow it to a degree that can be asserted with confidence.
Usually, you can say a language somewhat satisfies it, followed by a list of ugly qualifications.

Take Python for example. It's well designed, has great books and documentation, is fairly stable.
It has an [elegant design][norvig-python] inspired by Lisp.
But, is it standardized? Not really. They have a spec, but it only has one defacto implementation
and changes all the time.
Whatever the CPython project chooses to do defines the language. 
Alternative implementations exist, but they all have compatibility compromises.
Python is also not very efficient.
You can use a [JIT][pypy] implementation which makes it tolerable,
but that has its own quirks, and you can't use many libraries with it.

Lisp and C aren't the only languages with all these benefits,
but there aren't as many as you think. 
Since Lisp has these great features and a design I enjoy using and studying
it's become my go-to language.

**Update: 4/30/21**: I recommend the article ["Tips for stable and portable software"][begriff-stable] which discusses principles of stability at the language level, as well as the entire OS stack. It offers
specific advice for reliable unix software.

**Update: 09/23/21**: Edited to clarify intended message.

[0]: http://www.paulgraham.com/avg.html
[1]: http://gigamonkeys.com/book/macros-defining-your-own.html
[2]: https://en.wikipedia.org/wiki/Homoiconicity
[norvig-python]: https://norvig.com/python-lisp.html
[lisp-benchmark]: https://benchmarksgame-team.pages.debian.net/benchmarksgame/fastest/lisp.html
[5]: https://justinmeiners.github.io/think-in-math/
[pypy]: https://www.pypy.org
[begriff-stable]: https://begriffs.com/posts/2020-08-31-portable-stable-software.html
[clhs]: http://www.lispworks.com/documentation/lw50/CLHS/Front/index.htm
[paip]: https://github.com/norvig/paip-lisp/
[sicp]: https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book.html
