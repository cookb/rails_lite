require 'uri'

class Params
  def initialize(req, route_params)
    @params = {}
    @params.merge(parse_www_encoded_form(req.query_string)) if req.query_string
    @params.merge(parse_www_encoded_form(req.body)) if req.body
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_json.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    parsed_query = URI.decode_www_form(www_encoded_form)
    params = {}
    parsed_query.each do |keyval|
      if parse_key(keyval[0]).length == 1
        params[ keyval[0] ] = keyval[1]
      else
        parse = parse_key(keyval[0])
        params[ parse[0] ] ||= {}
        params[ parse[0] ][ parse[1] ] = keyval[1]
      end
    end
    params
  end

  def parse_key(key)
    start = key.split("[")
    start.each { |subkey| subkey.gsub!("]", "") }
    start
  end
end
