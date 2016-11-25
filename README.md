# xAPI

A Ruby library for implementing xAPI.

For more information about the Tin Can API visit:

http://Xapi.com/

https://github.com/adlnet/xAPI-Spec

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xapi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xapi

## Usage

Create a remote LRS using basic auth
```ruby
remote_lrs = Xapi::RemoteLRS.new do |c|
  c.end_point = 'https://some.endpoint.com'
  c.user_name = 'user'
  c.password = 'password'
end
```

Connect to the 'about' endpoint to get version information

```ruby
# use the remote LRS from above
response = remote_lrs.about
# check if it is successful
if response.success
    # access the Xapi::About instance
    response.content
end
```

Create a statement

```ruby
agent = Xapi::Agent.new(mbox: 'mailto:info@xapi.com')
verb = Xapi::Verb.new(id: 'http://adlnet.gov/expapi/verbs/attempted')
activity = Xapi::Activity.new(id: 'https://github.com/Deakin-Prime/Xapi')

statement = Xapi::Statement.new do |s|
  s.actor = agent
  s.verb = verb
  s.object = activity
end

response = remote_lrs.save_statement(statement)
if response.success
  # access the statement
  response.content
end
```

For more API calls check out the Xapi::RemoteLRS class

