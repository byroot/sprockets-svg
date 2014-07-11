module Sprockets
  module Svg
    module SassFunctions

      def image_path(path)
        Sass::Script::String.new(svg2png_image_path(path.value), :string)
      end

      def image_url(path)
        Sass::Script::String.new("url(" + svg2png_image_path(path.value) + ")")
      end

      def svg2png_image_path(path)
        convert = false
        if path.ends_with?('.svg.png')
          path = path.gsub(/\.png$/, '')
          convert = true
        end

        url = sprockets_context.image_path(path)
        convert ? ::Sprockets::Svg.png_path(url) : url
      end

    end
  end
end

Sprockets::SassTemplate.class_eval do

  def initialize_engine_with_png_conversion
    initialize_engine_without_png_conversion
    ::Sass::Script::Functions.send :include, Sprockets::Svg::SassFunctions
  end

  alias_method :initialize_engine_without_png_conversion, :initialize_engine
  alias_method :initialize_engine, :initialize_engine_with_png_conversion

end
