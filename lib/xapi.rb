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

  # Parameters can be passed for create_context are: registration, extensions, team, instructor, statement
  def self.create_context(opts={})
  	opts[:language] = 'en-US'
  	Context.new(opts)
  end

  # Parameters can be passed for create_context_activites are: grouping, category, parent, other
  def self.create_context_activites(opts={})
    ContextActivities.new(opts)
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
  	duration = opts[:duration].present? ?  Duration.new(opts[:duration]) : nil
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

end