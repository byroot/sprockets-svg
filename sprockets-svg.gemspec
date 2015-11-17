# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sprockets/svg/version'

Gem::Specification.new do |spec|
  spec.name          = 'sprockets-svg'
  spec.version       = Sprockets::Svg::VERSION
  spec.authors       = ['Jean Boussier']
  spec.email         = ['jean.boussier@gmail.com']
  spec.summary       = %q{SVG toolchain for sprockets}
  spec.description   = %q{Minify SVG assets, and optionally convert them to PNG for browser compatibility.}
  spec.homepage      = 'https://github.com/byroot/sprockets-svg'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_dependency 'sprockets', '>= 3'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'rmagick'
  spec.add_dependency 'chunky_png'
end
