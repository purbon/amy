# Amy

Amy is a documentation robot, able to scrap a set of specification files and compose a nice ( more or less ),
set of web pages. Oriented to solve the problem of getting a nice documentation of your next REST-API, specially in 
the case of Ruby there is no good option available.

![image](http://rachstick.files.wordpress.com/2012/04/amy-f.jpg)

## I want to use it!

First of all, you've to understand thisis my little playground, so I make new features as I need it, so feel free to 
copy and adapt whatever are your need, and if you think this is nice for more people do a pull request.

But if you just want to use it, you've to create a directoy with the next set of files:

__specs.def__

`
{
    "maps": "The Map resource",
    "elements" : "The markers and map outlier resource"
}
`

where the key is the resource description and the value is the title of the resource.

Then for each resource, there have to be a directory with the next set of files:

__resource.def__

`[
    {
        "params": [
            "_num_",
            "_num_",
         ],
        "location": "box/"
    }
]`

This is a list of resources under a main one, for example in our case resourcxes relative to the map big one. 
Important things here are params, the url parameters after the main one definition, and location, the directory where
the definition of each verb is located.

Then for each verb we should have a directory that looks like:

* maps/
  * resource.def
  * box/
     * get.def
     * put.def
     * ...

so each file inside the box directory is handcrafted, nowaday using a the markdown syntax, however for later versions I
plan to extend it to be able to use another syntax, event a custom one.

the examples directory of this project, containts an example set of files.

After you have your definition directory, the usage is very simple

` amy [directory with the definitions] `


## Contributing to Amy
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Pere Urbon-Bayes. See LICENSE.txt for
further details.

