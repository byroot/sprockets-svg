module Sprockets
  module Svg
    class ProxyAsset

      def initialize(original_asset)
        @original_asset = original_asset
      end

      def digest_path
        png_path(@original_asset.digest_path)
      end

      def logical_path
        @original_asset.logical_path + '.png'
      end

      def write_to(filename, options = {})
        # Gzip contents if filename has '.gz'
        options[:compress] ||= File.extname(filename) == '.gz'

        tmp_path = Tempfile.new(['svg2png', '.svg']).path
        png_path = tmp_path + '.png'

        @original_asset.write_to(tmp_path, options.merge(compress: false))
        Svg.convert(tmp_path, png_path)

        FileUtils.mkdir_p File.dirname(filename)

        if options[:compress]
          # Open file and run it through `Zlib`
          File.open(png_path, 'rb') do |rd|
            File.open("#{filename}+", 'wb') do |wr|
              gz = Zlib::GzipWriter.new(wr, Zlib::BEST_COMPRESSION)
              gz.mtime = mtime.to_i
              buf = ""
              while rd.read(16384, buf)
                gz.write(buf)
              end
              gz.close
            end
          end
        else
          # If no compression needs to be done, we can just copy it into place.
          FileUtils.cp(png_path, "#{filename}+")
        end

        # Atomic write
        FileUtils.mv("#{filename}+", filename)

        # Set mtime correctly
        File.utime(mtime, mtime, filename)

        nil
      ensure
        # Ensure tmp file gets cleaned up
        FileUtils.rm("#{filename}+") if File.exist?("#{filename}+")
      end

      def to_s
        tmp_path = Tempfile.new(['png-cache', '.png']).path
        write_to(tmp_path)
        File.read(tmp_path)
      end

      private

      def png_path(svg_path)
        if svg_path =~ /^(.*)\-([0-9a-f]{32})\.svg$/
          "#{$1}.svg-#{$2}.png"
        else
          "#{svg_path}.png"
        end
      end

      def method_missing(name, *args, &block)
        if @original_asset.respond_to?(name)
          @original_asset.public_send(name, *args, &block)
        else
          super
        end
      end

    end
  end
end
