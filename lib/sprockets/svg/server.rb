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
        if path.to_s.ends_with?('.svg.png')
          path = path.gsub(/\.png/, '')
          convert = true
        end
        asset = find_asset_without_conversion(path, options)

        if asset && convert
          asset = ProxyAsset.new(asset)
        end

        asset
      end

      def each_file(*args)
        return to_enum(__method__) unless block_given?

        super do |path|
          yield path
          if Svg.image?(path.to_s)
            yield Pathname.new(path.to_s + '.png')
          end
        end
      end

    end
  end
end
