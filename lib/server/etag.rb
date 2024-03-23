# frozen_string_literal: true

##
# A middleware that adds ETag support.
class Server::ETag < Rack::ETag
  ETAGS = {}

  ##
  # @param [#call] app
  #  A rack app.
  #
  # @return [Server::ETag]
  #  Reurns an instance of {Server::ETag Server::ETag}.
  def initialize(app)
    @app = app
  end

  ##
  # @param [Hash] env
  #  An environment hash.
  #
  # @return [Array<Number, Hash, #each>]
  def call(env)
    status, headers, body = super(env)
    if headers["etag"] && headers["etag"] == env["HTTP_IF_NONE_MATCH"]
      [304, headers, [""]]
    else
      [status, headers, body]
    end
  end
end
