require 'sprockets/svg/version'
require 'mini_magick'

module Sprockets
  module Svg
    extend self

    USELESS_PNG_METADATA = %w(svg:base-uri date:create date:modify).freeze

    # TODO: integrate svgo instead: https://github.com/svg/svgo
    # See https://github.com/lautis/uglifier on how to integrate a npm package as a gem.
    def self.convert(svg_blob)
      stream = StringIO.new(svg_blob)
      image = MiniMagick::Image.create('.svg', false) { |file| IO.copy_stream(stream, file) }
      image.format('png')
      image.to_blob
    end

    def install(assets)
      assets.register_preprocessor 'image/svg+xml', Sprockets::Svg::Cleaner
      assets.register_transformer 'image/svg+xml', 'image/png', -> (input) {
        Sprockets::Svg.convert(input[:data])
      }
    end
  end
end

require_relative 'svg/cleaner'

require_relative 'svg/railtie' if defined?(Rails)
