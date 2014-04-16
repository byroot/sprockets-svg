require 'spec_helper'

require 'digest/md5'
require 'fileutils'

COMPILED_ASSETS_PATH = File.expand_path('app/public/assets/', File.dirname(__FILE__))
ASSETS = Pathname.new(COMPILED_ASSETS_PATH)

describe 'Rake task' do
  before :each do
    FileUtils.mkdir_p(COMPILED_ASSETS_PATH)
  end

  after :each do
    FileUtils.rm_rf(COMPILED_ASSETS_PATH)
  end

  let(:svg_path) { ASSETS.join('facebook-052e5d3070b50e0b3e60014378ece289.svg') }

  let(:png_path) { ASSETS.join('facebook-052e5d3070b50e0b3e60014378ece289.svg.png') }

  let(:font_path) { ASSETS.join('fontawesome-webfont-7534bcc67141208ea7a8c9be3a960f17.svg') }

  let(:svg_fingerprint) { Digest::MD5.hexdigest(svg_path.read) }

  let(:png_source) { png_path.read }

  it "generate a PNG from the SVG source" do
    `cd spec/app; bundle exec rake assets:precompile &2> /dev/null`
    $?.should be_success

    expect(svg_path).to be_exist
    expect(png_path).to be_exist

    expect(svg_fingerprint).to be == '85385a2b8357015a4ae6d8ab782d5389'
    # Metadata etc are kinda time dependant, so this assertion is the best I can do.
    expect(png_source).to be_starts_with("\x89PNG\r\n")

    expect(font_path).to be_exist
    expect(Dir[ASSETS.join('fontawesome-webfont-*.png')]).to be_empty
  end
end
