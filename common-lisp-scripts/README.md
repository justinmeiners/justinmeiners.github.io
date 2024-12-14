Deploying Common Lisp Scripts
----------------------------
**3/05/22**

You want a Common Lisp workflow that's just like Python or Perl,
so you can write scripts!
No dumping images, or complex deployments.
Just install *a single lisp interpreter* on your computer (`/usr/local/bin/sbcl`) and 
*write, run, and share* source files.
Here I'll explain how to do that.

A step in the right direction is a `.lisp` file with an appropriate shebang:

    #!/usr/bin/sbcl --script
    (write-string "Hello, World!")
    
But you'll quickly run into a few roadblocks.
How do you include other source files without knowing their installation path?
How do you load libraries such as through QuickLisp?

The solution? (**TLDR**) QuickLisp has a command for downloading libraries and exporting them called **[ql:bundle-systems][ql-bundle]**.
It creates a single folder with an index file called `bundle.lisp`.
After running `(load bundle.lisp)`, all of your dependencies are available to be load via `asdf:load-system`.

## How to use `ql:bundle-system`

1. Create a bundle containing your QuickLisp dependencies:

        (ql:bundle-systems (list "alexandria" "cl-ppcre" ...) :to "bundle/")

    This `bundle/` folder will contain  `alexandria` and `cl-ppcre`, along with their transitive dependencies.
    Each package will be organized as its own an `asdf` system.

2. Create an `.asd` file describing your project and its (See [defsystem docs][asdf] for details).

        (asdf:defsystem "my-lisp-program"
            :depends-on (:alexandria :cl-ppcre ...)
            :build-pathname "my-lisp-program"
            :components (
                (:file "...")
                ...))

    The `:depends-on` list must only reference systems which were downloaded by `ql:bundle-systems`. 

3. Copy your application source in the bundle:

        $ mkdir -p bundle/local-projects/my-lisp-program
        $ cp *.lisp bundle/local-projects/my-lisp-program
        $ cp *.asd bundle/local-projects/my-lisp-program

    Now your code is just another `asdf:system`, alongside the others.

3. Install the bundle in a global system path:

        $ cp -r bundle/ /usr/local/lib/my-lisp-program

4. Create a brief script which loads the `bundle.lisp` and the `asdf` system. For example `my-lisp-program`

        #!/usr/bin/sbcl --script
        (load "/usr/local/lib/my-lisp-program/bundle.lisp")
        (asdf:load-system "myapp")
        (my-lisp-program:do-stuff)

    `asdf:load-system` will examine your projects `.asd` file and load its dependencies, transitively.

5. Install the launch script in a global system path:

        $ mv my-lisp-program /usr/local/bin/

6. Run your script!

        $ my-lisp-program

That's all! Consider automating these steps for your project, such as with `make install`. 

The first time you run the script you may see a long log
as `sbcl` compiles the code into `.fasl` files.
These will be used for faster loads on subsequent runs.

## Why other solutions didn't work for me 

There are a myriad of articles that claim to solve this problem.
But after much research and trial and error, I found none of them to be satisfactory.
Let's review them:

### Dumping an image 

The popular advice for deploying Common Lisp is to [dump an image][save-image] of the compiler (`save-lisp-and-die`),

This makes a copy of the entire Lisp compiler with your source code included.
This is a good solution for large applications.
For example, if you want to deploy a web application to server,
it's pretty convenient to `scp` up an image file and be done.

However, it's quite cumbersome if you have more than a handful to keep track of. 
Your computer becomes littered with a bunch of independent copies of Lisp.
If you want to update `sbcl` you need to track down all your old images, delete them, and rebuild new ones.
Images files are also notoriously large (~50 MB for `sbcl`).

### Using QuickLisp in scripts

Can you make a shebang script that loads code with QuickLisp?
You certainly can, but first note that `sbcl --script` will skip Lisp your system configuration (`.sbclrc`),
so you need to hard code a path to load QuickLisp. 

But now imaging if calling `import` in a Python started downloading code from the internet!
That's a security and reliability nightmare.
But that's how QuickLisp works!

That's because QuickLisp isn't intended to be a library loader. 
It's a tool for downloading and *discovering* libraries.
But it shouldn't be included with your program.

You should be using `asdf` for that instead.
It's the standard way to describe and load libraries,
and it's already included in most distributions.

Note that QuickLisp is also organized as a rolling release like your operating system.
Rather than picking out individual library version tags, you pick a QuickLisp version which 
is a snapshot in time of all the libraries that aims to be compatible.

To reiterate the relationship between QuickLisp and `asdf`,
I will borrow an explanation from Reddit user [eayse][reddit]: 

> I advocate the habit of installing things with `ql:quickload`, but after initial installation, using `asdf:load-system` to actually bring the systems into memory.
> After all missing dependencies have been satisfied by network installations from the distributions configured in Quicklisp, `ql:quickload` just thunks down to ASDF.

### Roswell?

[Roswell][roswell] is advertised as a solution, but it's possibly the most un-Lispy tool in the ecosystem.
It doesn't download dependencies, or help you build them.
What does it do? Help you download sbcl?
Why in the world does it use a config file syntax that isn't s-expressions?
Why is part of it written in C?
*sigh*.

## Busybox style

The overhead of dumping an image can be shared by putting many scripts into a single image, instead of making an image for each.
I call this "Busybox style" because it was popularized in C by the [Busybox][busybox] project.
For a Common Lisp tutorial, see [Steve 's article][small-cli].

This certainly solves some of the disk usage problems.
But it's kind of a crutch, and the workflow is just not as good as Python. 

[asdf]: https://asdf.common-lisp.dev/asdf.html#Defining-systems-with-defsystem
[buildapp]: https://www.xach.com/lisp/buildapp/
[small-cli]: https://stevelosh.com/blog/2021/03/small-common-lisp-cli-programs/
[ql-bundle]: https://www.quicklisp.org/beta/bundles.html
[save-image]: https://lispcookbook.github.io/cl-cookbook/scripting.html
[reddit]: https://old.reddit.com/r/lisp/comments/iai2ab/repairing_asdf_package_storage/g1pnxdt/
[roswell]: https://roswell.github.io/Roswell-as-a-Scripting-Environment.html
[busybox]: https://fare.livejournal.com/184127.html
[ql]: https://www.quicklisp.org/beta/

