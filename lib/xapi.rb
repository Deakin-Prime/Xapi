# encoding: utf-8
require 'xapi/errors'
require 'xapi/enum'
require 'xapi/version'
require 'xapi/interaction_type'
require 'xapi/about'
require 'xapi/agent_account'
require 'xapi/agent'
require 'xapi/group'
require 'xapi/team'
require 'xapi/verb'
require 'xapi/interaction_component'
require 'xapi/documents/document'
require 'xapi/score'
require 'xapi/result'
require 'xapi/attachment'
require 'xapi/activity_definition'
require 'xapi/activity'
require 'xapi/context_activities'
require 'xapi/context'
require 'xapi/statements/statements_base'
require 'xapi/statement'
require 'xapi/sub_statement'
require 'xapi/statement_ref'
require 'xapi/statements_query'
require 'xapi/team_analytics_query'
require 'xapi/statements_query_v095'
require 'xapi/lrs_response'
require "xapi/remote_lrs"
require 'xapi/statements_result'

begin
  require 'pry'
rescue LoadError
end

module Xapi
  
  # Parameters can be passed for create_agent are: 
  # agent_type which is either Agent or Group
  # email, name
  # members[] with hashes having name and email details. This will be given if agent_type is Group
  def self.create_agent(opts={})
    if opts[:agent_type].eql?("Agent")
      Agent.new(mbox: "mailto:#{opts[:email]}", name: "#{opts[:name]}")
    else
      Group.new(members: opts[:members].map{|member| Agent.new(mbox: "mailto:#{member[:email]}", name: "#{member[:name]}") })
    end
  end

  # Parameters can be passed for create_verb are: id, name
  def self.create_verb(opts={})
  	Verb.new(id: opts[:id], display: {"en-US": opts[:name]})
  end

  # Parameters can be passed for create_activity are: id, name, description, extensions
  def self.create_activity(opts={})
  	activity_definition = ActivityDefinition.new(name: {"en-US"=>opts[:name]}, type: opts[:type])
  	activity_definition.description = {"en-US" => opts[:description]} if opts[:description].present?
  	activity_definition.extensions = opts[:extensions] if opts[:extensions].present?
  	Activity.new(id: opts[:id], definition: activity_definition)
  end

  # Parameters can be passed for create_context_activities are: grouping, category, parent, other
  def self.create_context_activities(opts={})
    ContextActivities.new(opts)
  end

  # Parameters can be passed for create_context are: registration, extensions, team, instructor, statement, context_activities
  def self.create_context(opts={})
  	opts[:language] = 'en-US'
  	Context.new(opts)
  end

  # Parameters can be passed for create_team are: home_page, name
  def self.create_team(opts={})
  	team_account = AgentAccount.new(home_page: opts[:home_page], name: opts[:name])
  	Team.new(object_type: "Group", account: team_account)
  end

  # Parameters can be passed for create_team are: object_type, statement_id
  def self.create_statement_ref(opts={})
  	StatementRef.new(object_type: opts[:object_type], id: opts[:statement_id])
  end

	# Parameters can be passed for create_result are: scaled_score or score_details, duration, response, success, completion, extensions 
  def self.create_result(opts={})
  	score = nil
  	if opts[:scaled_score].present?
  		score = Score.new(scaled: opts[:scaled_score])
  	elsif opts[:score_details].present?
  		score = Score.new(raw: opts[:score_details][:raw], min: opts[:score_details][:min], max: opts[:score_details][:max])
  	end
  	duration = opts[:duration].present? ?  opts[:duration] : nil
  	result = Result.new(duration: duration, score: score)
    result.response = opts[:response] if opts[:response].present?
    result.success = opts[:success] if opts[:success].present?
    result.completion = opts[:completion] if opts[:completion].present?
    result.extensions = opts[:extensions] if opts[:extensions].present?
    result
  end

  # Parameters can be passed for create_remote_lrs are: end_point, user_name, password
  def self.create_remote_lrs(opts={})
  	RemoteLRS.new(end_point: opts[:end_point], user_name: opts[:user_name], password: opts[:password])
  	# lrs_auth_response = remote_lrs.about
  	# lrs_auth_response.success ? remote_lrs : nil
  end

  # Parameters can be passed for create_remote_lrs are: actor, verb, object, context, result 
  def self.create_statement(opts={})
  	statement = Statement.new(actor: opts[:actor], verb: opts[:verb], object: opts[:object])
  	statement.context = opts[:context] if opts[:context].present?
    statement.result = opts[:result] if opts[:result].present?
    statement
  end

  # Parameters can be passed for create_remote_lrs are: remote_lrs, statement
  def self.post_statement(opts={})
  	opts[:remote_lrs].save_statement(opts[:statement])
  end

  # Parameters can be passed for create_statement_query are: registration_id, verb_id, activity_id, agent_email, agent_name, team_home_page, team_name, search_related_agents, search_related_activities
  def self.create_statement_query(opts={})
    StatementsQuery.new do |s|
      s.registration = opts[:registration_id] if opts[:registration_id].present?
      s.activity_id = opts[:activity_id] if opts[:activity_id].present?
      s.related_activities = opts[:search_related_activities] if opts[:search_related_activities].present?
      agent_object = opts[:agent_email].present? ? create_agent(agent_type: "Agent", email: opts[:agent_email], name: opts[:agent_name]) : create_team(home_page: opts[:team_home_page], name: opts[:team_name])
      s.agent = agent_object if agent_object.present?
      s.related_agents = opts[:team_name].present? ? true : opts[:search_related_agents]
      s.verb_id = opts[:verb_id] if opts[:verb_id].present?
    end
  end

  # Parameters can be passed for get_statement_by_id are: remote_lrs, statement_id
  def self.get_statements_by_id(opts={})
    response = opts[:remote_lrs].retrieve_statement(opts[:statement_id])
    response.status == 200 ? response.content : nil
  end

  # Parameters can be passed for get_statements_by_query are: remote_lrs, statement_query
  def self.get_statements_by_query(opts={})
    response = opts[:remote_lrs].query_statements(opts[:statement_query])
    statements = response.content.statements if response.status == 200 && response.content.present?
    statements.present? ? {statements_count: statements.count, statements: statements} : {statements_count: 0, statements: nil}
  end

  # Parameters can be passed for create_team_analytics_query are: registration_id, verb_id, activity_id, activity_type, team_name, agent_email
  def self.create_team_analytics_query(opts={})
    TeamAnalyticsQuery.new do |s|
      s.registration = opts[:registration_id] if opts[:registration_id].present?
      s.activity_id = opts[:activity_id] if opts[:activity_id].present?
      s.activity_type = opts[:activity_type] if opts[:activity_type].present?
      s.verb_id = opts[:verb_id] if opts[:verb_id].present?
      s.team_name = opts[:team_name] if opts[:team_name].present?
      s.agent_email = opts[:agent_email] if opts[:agent_email].present?
    end
  end

  # Parameters can be passed for get_team_analytics_by_query are: remote_lrs, team_analytics_query
  def self.get_team_analytics_by_query(opts={})
    response = opts[:remote_lrs].query_team_analytics(opts[:team_analytics_query])
    response.content
  end

  # Parameters can be passed for create_activity_profile are: remote_lrs, profile_id, activity_object, profile_content
  def self.create_activity_profile(opts={})
    profile_data = Documents::ActivityProfileDocument.new do |pdata|
      pdata.id = opts[:profile_id]
      pdata.activity = opts[:activity_object]
      pdata.content_type = "application/json"
      pdata.content =opts[:profile_content] .to_json
    end
    opts[:remote_lrs].save_activity_profile(profile_data)
  end

  # Parameters can be passed for get_activity_profile are: remote_lrs, profile_id, activity_object
  def self.get_activity_profile(opts={})
    response = opts[:remote_lrs].retrieve_activity_profile(opts[:profile_id], opts[:activity_object])
    response.status == 200 ? response.content : nil
  end

  # Parameters can be passed for update_activity_profile are: remote_lrs, profile_id, activity_object, profile_content
  def self.update_activity_profile(opts={})
    profile_data = Documents::ActivityProfileDocument.new do |pdata|
      pdata.id = opts[:profile_id]
      pdata.activity = opts[:activity_object]
      pdata.content_type = "application/json"
      pdata.content = opts[:profile_content] .to_json
    end
    existing_activity_profile = get_activity_profile(remote_lrs: opts[:remote_lrs], profile_id: opts[:profile_id], activity_object: opts[:activity_object])
    opts[:remote_lrs].delete_activity_profile(profile_data) if existing_activity_profile.present?
    profile_data.content = opts[:profile_content].to_json
    opts[:remote_lrs].save_activity_profile(profile_data)
  end

  # Parameters can be passed for create_agent_profile are: remote_lrs, profile_id, agent_object, profile_content
  def self.create_agent_profile(opts={})
    profile_data = Documents::AgentProfileDocument.new do |pdata|
      pdata.id = opts[:profile_id]
      pdata.agent = opts[:agent_object]
      pdata.content_type = "application/json"
      pdata.content = opts[:profile_content] .to_json
    end
    opts[:remote_lrs].save_agent_profile(profile_data)
  end

  # Parameters can be passed for get_agent_profile are: remote_lrs, profile_id, agent_object
  def self.get_agent_profile(opts={})
    response = opts[:remote_lrs].retrieve_agent_profile(opts[:profile_id], opts[:agent_object])
    response.status == 200 ? response.content : nil
  end

  # Parameters can be passed for create_agent_profile are: remote_lrs, profile_id, agent_object, profile_content
  def self.update_agent_profile(opts={})
    profile_data = Documents::AgentProfileDocument.new do |pdata|
      pdata.id = opts[:profile_id]
      pdata.agent = opts[:agent_object]
      pdata.content_type = "application/json"
      pdata.content = opts[:profile_content] .to_json
    end
    existing_agent_profile = get_agent_profile(remote_lrs: opts[:remote_lrs], profile_id: opts[:profile_id], agent_object: opts[:agent_object])
    opts[:remote_lrs].delete_agent_profile(profile_data) if existing_agent_profile.present?
    profile_data.content = opts[:profile_content].to_json
    opts[:remote_lrs].save_agent_profile(profile_data)
  end

end
