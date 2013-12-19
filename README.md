Rails Lite
=

This is an implementation of some of the features of Rails, written to understand Rails and its implementation of MVC better. It includes a reimplementation of part of ActiveRecord.

Currently, it supports, with syntax similar but not identical to Rails:

* Controllers
* Views
* Routes with wildcards in them
* render, redirect_to
* link_to, button_to
* session, flash
* Url helpers like `user_url`, as long as they don't take arguments
* All views inherit from views/layouts/application.html.erb

And the following methods of ActiveRecord:
* Has many, belongs to, has many through
* Where, save, all, find

It comes with a web app in it, which demonstrates the `index`, `new`, `create`, and `show` methods of ActiveRecord.
