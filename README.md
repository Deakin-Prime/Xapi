# xAPI

A Ruby library for implementing xAPIs Statements, Profiles and Querying Statements for LRS in simple way.

For more information about the Tin Can API visit:

http://Xapi.com/

For more information about the xAPI Statements Specficiations and Components visit:
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

Create a remote LRS using Account credentials
```ruby
remote_lrs = Xapi.create_remote_lrs( end_point: ''https://some.lrsdomain.com'', user_name: 'username', password: 'password' )
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

#Creating the Properties of Statement

https://github.com/adlnet/xAPI-Spec/blob/master/xAPI-Data.md

Create a Agent for a Statement

```ruby
# Parameters can be passed for create_agent are: 
# agent_type which is either Agent or Group
# Passing email, name - if agent_type is Agent
# Passing members Array with hashes having name and email as keys - if agent_type is Group

agent = Xapi.create_agent(agent_type: 'Agent', email: 'email', name: 'name')

agent = Xapi.create_agent(agent_type: 'Group', members: [ {email: 'email1', name: 'name1'},{email: 'email2', name: 'name2'}] )
```

Create a Team for Context of a Statement

```ruby
# Parameters can be passed for create_team are: object_type, statement_id 

team = Xapi.create_team(home_page: "http://some.learnactivity.com/", name: 'team_name')
```

Create a Verb for a Statement

```ruby
# Parameters can be passed for create_verb are: id, name 

verb = Xapi.create_verb(id: 'http://adlnet.gov/expapi/verbs/launched', name: 'launched')
```

Create a Object for a Statement which is either Activity, Agent, or another Statement that is the Object of the Statement.

```ruby
# Parameters can be passed for create_activity are: id, name, description, extensions

object = Xapi.create_activity(id: "http://some.learnactivity.com/conversation", 
                              name: 'Learning conversation', type: 'http://adlnet.gov/expapi/activities/assessment', 
                              description: 'Conversational Learning tool',
                              extensions: { "http://id.tincanapi.com/extension/planned-duration" => 'PT50M' }
                                   )
```

Create a Context Activities for Given Context of a Statement

```ruby
# Parameters can be passed for create_context_activites are: grouping, category, parent, other which are Array of Objects/Activitites realted to Context of a Statement

grouping_array = []
grouping_array << Xapi.create_activity( id: "http://some.learnactivity.com/topics/1", 
                                        name: 'topic title', type: "http://activitystrea.ms/schema/1.0/task"
                                      )
context_activities = Xapi.create_context_activites(grouping: grouping_array)
```

Create a Context for a Statement

```ruby
# Parameters can be passed for create_context are: registration, extensions, team, instructor, statement, context_activites

context = Xapi.create_context(registration: 'registration_id', 
                              extensions: { "http://some.learnactivity.com/extension/tags" => ["domain1", "domain2"], 
                              team: team, instructor: instructor_agent,
                              context_activities: context_activities
                            )
```

Create a Result for a Statement

```ruby
# Parameters can be passed for create_result are: scaled_score or score_details, duration, response, success, completion, extensions 

result = Xapi.create_result(response: 'response details', score_details: {min: 1, raw: 7, max: 10}, success: true, extensions: {""http://some.learnactivity.com/extension/questions" => ['question1', 'question2']})
```

Create a Statement

```ruby
# Parameters can be passed for create_remote_lrs are: actor, verb, object, context, result

statement = Xapi.create_statement(actor: agent, verb: verb, object: object, context: context, result: result)
```

Post a statement to LRS

```ruby
# Parameters can be passed for create_remote_lrs are: remote_lrs, statement

response = Xapi.post_statement(remote_lrs: remote_lrs, statement: statement)

if response.success
  # access the statement
  response.content
end

```

For more API calls check out the Xapi Module Class methods

For more API calls check out the Xapi::RemoteLRS class

