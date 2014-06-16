require 'sprockets/svg/version'

require 'nokogiri'

module Sprockets
  module Svg
    extend self

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
require_relative 'svg/png'
require_relative 'svg/server'

Sprockets::Asset.send(:include, Sprockets::Svg::Png)
Sprockets::StaticAsset.send(:include, Sprockets::Svg::Png)
Sprockets::Environment.send(:include, Sprockets::Svg::Server)
Sprockets::Index.send(:include, Sprockets::Svg::Server)

require_relative 'svg/railtie' if defined?(Rails)
