require 'sprockets/svg/version'

require 'nokogiri'
require 'RMagick'

module Sprockets
  module Svg
    extend self

    # TODO: integrate svgo instead: https://github.com/svg/svgo
    # See https://github.com/lautis/uglifier on how to integrate a npm package as a gem.
    def self.convert(svg_path, png_path)
      image = Magick::ImageList.new(svg_path)
      image.write(png_path)
    end

    def self.image?(path)
      return false unless path.ends_with?('.svg')

      document = Nokogiri::XML(File.read(path))
      svg = document.css('svg')
      svg.attribute('height') && svg.attribute('width')
    end

    def install(assets)
      assets.register_preprocessor 'image/svg+xml', :svg_min do |context, data|
        Sprockets::Svg::Cleaner.process(data)
      end
    end

  end
end

require_relative 'svg/cleaner'
require_relative 'svg/proxy_asset'
require_relative 'svg/server'

Sprockets::Environment.send(:include, Sprockets::Svg::Server)
Sprockets::Index.send(:include, Sprockets::Svg::Server)

require_relative 'svg/railtie' if defined?(Rails)
