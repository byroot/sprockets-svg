require 'sprockets/svg/version'

module Sprockets
  module Svg
    extend self

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

require_relative 'svg/railtie' if defined?(Rails)
