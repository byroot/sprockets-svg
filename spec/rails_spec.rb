require 'spec_helper'

require 'digest/md5'
require 'fileutils'
require 'json'

COMPILED_ASSETS_PATH = File.expand_path('app/public/assets/', File.dirname(__FILE__))
ASSETS = Pathname.new(COMPILED_ASSETS_PATH)

describe 'Rake task' do
  before :each do
    FileUtils.mkdir_p(COMPILED_ASSETS_PATH)
  end

  after :each do
    FileUtils.rm_rf(COMPILED_ASSETS_PATH)
  end

  let(:svg_name) { 'facebook-213385e4d9304ef93b23578fc4c93440.svg' }

  let(:png_name) { 'facebook.svg-213385e4d9304ef93b23578fc4c93440.png' }

  let(:svg_path) { ASSETS.join(svg_name) }

  let(:png_path) { ASSETS.join(png_name) }

  let(:font_path) { ASSETS.join('fontawesome-webfont-040e9dcf8f420c96cbb5f0985fe09185.svg') }

  let(:svg_fingerprint) { Digest::MD5.hexdigest(svg_path.read) }

  let(:manifest_path) { Dir[ASSETS.join('manifest-*.json')].first }

  let(:manifest) { JSON.parse(File.read(manifest_path)) }

  let(:png_source) { png_path.read }

  it "generate a PNG from the SVG source" do
    output = `cd spec/app; bundle exec rake assets:precompile 2>&1`
    puts output unless $?.success?
    expect($?).to be_success

    expect(svg_path).to be_exist
    expect(png_path).to be_exist

    expect(svg_fingerprint).to be == '85385a2b8357015a4ae6d8ab782d5389'
    # Metadata etc are kinda time dependant, so this assertion is the best I can do.
    expect(png_source).to be_starts_with("\x89PNG\r\n")

    expect(manifest['files'][svg_name]).to be_present
    expect(manifest['files'][png_name]).to be_present

    expect(manifest['assets']['facebook.svg.png']).to be == png_name

    expect(font_path).to be_exist
    expect(Dir[ASSETS.join('fontawesome-webfont-*.png')]).to be_empty
  end
end

describe AssetsController, type: :controller do

  it 'rack' do
    get :test, file: 'facebook.svg.png'
    expect(response).to be_success
    expect(response.body.force_encoding('utf-8')).to be_starts_with("\x89PNG\r\n")
    expect(response.headers['Content-Type']).to be == 'image/png'
  end

end
