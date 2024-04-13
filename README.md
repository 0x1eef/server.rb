## About

server.rb is a static file web server implemented with 
[puma](https://github.com/puma/puma) 
and 
[rack](https://github.com/rack/rack).

## Example

### Server.dir

[`Server.for`](http://0x1eef.github.io/x/server.rb/Server.html#for-class_method)
returns an object that can serve the contents
of a directory over HTTP:

```ruby
require "server"
server = Server.for File.join(Dir.getwd, "website")
server.start(block: true)
```

## Documentation

A complete API reference is available at
[0x1eef.github.io/x/server.rb](https://0x1eef.github.io/x/server.rb).

## Install

**Rubygems.org**

server.rb can be installed via rubygems.org.

``` ruby
gem install server.rb
```

## Sources

* [Github](https://github.com/0x1eef/server.rb#readme)
* [Gitlab](https://gitlab.com/0x1eef/server.rb#about)

## License

[BSD Zero Clause](https://choosealicense.com/licenses/0bsd/).
<br>
See [LICENSE](./LICENSE).
