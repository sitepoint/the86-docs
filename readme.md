The86: API Documentation
========================

Documentation for The86 API
built using [Middleman](http://middlemanapp.com/)
which is [on GitHub](https://github.com/middleman/middleman).

The86 is the conversation API powering [Podling.com](https://podling.com/).

There are client libraries:

* [the86-client](https://github.com/sitepoint/the86-client) for Ruby.
* [the86-php](https://github.com/sitepoint/the86-php) for PHP 5.3+


Working on the documentation
----------------------------

* Install Ruby 1.9.3+, I recommend using [rbenv](https://github.com/sstephenson/rbenv/).
* Install Bundler: `gem install bundler && rbenv rehash`
* In this directory, use bundler to install middleman and dependencies: `bundle install`
* Start middleman in server mode while authoring: `bundle exec middleman server`


Building and deploying
----------------------

* Follow the “Working on the documentation steps”.
* Build the site with `bundle exec middleman build`.
* Upload the built site to a static web server.


License
-------

© SitePoint Pty. Ltd.
