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
blog = Traver.create(blog: { title: "Blog" }) #=> #<Blog @title="Blog">
```

Define and use factories:

```ruby
Traver.define_factory(:user, {
  full_name: "Walter White"
})

Traver.define_factory(:post, {
  title: "Hello"
})

Traver.create(:user) #=> #<User @full_name="Walter White">
Traver.create(:post) #=> #<Post @title="Hello">
```

Create child factories:

```ruby
Traver.define_factory(:published_post, :post, {
  published: true
})

Traver.define_factory(:draft_post, :post, {
  published: false
})

Traver.create(:published_post) #=> #<Post @title="Hello", @published=true>
Traver.create(:draft_post)     #=> #<Post @title="Hello", @published=false>
```

Use defined factories to define more complex factorie:

```ruby
Traver.define_factory(:blog, {
  title: "My Blog"
})

Traver.define_factory(:blog_with_posts, :blog, {
  posts: [:published_post, :draft_post]
})

Traver.create(user: { blog: :blog_with_a_post }) #=> #<Post @title="Hello", @published=false>
```

Create associated object:

```ruby
blog = Traver.create(blog: {
  title: "Hello",
  user: { name: "Mike" }
})

blog.user #=> #<User @name="Mike">
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

blog.posts #=> [#<Post @title="Post #1">, #<Post @title="Post #2">]

```

Different ways to create collections:

```ruby
Traver.create(blog: { title: "Hello", posts: 2 })
Traver.create(blog: { title: "Hello", posts: [2, title: "Post #${n}"] })
Traver.create(blog: { title: "Hello", posts: [2, :published_post] })
Traver.create(blog: { title: "Hello", posts: [:published_post, :draft_post] })
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

blog.posts.first.tag.first #=> #<Tag @name="Happy">
```

Lists with sequences:

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
graph.post1 #=> #<Post>
graph.tags  #=> [#<Tag>, #<Tag>]
graph.tag1  #=> #<Tag>
graph.tag2  #=> #<Tag>

blog, post = Traver.create_graph(blog: { posts: 1 })[:blog, :post]
```

Ability to reference already created objects:

```ruby
blog = Traver.create(blog: {
  post: { tags: 1 }
  tags: [-> (graph) { graph.tag1 }]
})
```

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yukas/traver.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

