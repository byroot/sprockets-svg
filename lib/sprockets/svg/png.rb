require 'RMagick'

module Sprockets
  module Svg
    module Png
      def self.included(base)
        base.send(:alias_method, :write_to_without_png_conversion, :write_to)
        base.send(:alias_method, :write_to, :write_to_with_png_conversion)
      end

      def write_to_with_png_conversion(path, options={})
        write_to_without_png_conversion(path, options)
        if Svg.image?(path)
          Png.convert(path, png_path(path))
        end
        nil
      end

      def png_path(svg_path)
        if svg_path =~ /^(.*)\-([0-9a-f]+)\.svg$/
          "#{$1}.svg-#{$2}.png"
        else
          "#{svg_path}.png"
        end
      end

      # TODO: integrate svgo instead: https://github.com/svg/svgo
      # See https://github.com/lautis/uglifier on how to integrate a npm package as a gem.
      def self.convert(svg_path, png_path)
        image = Magick::ImageList.new(svg_path)
        image.write(png_path)
      end
    end
  end
end