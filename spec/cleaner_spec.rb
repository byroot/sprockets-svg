require 'spec_helper'

describe Sprockets::Svg::Cleaner do

  let(:source_svg) { File.read(__dir__ + '/fixtures/source.svg') }

  let(:minified_svg) { described_class.process(source_svg) }

  it 'reduce the SVG size from 1064 to 493 bytes' do
    expect(source_svg.bytesize).to be == 1064
    expect(minified_svg.bytesize).to be == 493
  end

  it 'remove comments' do
    expect(minified_svg).to_not include('<!--')
  end

  it 'remove hidden elements' do
    expect(minified_svg).to_not include('display="none"')
  end

  it 'remove doctype' do
    expect(minified_svg).to_not include('DOCTYPE')
  end

  it 'remove the xml header' do
    expect(minified_svg).to_not include('<?xml')
  end

end
