# Amy

![image](http://rachstick.files.wordpress.com/2012/04/amy-f.jpg)

Amy aims to be a documentation engine, something alike rdoc, but for REST APIs. With the motivation in mind to solve this situation, that has not much of options, specially in the ruby world.

With two mode of work, Amy can:

* Scrap a list of documentation files.
* Scrap your source code looking for special comments. ``Currently just works for sinatra``

and use this info to compose a nice website with your API docs.

At the documentation website you will be able to see the resources aggregated per each url pattern, and within them see each method, in a very REST way. In some cases, for the GET, HEAD and OPTIONS methods you will be able to run them and analise the output.

## I want to use it!

First of all, you've to understand this is in very pre alpha status, so everything can change in the near feature. But if you are still a brave man, you can take a look at [examples](examples) directory to see who to run this gem.

If you've a nice feature in mind, please submit a pull request, every contribution is wellcome.

To create the documentation website you've to run:

* ` amy [directory with the definitions] `

There is an option to create a ``.amy`` file in your main directory where you'll be able to tune a few options for the engine. Take a look at [.amy](.amy) for an example.

## TODO:

Next, and preatty obvious thing, is to write a decent documentation.
I've in mind also to extend the source code parsing capabilities to include:
* A better content management skills.
* Support for more web frameworks and programming languages.

and I'm sure many others will popup.

## Contributing to Amy
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2014 Pere Urbon-Bayes. See LICENSE.txt for further details.

