begin
  require 'sprockets/railtie'

  module Sprockets::Svg
    class Railtie < ::Rails::Railtie
      initializer :setup_sprockets_svg do
        config.assets.configure do |env|
          Sprockets::Svg.install(env)
        end
      end
    end
  end
rescue LoadError
end
