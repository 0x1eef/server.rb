# frozen_string_literal: true

##
# A mixin that serves a compressed copy of a file.
# Similar to the nginx module
# [gzip_static](http://nginx.org/en/docs/http/ngx_http_gzip_static_module.html).
module Server::Gzip
  def finish(request)
    path = gzip_path(request)
    if path
      body = File.binread(path)
      extn = File.extname(path[0..-4])
      [
        200,
        {"content-type" => mime_types[extn] || Rack::Mime.mime_type(extn),
         "content-encoding" => "gzip",
         "content-length" => body.bytesize},
        body.each_line
      ]
    else
      super
    end
  end

  private

  def gzip_path(request)
    return unless request.get_header("accept-encoding")
                        &.include?("gzip")
    path = "#{find_path(request)}.gz"
    File.exist?(path) ? path : nil
  end
end
