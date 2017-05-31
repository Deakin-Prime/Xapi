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

#Creating the Properties of a Statement

For more information about the Properties of a xAPI Statement visit:

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
# Parameters can be passed for create_context_activities are: grouping, category, parent, other which are Array of Objects/Activitites realted to Context of a Statement

grouping_array = []
grouping_array << Xapi.create_activity( id: "http://some.learnactivity.com/topics/1", 
                                        name: 'topic title', type: "http://activitystrea.ms/schema/1.0/task"
                                      )
context_activities = Xapi.create_context_activities(grouping: grouping_array)
```

Create a Context for a Statement

```ruby
# Parameters can be passed for create_context are: registration, extensions, team, instructor, statement, context_activities

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

## Querying Statements required from LRS

Get Statement based on statement ID

```ruby
# Parameters can be passed for get_statements_by_query are: remote_lrs, statement_query

Xapi.get_statements_by_id(remote_lrs: remote_lrs, statement_id: '2a8785a0-8ee8-41ad-9172-e194a82e30a4')
```

Get Statements based on Queries

```ruby
# Parameters can be passed for create_statement_query are: registration_id, verb_id, activity_id
# Eithe agent details: agent_email, agent_name
# or Team details: team_home_page, team_name
# Searching related statements by passing boolean values to these: search_related_agents, search_related_activities

#Based on Team
statement_query = Xapi.create_statement_query(verb_id: 'http://id.tincanapi.com/verb rated', activity_id: 'http://some.learnactivity.com/conversation', team_home_page: 'http://some.learnactivity.com', team_name: 'team_name')

#Based on Agent
statement_query = Xapi.create_statement_query(verb_id: 'http://id.tincanapi.com/verb rated', activity_id: 'http://some.learnactivity.com/conversation', agent_email: 'email', agent_name: 'name')

result_statements_response = Xapi.get_statements_by_query(remote_lrs: remote_lrs, statement_query: statement_query)

#Knowing result statements count
result_statements_response[:statements_count]

#Knowing the result statements
JSON.parse(result_statements_response[:statements].to_json) if result_statements_response[:statements_count] > 0
```

## Creating or updating the Profiles in LRS

Create/Update Activity Profile

```ruby
# Parameters can be passed for create_activity_profile are: remote_lrs, profile_id, activity_object, profile_content

activity_object = Xapi.create_activity(id: 'http://some.leranactivity.com/topics/1', name: 'title', type: 'http://activitystrea.ms/schema/1.0/task' )

profile_content = { "name"=> "title", "description" => "description", "relevance" => "relevance", "type" => "http://some.leranactivity.com/evidences/document"
                           }
Xapi.create_activity_profile(remote_lrs: remote_lrs, profile_id: 'topic profile', activity_object: activity_object, profile_content: profile_activity_content)

Xapi.update_activity_profile(remote_lrs: remote_lrs, profile_id: 'topic profile', activity_object: activity_object, profile_content: profile_activity_content)

```

Create/Update Agent Profile

```ruby
# Parameters can be passed for create_agent_profile are: remote_lrs, profile_id, agent_object, profile_content

agent_details = Xapi.create_agent(agent_type: "Agent", email: 'email', name: 'name')

profile_content = { "objectType" => "Agent", "name" =>  "name", "avatar" => "avatar image url", "age" => "age", "roles" => ["role1", "rol2"], "teams" => ["team name"] }

Xapi.create_agent_profile(remote_lrs: remote_lrs, profile_id: "user profile", agent_object: agent_details, profile_content: profile_content)

Xapi.update _agent_profile(remote_lrs: remote_lrs, profile_id: "user profile", agent_object: agent_details, profile_content: profile_content)

```

## Get the Profiles from LRS

Get Activity Profile

```ruby
# Parameters can be passed for get_activity_profile are: remote_lrs, profile_id, activity_object

activity_object = Xapi.create_activity(id: 'http://some.leranactivity.com/topics/1', name: 'title', type: 'http://activitystrea.ms/schema/1.0/task' )

Xapi.get_activity_profile(remote_lrs: remote_lrs, profile_id: "topic profile", activity_object: activity_object)
```

Get Multiple Activity Profiles for given Activity

```ruby
# Parameters can be passed for get_activity_profile are: remote_lrs, profile_id, activity_object

activity_object = Xapi.create_activity(id: 'http://some.leranactivity.com/topics/1', name: 'title', type: 'http://activitystrea.ms/schema/1.0/task' )

Xapi.get_activity_profile(remote_lrs: remote_lrs, profile_id: ["profile1", "profile2"], activity_object: activity_object)
```

Get Agent Profile

```ruby
# Parameters can be passed for get_agent_profile are: remote_lrs, profile_id, agent_object

agent_details = Xapi.create_agent(agent_type: "Agent", email: 'email', name: 'name')

Xapi.get_agent_profile(remote_lrs: remote_lrs, profile_id: "agent profile", agent_object: agent_details)

```

Get Multiple Agent Profiles for given agent

```ruby
# Parameters can be passed for get_agent_profile are: remote_lrs, profile_id, agent_object

agent_details = Xapi.create_agent(agent_type: "Agent", email: 'email', name: 'name')

Xapi.get_agent_profile(remote_lrs: remote_lrs, profile_id: ["profile1", "profile2"], agent_object: agent_details)

```

## Analytics related to Team and its Team members related to Assessment

Get Team and its members Average scores

```ruby
# Parameters can be passed for it: verb_id, activity_id, activity_type, team_name

team_analytics_query = Xapi.create_team_analytics_query(verb_id: "http://id.tincanapi.com/verb/rated", activity_type: "http://activitystrea.ms/schema/1.0/task", team_name: "Digital Learning" )

analytics_response = Xapi.get_analytics_by_query(remote_lrs: remote_lrs, team_analytics_query: team_analytics_query)

```

Get Team and its members Average scores, Activity frequency For given activity

```ruby
# Parameters can be passed for it: verb_id, activity_id, activity_type, team_name

team_analytics_query = Xapi.create_team_analytics_query(verb_id: "http://id.tincanapi.com/verb/rated", activity_type: "http://activitystrea.ms/schema/1.0/task", team_name: "Digital Learning", activity_id: "http://some.leranactivity.com/activities/1" )

analytics_response = Xapi.get_analytics_by_query(remote_lrs: remote_lrs, team_analytics_query: team_analytics_query)

```

Get Agent or Team member related all activities along with agent and its team average scores

```ruby
# Parameters can be passed for it: verb_id, agent_email, activity_type, team_name

team_analytics_query = Xapi.create_team_analytics_query(verb_id: "http://id.tincanapi.com/verb/rated", activity_type: "http://activitystrea.ms/schema/1.0/task", team_name: "Digital Learning", agent_email: "123@test.com" )

analytics_response = Xapi.get_analytics_by_query(remote_lrs: remote_lrs, team_analytics_query: team_analytics_query)

```

For more API calls check out the Xapi Module Class methods

For more API calls check out the Xapi::RemoteLRS class

