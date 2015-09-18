require 'uri'

class EnvironmentReader
  attr_reader :request

  def initialize(socket)
    read(socket)
  end

  def to_h
    {
      'REQUEST_METHOD' => request_method,
      'SCRIPT NAME'    => '',
      'PATH_INFO'      => '',
      'QUERY_STRING'   => query_string,
      'SERVER_NAME'    => server_name,
      'SERVER_PORT'    => server_port,
      '_REQUEST_URL'   => request_url
    }.merge(headers_hash)
  end

  protected

  attr_reader :request_line, :headers

  def read(socket)
    @request_line = socket.gets

    @headers = []
    while line = socket.gets.strip && line && !line.empty?
      # TODO collect size of body from Content-Length header if it exists
      @headers << line
    end

    # TODO read body if Content-Length is set
  end


  def request_line_parts
    @request_line_parts ||= request_line.split("\s")
  end

  def request_method
    request_line_parts[0].strip
  end

  def request_url
    request_line_parts[1].strip
  end

  def query_string
    URI(request_url).query
  end

  def headers_hash
    headers.each_with_object({}) do |header, hash|
      values = header.split(':')
      key = values.shift
      value = values.join(':').strip
      hash["HTTP_#{key}"] = value
    end
  end

  def protocol
    request_line_parts[2]
  end

  def server_name
    # TODO change this part
    'localhost'
  end

  def server_port
    ServerSingleton.port
  end


end

=begin
Below is the Rack specification for the env variable.  We should try to match this as much as possible.

REQUEST_METHOD
The HTTP request method, such as “GET” or “POST”. This cannot ever be an empty string, and so is always required.

SCRIPT_NAME
The initial portion of the request URL’s “path” that corresponds to the application object, so that the application
knows its virtual “location”. This may be an empty string, if the application corresponds to the “root” of the server.

PATH_INFO
The remainder of the request URL’s “path”, designating the virtual “location” of the request’s target within the
application. This may be an empty string, if the request URL targets the application root and does not have a trailing
slash. This value may be percent-encoded when I originating from a URL.

QUERY_STRING
The portion of the request URL that follows the ?, if any. May be empty, but is always required!

SERVER_NAME, SERVER_PORT
When combined with SCRIPT_NAME and PATH_INFO, these variables can be used to complete the URL. Note, however, that
HTTP_HOST, if present, should be used in preference to SERVER_NAME for reconstructing the request URL. SERVER_NAME
and SERVER_PORT can never be empty strings, and so are always required.

HTTP_ Variables
Variables corresponding to the client-supplied HTTP request headers (i.e., variables whose names begin with HTTP_).
The presence or absence of these variables should correspond with the presence or absence of the appropriate HTTP
header in the request. See <a href=“tools.ietf.org/html/rfc3875#section-4.1.18”> RFC3875 section 4.1.18</a> for
specific behavior.
=end
