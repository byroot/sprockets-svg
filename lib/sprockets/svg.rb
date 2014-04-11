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
require_relative 'svg/railtie' if defined?(Rails)
