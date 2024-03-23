## About

server.rb implements a static file web server. <br>
<<<<<<< HEAD
The implementation uses both [puma](https://github.com/puma/puma) and [rack](https://github.com/rack/rack).
=======
Built with [puma](https://github.com/puma/puma) and [rack](https://github.com/rack/rack).
>>>>>>> 4e0e5fa (Add API docs)

## Example

### Server.dir

`Server.dir` returns an instance of [Server]().

```ruby
require "server"
server = Server.dir File.join(Dir.getwd, "website")
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
