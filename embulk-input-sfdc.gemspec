Gem::Specification.new do |spec|
  spec.name          = "embulk-input-sfdc"
  spec.version       = "0.0.3"
  spec.authors       = ["yoshihara", "uu59"]
  spec.summary       = "Sfdc input plugin for Embulk"
  spec.description   = "Loads records from Sfdc."
  spec.email         = ["h.yoshihara@everyleaf.com", "k@uu59.org"]

  spec.licenses      = ["Apache2"]
  spec.homepage      = "https://github.com/treasure-data/embulk-input-sfdc"

  spec.files         = `git ls-files`.split("\n") + Dir["classpath/*.jar"]
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'httpclient', ['~> 2.6.0']
  spec.add_development_dependency 'bundler', ['~> 1.0']
  spec.add_development_dependency 'rake', ['>= 10.0']
  spec.add_development_dependency 'embulk', ['>= 0.6.12', '< 1.0']
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'test-unit'
  spec.add_development_dependency 'test-unit-rr'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'everyleaf-embulk_helper'

end
