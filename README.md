# Myra

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/myra`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'myra'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install myra

## Usage

### API Key and API secret

**Note:** Both can be obtained by contacting the MyraCloud support.

The gem assumes that you store the keys in your environment:

```
ENV['MYRACLOUD_API_KEY']
ENV['MYRACLOUD_API_SECRET']
```

However, if you wish to use something different, you can configure these values yourself:

```ruby
Myra.configure do |config|
  config.api_key = 'your-key-here'
  config.api_secret = 'your-secret-here'
end
```

The gem takes the concept of value object into account. All of the available resources are value objects which you can work with. By default, the aPI supports these actions:

- List
- Create
- Update
- Delete

### List

`List` is represented by the `List` object. to list all `Domain`s, you can use:

```ruby
include Myra
list = List.new(Domain)
domains = list.perform
# => [Domain, Domain, Domain, ...]

domain[0].name
# => 'my-awesome-name.com'
```

### Rest of the CUD

TODO

## Supported version for the MyraCloud API

The currently supported version for the API is *1.4*.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

