Invite Only
==============

[![Build Status](https://travis-ci.org/mez/invite_only.png?branch=master)](https://travis-ci.org/mez/invite_only)


This gem was inspired by acts_as_tenant. I really liked the fail-safe and out-of-the-way manner of acts_as_tenant! Hence, this is a very low level abstraction layer to help deal with invites to your applications and integrates (near) seamless with Rails.

In addition, acts_as_tenant:

* auto validates on create for any model that you want invite only for.
* sets up a helper method to allow you to create invite codes.

Installation
------------
invite_only is tested for Rails 3.2 and up.

To use it, add it to your Gemfile:
  ```sh
  gem 'invite_only'
  ```

  ```sh
  bundle install
  ```
Run the generator to create the migration
  ```sh
  rails g inviter
  ```

Getting started
===============
There are three steps to get your app going with invite_only:

1. enable_invite_only on your controller.
2. call invite_only on the model you want protected.
3. add virtual attribute :invite_code

Calling enable_invite_only on your controller
--------------------------

Add the enable_invite_only to a controller to get the helper method you need to generate a code.
```ruby
  class ApplicationController < ActionController::Base
    enable_invite_only
  end
```
Now you will have a helper method called 'create_invite_code_for(identifier)'. The identifier is the string you use to uniquely identify the model. For example a User.email or User.username. Any string you want to id with. For example..

```ruby
  code = create_invite_code_for('foo@bar.com')
```

Calling invite_only on your model
-------------------
```ruby
  class User < ActiveRecord::Base
    invite_only(:email)
  end
```

'invite_only(identifier=:email)' used in the model. Here identifier is the column the model uses as the identifier. invite_only defaults to :email, but in case you want to use for example :username or anything you like you can. This is used during the validation as the attribute to use for look up.

Adding virtual attribute :invite_only
-------------------
```ruby
  class User < ActiveRecord::Base
    invite_only(:email)
    attr_accessor :invite_code
  end
```

Thats it! Now whenever you try to save an invite_only model, it will not work unless you have the correct :invite_code. How you pass the value to the model is up to you. Simply just add the text field for the code in the form_for the model you are interested in.

To disable all this, simple remove the 'invite_only' call from the model.

Configuration options
---------------------

You can control the different types of validation messages you can display. The attributes you have to create readers for are the following below.

```ruby
attr_writer :code_blank_message,
            :code_invalid_message,
            :code_identifier_invalid_message,
            :code_already_used_message
```


The default validation error messages you get out of the box are.


| attribute name                    | Default                                           |
|-----------------------------------|---------------------------------------------------|
| :code_blank_message               | "is missing."                                     |
| :code_invalid_message             | "does not work with that #{identifier.to_s}."     |
| :code_identifier_invalid_message  | "is not valid."                                   |
| :code_already_used_message        | "has already been used."                          |

An example of setting your own error message is below

```ruby
  class User < ActiveRecord::Base
    invite_only(:email)

    protected
    def code_blank_message
      'code is blank'
    end
  end
```


To Do
-----
* Add support for mongodb

Bug reports & suggested improvements
------------------------------------
If you have found a bug or want to suggest an improvement, please use our issue tracked at:

[github.com/mez/invite_only/issues](http://github.com/mez/invite_only/issues)

If you want to contribute, fork the project, code your improvements and make a pull request on [Github](http://github.com/mez/invite_only/). When doing so, please don't forget to add tests. If your contribution is fixing a bug it would be perfect if you could also submit a failing test, illustrating the issue.

License
-------
Copyright (c) 2014 Mez Gebre, released under the MIT license
