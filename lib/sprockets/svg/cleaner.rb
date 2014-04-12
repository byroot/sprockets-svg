require 'nokogiri'

module Sprockets
  module Svg
    class Cleaner
      # TODO: integrate svgo instead: https://github.com/svg/svgo
      # See https://github.com/lautis/uglifier on how to integrate a npm package as a gem.
      def self.process(svg)
        p :preprocess_svg
        document = Nokogiri::XML(svg)
        document.css('[display=none]').remove()
        document.to_s
      end
    end
  end
end