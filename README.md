# Myra

This gem allows for interaction with [MyraClouds](https://myracloud.com) API.

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
### Domains

#### List

```ruby
list = Myra::Domains.list
# => [Domain, Domain, Domain, ...]

domain[0].name
# => 'my-awesome-name.com'
```
#### Create

```ruby
domain = Myra::Domain.new
domain.name = "www.kloeckner-i.com"
puts domain.id
# => nil
# [...]
domain = Myra::Domains.create(domain)
puts domain.id
```

#### Update

```ruby
list = Myra::Domains.list
# => [Domain, Domain, Domain, ...]

domain_to_update = domains.first
domain_to_update.name = "foobar.com"
Myra::Domains.update(domain_to_update)
```

#### Delete

```ruby
# if you don't know the id, just fetch them first
domain = Myra::Domain.new(id: 1234)
Myra::Domains.delete domain
```

## Supported version for the MyraCloud API

The currently supported version for the API is *1.4*.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

