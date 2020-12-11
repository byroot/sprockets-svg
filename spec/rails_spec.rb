require 'spec_helper'

require 'digest/md5'
require 'fileutils'
require 'json'

COMPILED_ASSETS_PATH = File.expand_path('app/public/assets/', File.dirname(__FILE__))
ASSETS = Pathname.new(COMPILED_ASSETS_PATH)

describe 'Sprockets::Svg' do

  let(:svg_name) { manifest['assets']['facebook.svg'] }

  let(:png_name) { manifest['assets']['facebook.png'] }

  let(:svg_path) { ASSETS.join(svg_name) }

  let(:png_path) { ASSETS.join(png_name) }

  let(:font_path) { ASSETS.join('fontawesome-webfont-62b810b30c0775c7680f56a9d411feb0b239a24aa33afcdda468c4686eeee9bb.svg') }

  let(:svg_fingerprint) { Digest::MD5.hexdigest(svg_path.read) }

  let(:manifest_path) { Dir[ASSETS.join('.sprockets-manifest-*.json')].first }

  let(:manifest) { JSON.parse(File.read(manifest_path)) }

  let(:png_fingerprint) { Digest::MD5.hexdigest(png_path.read) }

  describe 'Rake task' do
    before :each do
      FileUtils.mkdir_p(COMPILED_ASSETS_PATH)
    end

    after :each do
      FileUtils.rm_rf(COMPILED_ASSETS_PATH)
    end

    it "generate a PNG from the SVG source" do
      output = `cd spec/app; bundle exec rake assets:precompile 2>&1`
      puts output unless $?.success?
      expect($?).to be_success

      expect(svg_name).not_to be_nil
      expect(png_name).not_to be_nil

      expect(svg_path).to be_exist
      expect(png_path).to be_exist

      expect(svg_fingerprint).to be == '2d8738f246e37a7befd06db8dc2f7e11'

      # Metadata can contain some timestamps, so sleeping is the best way to make sure they are all stripped
      sleep 1
      expect(png_fingerprint).to be == Digest::MD5.hexdigest(Sprockets::Svg.convert(svg_path.read))

      expect(manifest['files'][svg_name]).to be_present
      expect(manifest['files'][png_name]).to be_present

      expect(manifest['assets']['facebook.png']).to be == png_name

      expect(font_path).to be_exist
      expect(Dir[ASSETS.join('fontawesome-webfont-*.png')]).to be_empty
    end
  end

  describe AssetsController, type: :controller do

    it 'rack' do
      get :test, params: { file: 'facebook.png' }
      expect(response).to be_successful
      expect(response.body.force_encoding('utf-8')).to be_starts_with("\x89PNG\r\n".force_encoding('utf-8'))
      expect(response.headers['Content-Type']).to match %r{image/png}
    end

    it 'compile scss' do
      get :test, params: { file: 'application.css' }
      expect(response).to be_successful
      expect(response.body).to match %r{url\(/assets/facebook-\w+\.svg\)}
      expect(response.body).to match %r{url\(/assets/facebook-\w+\.png\)}
    end

  end

end
