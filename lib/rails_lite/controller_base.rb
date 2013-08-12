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
  end

  def session
  end

  def already_rendered?
    @already_built
  end

  def redirect_to(url)
    @already_built = true
    @res.status = 302
    @res.header["location"] = url
  end

  def render_content(body, content_type)
    @already_built = true
    @res.body = body
    @res.content_type = content_type 
  end

  def render(template_name)
  end

  def invoke_action(name)
  end
end
