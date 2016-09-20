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

A domain is the top level entity available. They cannot easily be edited, as only the `autoUpdate` can be set via API. Removing them will affect all the DNS records attached to that domain, so be extra careful.

#### List

```ruby
list = Myra::Domains.list
# => [Domain, Domain, Domain, ...]

domain[0].name
# => 'my-awesome-name.com'
```

`list` takes one parameter which determines the `page` to be shown.

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

Updating can only change the `autoUpdate` flag on a domain, if you need more extended editing, remove and recreate the domain (this is a limitation of the API)

```ruby
list = Myra::Domains.list
# => [Domain, Domain, Domain, ...]

domain_to_update = domains.first
domain_to_update.auto_update = !domain_to_update.auto_update
Myra::Domains.update(domain_to_update)
```

#### Delete

:warning: Deleting a domain is *dangerous*, as it will remove _all_ associated DNS records and other settings as well. 

```ruby
# if you don't know the id, just fetch them first
domain = Myra::Domain.new(id: 1234)
Myra::Domains.delete domain
```

### DNS Records

A DNS record comes in the form of `Myra::DnsRecord` and always belongs to a domain.

#### List

```ruby
domain = Myra::Domain.new id: 1
records = Myra::DnsRecords.list(domain)
# => [Myra::DnsRecord, Myra::DnsRecord, ...]
```


`list` takes one additional parameter which determines the `page` to be shown.

#### Create

```ruby
domain = Myra::Domain.new id: 1
record = Myra::DnsRecord.new
record.name = 'foo' # full name will be infered from the domain you are creating it for
record.value = 'foo-bar-com.zep.ag'
record.type = Myra::DnsRecord::Type::CNAME # defaults to 'A'
Myra::DnsRecords.create(record, domain)
```

#### Update

```ruby
# get a domain, etc.
record = Myra::DnsRecords.list(domain).first
record.name = 'foo' # full name will be infered from the domain you are creating it for
record.value = 'foo-bar-com-2.zep.ag'
Myra::DnsRecords.update(record, domain)
```

#### Delete

```ruby
# get a domain, etc.
record = Myra::DnsRecords.list(domain).first
Myra::DnsRecords.delete(record, domain)
```

### Errors

All actions will raise proper errors when the API responds with an error. All violations will be presented as a `Myra::Violation` attached to the error. 

#### Wrong credentials

If the API cannot be authenticated against, a `Myra::APIAuthError` will be thrown. Check your credentials of you encounter this error.

#### Failed API action

If an action against the API fails, a `Myra::APIActionError` will be thrown. 

```ruby
domain = Myra::Domain.new
domain.name = '.ff..'
begin
  Myra::Domain.create(domain)
rescue Myra::APIActionError => e
  puts e.message
  puts e.violations # => [Myra::Violation, Myra::Violation, ...]
end
```

## Supported version for the MyraCloud API

The currently supported version for the API is *1.4*.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

