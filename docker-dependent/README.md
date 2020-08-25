# You're Still Dependent with Docker

"Dependencies" are named as such because they make you dependent, in other words
relient, on another party.
If that party fails to act properly, your project breaks (or at least your build.)
Good engineers recognize this, and carefully consider the technical qualities of their dependencies
. Is this good and secure code? Does it support platforms XYZ? Is it actively developed?
But what is often overlooking is that software dependency is also a social 
relationship. Any of the following events in another person's life could make it hard to acquire your dependency when you need and have a dramatic effect on your project:
- no longer paying for servers
- leaving due to a health or family emergency
- change in business prioerities or budget.
- being locked out of a Github account
- not following version conventions
- SSL/domain expiration
- server down for maintainence
- moving on to new interests
- rewriting the project,
Do you trust your dependency authors to handle these well?

These kinds of events become inevitable over decades, so that the internet is constantly changing.
The state of the interent is often compared to a glacier, slowly melting and transforming overtime.
In a single day, most things stay the same, to the point of being immeasurably different, but overtime little changes result in data being permanantly lost or displaced. Open source software is of course living in this glacier. Left alone, software projects melt away and can no longer be built from source.

[![glacier](glacier.jpg)][1]

## Does Docker solve this?

Specifying docker images feels really good, and seems like a solution.
You get all those dependencies wrangled, down to the exact OS version, in a nicely wrapped package which anyone can run anywhere.
But does this mean your image will always build in exactly the same way?
Does this remove your project from the glacier?

![john carmack tweet](john.png)

It doesn't take much thought to realize the answer is no.
All it does is lock down the list of URLs you depend on, the contents of which must still be relied.
This has not been made explicity, and Docker leads you to think you no longer have to worry about this.
In fact, it introduces a few additional parties you need to depend on, like Docker and Docker Hub itself.

## What Docker doesn't Archive

The following are examples of parties that your docker image implicitly relies on to continue building.

**Linux Kernel**

Docker containers share the kernel with the host operating system. They must remain sufficently similar to be compatible.

**Docker Hub**

If you didn't specify an exact version of your base image, docker hub may update the image, and it may behave
in new unexpected ways. Ditto for the entire inheritence chain.
If you did specify the exacty image version, docker hub must continue to host that image version.

**Built-in OS Packages (Like Debian)**

The packages included in `apt` are hosted by the debian project.
They must continue to host these for your OS.
Note that even if they host these for a long time, at a certain point the debian project itself loses the ability to update or build these packages. They pull from URLs and repositories all across the internet to create their packages. For an older release, I suspect a large percentage of them are long gone.

**Direct URL References**

Many build processes pull directly from GitHub repositories or release tars.
If your docker file references any external URLs through an `ADD` or a URL is used to add another repostitory to `apt`, then you are dependent on those being accessible.

Of course, we can expect a lot of these projects to be around for a very long time,
This is not much of a worry if you work on your software regularly, and can keep up with updates.
But, they won't be around forever. In fact, there are so many parts in modern project it's likely at least one 
of these will have an issue or significant change every year.

## What does Docker do?

Docker is useful for developing replicable and automated build processes and provides a formal way of specifying these.
It allows the entire installation process for an application to be run in a clean environment, and then
shutdown and thrown away.

But, this has nothing to do with locking down dependencies or creating an archive of the ecosystem necessary to build your app. In short, with docker you are still dependent.


(1) Using docker 

1) Saving a tar of a built Docker image may be good way to archive.

[1]: https://commons.wikimedia.org/wiki/File:Quelccaya_Glacier.jpg
