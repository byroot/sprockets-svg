module Sprockets
  module Svg
    class ProxyAsset

      def initialize(original_asset)
        @original_asset = original_asset
      end

      def digest_path
        ::Sprockets::Svg.png_path(@original_asset.digest_path)
      end

      def logical_path
        @original_asset.logical_path + '.png'
      end

      def length
        # If length isn't already set we default to original asset length.
        # It is most certainly wrong, but at least it will be bigger than the real size, so it is unlikely to create any issue.
        # And most importantly it prevent useless on the fly compilation
        @length || @original_asset.length
      end

      def content_type
        'image/png'
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

        @length = File.stat(filename).size

        nil
      ensure
        # Ensure tmp file gets cleaned up
        FileUtils.rm("#{filename}+") if File.exist?("#{filename}+")
      end

      def to_s
        @source ||= begin
          tmp_path = Tempfile.new(['png-cache', '.png']).path
          write_to(tmp_path)
          File.read(tmp_path)
        end
      end

      private

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
