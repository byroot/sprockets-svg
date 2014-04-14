require 'tempfile'
require 'pathname'

module Sprockets
  module Svg
    module Server

      def self.included(base)
        base.send(:alias_method, :find_asset_without_conversion, :find_asset)
        base.send(:alias_method, :find_asset, :find_asset_with_conversion)
      end

      def find_asset_with_conversion(path, options = {})
        convert = false
        if path.ends_with?('.svg.png')
          path = path.gsub(/\.png/, '')
          convert = true
        end
        asset = find_asset_without_conversion(path, options)

        if convert
          asset = svg_asset_to_static_png(asset)
        end

        asset
      end

      def svg2png_cache_path
        @cache_path ||= cache.instance_variable_get(:@root).join('svg2png')
      end

      def svg_asset_to_static_png(svg_asset)
        tmp_path = Tempfile.new(['svg2png', '.svg']).path
        svg_asset.write_to(tmp_path)
        ::Sprockets::StaticAsset.new(self, svg_asset.logical_path + '.png', Pathname.new(tmp_path + '.png'))
      end

    end
  end
end
