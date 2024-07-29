# frozen_string_literal: true

##
# {Server::Dir Server::Dir} provides a rack application that
# serves the contents of a directory
class Server::Dir
  prepend Server::Gzip

  def initialize(root)
    @root = File.realpath(root)
    @mime_types = {".ttf" => "font/ttf"}.freeze
  end

  def call(env)
    catch(:redirect) { finish Rack::Request.new(env) }
  rescue Errno::EPERM, Errno::EACCES
    body = "Permission denied"
    [403, {"content-length" => body.bytesize, "content-type" => "text/plain"}, [body]]
  rescue Errno::ENOENT
    body = "The requested URL was not found"
    [404, {"content-length" => body.bytesize, "content-type" => "text/plain"}, [body]]
  rescue => ex
    body = "Internal server error (#{ex.class})"
    [500, {"content-length" => body.bytesize, "content-type" => "text/plain"}, [body]]
  end

  def finish(req)
    path = resolve_path(req)
    body = File.binread(path)
    extn = File.extname(path)
    [
      200,
      {"content-type" => mime_types[extn] || Rack::Mime.mime_type(extn),
       "content-length" => body.bytesize},
      body.each_line.to_a
    ]
  end

  private

  attr_reader :root, :mime_types

  def resolve_path(req)
    path = File.join root, File.expand_path(req.path)
    return path unless File.directory?(path)
    if req.path.end_with?("/")
      File.join(path, "index.html")
    else
      throw(:redirect, [301, {"Location" => "#{req.path}/"}, [""]])
    end
  end
end
