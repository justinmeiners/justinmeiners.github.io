Deploying Common Lisp Scripts
----------------------------
**3/05/22**

The popular advice for deploying Common Lisp is to [dump an image][save-image] (eg. `save-lisp-and-die`).
This works for large applications, but is cumbersome if you just want to write small scripts.
There is no reqason why Lisp can't be used just like Perl or Python:
install *a single lisp interpreter*  on your system (`/usr/local/bin/sbcl`) and  *write, run and deploy scripts* from source freely.

A step in the right direction is a `.lisp` file with anappropriate shebang.
Here is `sbcl`:

    #!/usr/bin/sbcl --script
    (write-string "Hello, World!")
    
But you'll run into a few roadblocks if try to take this further.
How do we include other source files without knowing their instllation path?
How do we load libraries?
Do we ask the user to install QuickLisp and load them here?

Here is the secret answer to all of these questions: 

**TLDR:** Hidden in QuickLisp is the **[bundle-systems][ql-bundle]** command.
It downloads your project dependencies into a standlone folder and also creates a `bundle.lisp` script in the root for loading.
All you need is `(load bundle.lisp)` and then you can use `asdf:load-system` to include dependencies transitively.
It's entirely self contained. No more QuickLisp.

### Example

This example prepares an `asdf` project (containing your source) with all it's dependencies,
and installs an executable in a system path:

1. Create a bundle containing your QuickLisp dependencies:

        (ql:bundle-systems (list "alexandria" "cl-ppcre" ...) :to "bundle/")

2. Create a `.asd` file describing your project and dependencies (see [Defining Systems with defsystem][asdf]):

        (asdf:defsystem "myapp"
            :depends-on (:alexandria :cl-ppcre ...)
            :build-pathname "myapp"
            :components (
                (:file "...")
                ...))

3. Copy your application source in the bundle, in a folder alongside it's dependencies:

        mkdir -p bundle/local-projects/myapp
        cp *.lisp bundle/local-projects/myapp
        cp *.asd bundle/local-projects/myapp

3. Install the bundle in a system path:

        cp -r bundle/ /user/local/lib/myapp

4. Create a launch script in `/usr/local/bin/` which loads the `bundle.lisp` and the asd system:

        #!/usr/bin/sbcl --script
        (load "/usr/local/lib/myapp/bundle.lisp")
        (asdf:load-system "myapp")
        (myapp:do-stuff)

That's all! When the script is run for the first time `sbcl` will compile into `.fasl` files,
and then load these on subsequent runs.

Consider automating these steps for your project, such as with `make install`. 

## Other advice you might hear

There are a myriad of articles that claim to solve this problem.
But after much research and trial and error, I found none of them to be satisfactory.

### Saving an Image

[Saving an image][save-image] can be a good solution such as when deploying an entire web application to a server.
But be warned that the image is a large binary, containing the entire Lisp compile  and your program's soruce.
For `sbcl` this is about 50 MB.

If you want to use this for every small Lisp script you write, you'll end up littering them all over the system.
In addition to size concens, it's not very maintainable.
Each installation becomes an isolated Lisp frozen in time.
To apply security updates or bug fixes in sbcl, you will need to track down and rebuild each Lisp program individually.

### QuickLisp? 

Imagine if calling `import` in Python started downloading code from the internet!
For security, and dependency management in production, its generally a good idea to separate downloading libraries,
from actually linking with them. 

In Common Lisp we have a standard tool `asdf` which solves the inclusion problem, and is included in most distributions,
On the other hand, [quicklisp][ql] is really a tool for discovering and downloading Lisp libraries.
It's great!
But you shouldn't really be distributed with your software.

Reddit user [eayse][reddit] explains this well:

> I advocate the habit of installing things with `ql:quickload`, but after initial installation, using `asdf:load-system` to actually bring the systems into memory.
> After all missing dependencies have been satisfied by network installations from the distributions configured in Quicklisp, `ql:quickload` just thunks down to ASDF.

Note that QuickLisp also distributes libraries as a rolling release of all the latest tags.
You will need to pin it to a specific commit hash to get a precise snapshot in time. 

If you do try to include QuickLisp directly you will face the headache of trying to locate and load it
either through `.sbclrc` or a system path.

### Roswell?

[Roswell][roswell] is advertised as a solution, but it's possibly the most un-Lispy tool I have ever saeen.
It doesn't download dependencies, or help you build them.
What does it do? Help you download sbcl?
Why do I have to learn a new config file syntax instead of using s-expressions?
*sigh*.

## Busybox style

The overhead of dumping an image can be shared by many scripts if you put them all in the same executable.
This technique is described for Lisp by [Fare][busybox] and [Steve][small-cli].

Disk usage looks better, but now all the scripts are coupled, and must be distributed together.

[asdf]: https://asdf.common-lisp.dev/asdf.html#Defining-systems-with-defsystem
[buildapp]: https://www.xach.com/lisp/buildapp/
[small-cli]: https://stevelosh.com/blog/2021/03/small-common-lisp-cli-programs/
[ql-bundle]: https://www.quicklisp.org/beta/bundles.html
[save-image]: https://lispcookbook.github.io/cl-cookbook/scripting.html
[reddit]: https://old.reddit.com/r/lisp/comments/iai2ab/repairing_asdf_package_storage/g1pnxdt/
[roswell]: https://roswell.github.io/Roswell-as-a-Scripting-Environment.html
[busybox]: https://fare.livejournal.com/184127.html
[ql]: https://www.quicklisp.org/beta/

