# Traver [![Build Status](https://travis-ci.org/yukas/traver.svg?branch=master)](https://travis-ci.org/yukas/traver)

## Advantages
#### Concise syntax

FactoryGirl:
```ruby
user = FactoryGirl.create(:user)
blog = FactoryGirl.create(:blog, user: user)
posts = FactoryGirl.create_list(:post, 2, blog: blog, user: user)
```

Traver:
```ruby
FactoryGirl.create(:user, blog: { posts: 2 })
```

#### Ability to setup data inside specs

Thanks to concise syntax, you're able to setup data inside the spec itself, opposite to factory file, so you'll see all setup at a glance.

#### No centralized setup

As soon as all setup happening in the spec itself, no more braking specs when you change one factory.

## Installation

```shell
gem install traver
```

or add the following line to Gemfile:

```ruby
gem 'traver'
```

and run `bundle install` from your shell.

## Usage

Create object with attributes:

```ruby
blog = Traver.create(blog: { title: "Blog" }) #=> #<Blog @title="Blog">
```

Define and use factories:

```ruby
Traver.factories do
  factory :user, {
    full_name: "Walter White"
  }
  
  factory :post, {
    title: "Hello"
  }
end

Traver.create(:user) #=> #<User @full_name="Walter White">
Traver.create(:post) #=> #<Post @title="Hello">
```

Define child factories:

```ruby
Traver.factories do
  factory :post, {
    title: "Hello"
  }

  factory :published_post, :post, {
    published: true
  }
  
  factory :draft_post, :post, {
    published: false
  }
end

Traver.create(:published_post) #=> #<Post @title="Hello", @published=true>
Traver.create(:draft_post)     #=> #<Post @title="Hello", @published=false>
```

Create associated objects:

```ruby
blog = Traver.create(blog: {
  title: "Hello",
  user: { name: "Mike" }
})

blog.user #=> #<User @name="Mike">
```

Create associated objects using factory names:

```ruby
Traver.factory(:mike, :user, {
  name: "Mike"
})

blog = Traver.create(blog: {
  title: "Hello",
  user: :mike
})

```

Create associated collections:

```ruby
blog = Traver.create(blog: {
  title: "Hello",
  posts: [
    { title: "Post #1" },
    { title: "Post #2" }
  ]
})

blog.posts #=> [#<Post @title="Post #1">, #<Post @title="Post #2">]

```

Create associated collections using numbers:

```ruby
Traver.create(blog: { title: "Hello", posts: 2 })
Traver.create(blog: { title: "Hello", posts: [2, title: "Post #${n}"] })
Traver.create(blog: { title: "Hello", posts: [2, :published_post] })
```

Create associated collections using factory names:

```ruby
Traver.create(blog: { title: "Hello", posts: [:published_post, :draft_post] })
```

Create associated with already existing objects:

```ruby
Traver.create(blog: { title: "Hello", posts: [post1, post2] })
```

### Reusing associations

Traver reuses already created objects for similar associations:

```ruby
class Blog
  belongs_to :user
  has_many   :posts
end
  
class Post
  belongs_to :user
end
```
```ruby
blog = Traver.create(blog, posts: 1) # => blog.user == blog.posts.first.user
```

We can explicitly specify to create separate users for blog and a post:

```ruby
blog = Traver.create(blog, posts: [ { user: 1 } ]) # => blog.user != blog.posts.first.user
```

Create lists with sequences:

```ruby
users = Traver.create_list(2, user: { email: "user${n}@mail.me" })
#=> [#<User @email="user1@mail.me">, #<User @email="user2@mail.me">]

users = Traver.create_list(2, :published_post)
#=> [#<Post @published=true>, #<User @published=true>]
```

Graph is a convenient way to reference created objects:

```ruby
graph = Traver.create_graph(blog: { posts: [{ tags: 2 }] })

graph.blog  #=> #<Blog>

graph.posts #=> [#<Post>]
graph.post  #=> #<Post>
graph.post1 #=> #<Post>

graph.tags  #=> [#<Tag>, #<Tag>]
graph.tag   #=> #<Tag>
graph.tag1  #=> #<Tag>
graph.tag2  #=> #<Tag>

# Delegates attributes:
graph.blog_title  #=> "Hello"
graph.blog1_title #=> "Hello"

graph.post_tag_title #=> "Tag"
graph.post1_tag1_title #=> "Tag"

# Delegates methods:
graph.tags_length #=> 2
```

Use procs for dynamic attribute values:

```ruby
blog = Traver.create(event: {
  start_at:  -> { 1.day.ago },
  finish_at: -> object { object.start_at + 2.days }
})
```

Procs executed in the context of created object.

## Rails

By default Traver loads factories from`test/factories.rb` or `spec/factories.rb` for rspec users.

Objects for `belongs_to` associations are created automatically:

```ruby
class Blog < ActiveRecord::Base
  has_many :blogs
end

class Post < ActiveRecord::Base
  belongs_to :blog
end

post = Traver.create(:post) #=> #<Post>
post.blog #=> #<Blog>
```

## Plays well with FactoryGirl

If you want to try out Traver for your new specs and keep using FactoryGirl for the old ones, no problem with that. Traver will detect FactoryGirl and will searching for factories inside `spec/traver_factories.rb` or `test/traver_factories.rb`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yukas/traver.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

