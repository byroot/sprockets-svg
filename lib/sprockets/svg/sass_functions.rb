module Sprockets
  module Svg
    module SassFunctions

      def svg2png_path(path)
        Sass::Script::String.new(sprockets_context.image_path(path.value) + '.png', :string)
      end
      
      def svg2png_url(path)
        Sass::Script::String.new("url(" + sprockets_context.image_path(path.value) + '.png' + ")")
      end

    end
  end
end
