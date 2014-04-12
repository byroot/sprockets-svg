# Sprockets::Svg

SVG toolchain for sprockets

## Installation


And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sprockets-svg

## Usage

### Ruby on Rails

Add this line to your application's Gemfile:

```ruby
gem 'sprockets-svg'
```

From now on, svg files will be automatically optimised.

To link the png version of `picture.svg` from scss:

```scss
#id {
  background-image: image-url(picture.svg.png)
}
```

or from a view:

```erb
<%= image_tag 'picture.svg.png' %>
```

### Standalone Sprockets

If you are using sprockets outside of Rails, to setup `sprockets-svg` you just need:

```ruby
assets = Sprockets::Environment.new do |env|
  # Your assets settings
end

require "sprockets-svg"
Sprockets::Svg.install(assets)
```

## Optimizations

For now the only optimization performed is to remove hidden elements.

In the future I'd like to rely on the [`svgo` toolchain](https://github.com/svg/svgo).

## Contributing

1. Fork it ( http://github.com/<my-github-username>/sprockets-svg/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
