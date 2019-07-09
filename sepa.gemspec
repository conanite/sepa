# -*- coding: utf-8; mode: ruby  -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sepa/version'

Gem::Specification.new do |gem|
  gem.name          = "sepa"
  gem.version       = Sepa::VERSION
  gem.authors       = ["Conan Dalton"]
  gem.license       = 'MIT'
  gem.email         = ["conan@conandalton.net"]
  gem.description   = %q{ Generate ISO20022 XML messages. Implements a subset of pain.008.001.02 and pain.008.001.04 CustomerDirectDebitInitiation for now. WARNING: NO WARRANTY, USE AT YOUR OWN RISK AND PERIL. }
  gem.summary       = %q{ pain.008.001.04 and pain.008.001.02 CustomerDirectDebitInitiation ISO20022 XML. WARNING: NO WARRANTY, USE AT YOUR OWN RISK AND PERIL.  }
  gem.homepage      = "https://github.com/conanite/sepa"

  gem.add_dependency             'builder'
  gem.add_dependency             'aduki'
  gem.add_dependency             'countries', "~> 0.9.3"
  gem.add_development_dependency 'rspec'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
