Deploying Common Lisp Scripts
--------------------------
**3/05/22**

Common Lisp is an excellent scripting language that can serve a similar role as Python or Perl, but with all the Lisp goodies, like great performance and macros.
For these use cases, Common Lisp implementations usually provide a "script mode".
This mode can be invoked by making a `.lisp` script executable and adding a "shebang" interpreter specification.
For example:

    #!/usr/bin/sbcl --script
    (write-string "Hello, World!")

This setup works well, right up until you need to load a dependency.
Then things get messy.
After researching a myriad of bad ways to solve this, I finally uncovered a good solution.

**TLDR:** Quicklisp's [bundle-systems][ql-bundle] command copies all your code and libraries into a single folder that can be loaded by an executable lisp script with `asdf:load-system`. (Experienced lisper's can skip to "Solution" below.)

## quickload

[quicklisp][ql] is the standard way to download and manage libraries.
To load one with `ql:quickload` or `asdf:load-system` you must already have quicklisp loaded.
If the user added it to their startup time (`.sbclrc`), then it will be available automatically. 
However, `sbcl --script` specifically ignores the `.sbclrc` because it's just intended for writing small scripts,
and initializing a user environment for this purpose is a little much.

So, at the beginning of your script, you might try to load quicklisp manually.
You could assume it is in `~/quicklisp` or try to locate it elsewhere, but then 
you might as well just find and load `.sbclrc`.
None of these sound like reliable or nice solutions.

Even if you work something out,
quicklisp is really for downloading dependencies, not using them.
Besides adding some overhead to startup,
imagine if python's `import` started downloading an arbitrary version of a library at run time.
What if the user updates their quicklisp distribution and your code isn't compatible with new changes? 

See this comment from Reddit user [eayse][reddit]:

> I advocate the habit of installing things with ql:quickload, but after initial installation, using asdf:load-system to actually bring the systems into memory.
> After all missing dependencies have been satisfied by network installations from the distributions configured in Quicklisp, ql:quickload just thunks down to ASDF.


## Saving an image

The recommended way to deploy large Common Lisp applications is to load all your source and libraries and [save an image][save-image].
This is a good solution for many deployments (especially backend web applications),
but is not great for scripts. 

The image is an snapshot of the entire lisp system, including compiler, so they tend to be large (> 50 mb for sbcl).
Leaving behind large executables for each script on the system is not polite.
There are approaches to mitigate this and implementations vary.

Besides size, this approach also has  maintenance problems.
After install, the user now has a lisp system on their system frozen in time.
It may have security issues, bugs, etc, and these don't get updated with the system package manager.
In general Lisp should work like every other language implementation.

See also:

- [buildapp][buildapp]
- asdf:make

## Other approaches

**Roswell**

[Roswell][roswell] is advertised as a solution.
I need users to install another tool besides quicklisp? 
If it's not downloading dependencies (quicklisp), and it's not building them (asdf),
then what does it do? 
Why do I have to learn a non-lisp based scripting language to use it?
*sigh*.


**busybox style executable sharing**

If you have a lot of scripts you can save on space
by putting them in the same executable.
See [Fare's article][busybox] and [Steve's][small-cli].
This only solves the disk problem, and assumes we have a lot of scripts.
User's of a lisp program shouldn't have to care about this.

## Solution

Quicklisp's [bundle-systems][ql-bundle] downloads the libraries you specify,
and places them into a standalone package, with a script to configure `asdf` to find the systems.
Here is an example build process:

1. Create a bundle:

       (ql:bundle-systems (list "alexandria" "cl-ppcre" ...) :to "build/")

2. Copy your application's asdf system (along with source) into `build/local-projects/myapp`

       cp *.lisp build/local-projects/myapp
       cp *.asd build/local-projects/myapp

3. Install `build` in `usr/local/lib/myapp`.

4. Install launch script in `usr/local/bin/` which loads the bundle and starts the script.
   For example:

       #!/usr/bin/sbcl --script
       (load "/usr/local/lib/myapp/bundle.lisp")
       (asdf:load-system "myapp")
       (myapp:do-stuff)

[buildapp]: https://www.xach.com/lisp/buildapp/
[small-cli]: https://stevelosh.com/blog/2021/03/small-common-lisp-cli-programs/
[ql-bundle]: https://www.quicklisp.org/beta/bundles.html
[save-image]: https://lispcookbook.github.io/cl-cookbook/scripting.html
[reddit]: https://old.reddit.com/r/lisp/comments/iai2ab/repairing_asdf_package_storage/g1pnxdt/
[roswell]: https://roswell.github.io/Roswell-as-a-Scripting-Environment.html
[busybox]: https://fare.livejournal.com/184127.html
[ql]: https://www.quicklisp.org/beta/
