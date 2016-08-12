require 'nokogiri'

module Sprockets
  module Svg
    class Cleaner
      # TODO: integrate svgo instead: https://github.com/svg/svgo
      # See https://github.com/lautis/uglifier on how to integrate a npm package as a gem.
      def self.process(svg)
        document = Nokogiri::XML(svg).css('svg')
        document.css('[display=none]').remove
        document.xpath('//comment()').remove
        document.to_s.gsub("\n", '').gsub(/>\s+</, '><').strip
      end

      def self.call(input)
        process(input[:data])
      end
    end
  end
end
