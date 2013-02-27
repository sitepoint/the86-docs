require "stringio"
require "json"

class ApiExample

  # host is the string used in the Host header, e.g. example.org.
  # data is a nested structure loaded from YAML.
  def initialize(host, data)
    @host = host
    @data = data
  end

  def title
    data[:title]
  end

  def subtitle
    data[:subtitle]
  end

  # A multi-line string representation of the HTTP request.
  def http_request
    lines = []

    method, override = method_and_override(data[:action])

    lines << data[:action].sub(/^\w+/, method) + " HTTP/1.1"

    lines << "X-Http-Method-Override: #{override}" if override

    lines << "Host: #{host}"

    unless data[:authorization] == false
      lines << "Authorization: Bearer USER_ACCESS_TOKEN"
    end

    if parameters?
      lines << "Content-Type: application/json; charset=utf-8"
    end

    lines.join("\n")
  end

  # A multi-line string representation of the HTTP response.
  def http_response
    lines = []
    response = data[:response]

    lines << status_line(response)

    if response[:content_type]
      lines << "Content-Type: #{response[:content_type]}"
    end

    if response[:body]
      lines << ""
      lines << JSON.pretty_generate(JSON.parse(response.body))
    end

    lines.join("\n")
  end

  # Whether there are request parameters described.
  def parameters?
    parameters && parameters.any?
  end

  # Request parameter descriptions.
  def parameters
    @data[:parameters]
  end

  private

  attr_reader :data
  attr_reader :host

  def method_and_override(action)
    override_verbs = ["PATCH"]

    verb, path = action.split(" ")

    if override_verbs.include?(verb)
      ["POST", verb]
    else
      [verb, nil]
    end
  end

  def status_line(response_data)
    status = response_data[:status].to_i
    "HTTP/1.1 %d %s" % [status, status_text(status)]
  end

  def status_text(status)
    case status
    when 201 then "Created"
    when 200 then "OK"
    when 204 then "No Content"
    when 302 then "Found"
    else raise "Unhandled HTTP status: #{status}"
    end
  end

end
