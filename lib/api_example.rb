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
    request = data[:request]

    verb, override = method_and_override(request[:verb])

    lines << "%s %s HTTP/1.1" % [verb, request[:path]]

    lines << "X-Http-Method-Override: #{override}" if override

    lines << "Host: #{host}"

    (request[:headers] || {}).each_pair do |key, value|
      lines << "#{key}: #{value}"
    end

    if request[:data]
      lines << "Content-Type: application/json; charset=utf-8"
      lines << ""
      lines << JSON.pretty_generate(request[:data])
    end

    lines.join("\n")
  end

  # A multi-line string representation of the HTTP response.
  def http_response
    lines = []
    response = data[:response]

    lines << status_line(response)

    (response[:headers] || {}).each_pair do |key, value|
      lines << "#{key}: #{value}"
    end

    if response[:body] && response[:body].match(/\S+/)
      lines << ""
      lines << JSON.pretty_generate(JSON.parse(response[:body]))
    end

    lines.join("\n")
  end

  private

  attr_reader :data
  attr_reader :host

  def method_and_override(verb)
    override_verbs = ["PATCH"]

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
    when 422 then "Unprocessable Entity"
    else raise "Unhandled HTTP status: #{status}"
    end
  end

end
