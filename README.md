# Traver [![Build Status](https://travis-ci.org/yukas/traver.svg?branch=master)](https://travis-ci.org/yukas/traver)

Traver is a test data generation framework.

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

Create an object with attributes:

```ruby
blog = Traver.create(blog: { title: "Blog" }) # => #<Blog @title="Blog">
```

Define and use factories:

```ruby
Traver.factory(:post, {
  title: "Hello"
})

Traver.factory(:published_post, :post, {
  published: true
})

Traver.factory(:draft_post, :post, {
  published: false
})

Traver.create(:published_post) # => #<Post @title="Hello", @published=true>
Traver.create(:draft_post)     # => #<Post @title="Hello", @published=false>
```

Create associated objects:

```ruby
blog = Traver.create(blog: {
  title: "Hello",
  user: { name: "Mike" }
})

blog.user # => #<User @name="Mike">
```

Create object collections:

```ruby
blog = Traver.create(blog: {
  title: "Hello",
  posts: [
    { title: "Post #1" },
    { title: "Post #2" }
  ]
})

blog.posts # => [#<Post @title="Post #1">, #<Post @title="Post #2">]

# More concise syntax
blog = Traver.create(blog: {
  title: "Hello",
  posts: [2, title: "Post #${n}"]
})

blog.posts # => [#<Post @title="Post #1">, #<Post @title="Post #2">]

# Having defined factory
Traver.factory(post: { title: "Post #${n}"})

# Even more concise
blog = Traver.create(blog: { title: "Hello", posts: 2 })

blog.posts # => [#<Post @title="Post #1">, #<Post @title="Post #2">]

```

Any level of nesting:

```ruby
blog = Traver.create(blog: {
  title: "Blog",
  posts: [{
    title: "Hello",
    tags: [{ name: "Happy" }]
  }]
})

blog.posts.first.tag.first # => #<Tag @name="Happy">
```

Create lists:

```ruby
users = Traver.create_list(:user, 2, email: "user${n}@mail.me")
# => [#<User @email="user1@mail.me">, #<User @email="user2@mail.me">]
```

Graph is a convenient way to reference created objects:

```ruby
graph = Traver.create_graph(blog: { posts: [{ tags: 2 }] })

graph.blog  # => #<Blog>
graph.posts # => [#<Post>]
graph.post1 # => #<Post>
graph.tags  # => [#<Tag>, #<Tag>]
graph.tag1  # => #<Tag>
graph.tag2  # => #<Tag>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yukas/traver.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

