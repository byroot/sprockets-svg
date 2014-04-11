begin
  require 'sprockets/railtie'

  module Sprockets::Svg
    class Railtie < ::Rails::Railtie
      initializer :setup_sprockets_svg, group: :all do |app|
        Sprockets::Svg.install(app.assets)
      end
    end
  end
rescue LoadError
end