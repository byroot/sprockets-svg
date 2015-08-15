require 'sprockets/svg/version'

require 'rmagick'

module Sprockets
  module Svg
    extend self

    # TODO: integrate svgo instead: https://github.com/svg/svgo
    # See https://github.com/lautis/uglifier on how to integrate a npm package as a gem.
    def self.convert(svg_blob)
      image_list = Magick::Image.from_blob(svg_blob) { self.format = 'SVG' }
      image = image_list.first
      image.format = 'PNG'
      image.to_blob
    end

    def install(assets)
      assets.register_preprocessor 'image/svg+xml', :svg_min do |context, data|
        Sprockets::Svg::Cleaner.process(data)
      end

      assets.register_transformer 'image/svg+xml', 'image/png', -> (input) {
        Sprockets::Svg.convert(input[:data])
      }
    end

  end
end

require_relative 'svg/cleaner'

require_relative 'svg/railtie' if defined?(Rails)
