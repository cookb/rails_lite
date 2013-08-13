require 'erb'
require 'active_support/inflector'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = {})
    @already_built = false
    @req = req
    @res = res
    @params = Params.new(req, route_params)
  end

  def session
    @session ||= Session.new(@req) 
  end

  def already_rendered?
    @already_built
  end

  def redirect_to(url)
    @already_built = true
    session.store_session(@res)
    @res.status = 302
    @res.header["location"] = url
  end

  def render_content(body, content_type = "text/text")
    @already_built = true
    session.store_session(@res)
    @res.body = body
    @res.content_type = content_type 
  end

  def render(action_name)
    action_string = File.read("./views/#{self.class.to_s.underscore}/#{action_name}.html.erb")
    template = ERB.new(action_string)
    template_result = template.result(binding)
    render_content(template_result)
  end

  def invoke_action(action_name)
  end
end
