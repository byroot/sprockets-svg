require 'sprockets/svg/version'
require 'chunky_png'
require 'rmagick'

module Sprockets
  module Svg
    extend self

    USELESS_PNG_METADATA = %w(svg:base-uri date:create date:modify).freeze

    # TODO: integrate svgo instead: https://github.com/svg/svgo
    # See https://github.com/lautis/uglifier on how to integrate a npm package as a gem.
    def self.convert(svg_blob)
      image_list = Magick::Image.from_blob(svg_blob) { self.format = 'SVG' }
      image = image_list.first
      image.format = 'PNG'
      strip_png_metadata(image.to_blob)
    end

    def strip_png_metadata(png_blob)
      image = ChunkyPNG::Image.from_blob(png_blob)
      USELESS_PNG_METADATA.each(&image.metadata.method(:delete))
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
