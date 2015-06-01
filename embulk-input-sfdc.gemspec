
Gem::Specification.new do |spec|
  spec.name          = "embulk-input-sfdc"
  spec.version       = "0.1.0"
  spec.authors       = ["yoshihara", "uu59"]
  spec.summary       = "Sfdc input plugin for Embulk"
  spec.description   = "Loads records from Sfdc."
  spec.email         = ["h.yoshihara@everyleaf.com", "k@uu59.org"]

  spec.licenses      = ["Apache2"]
  # TODO set this: spec.homepage      = "https://github.com/h.yoshihara/embulk-input-sfdc"

  spec.files         = `git ls-files`.split("\n") + Dir["classpath/*.jar"]
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ["lib"]

  #spec.add_dependency 'YOUR_GEM_DEPENDENCY', ['~> YOUR_GEM_DEPENDENCY_VERSION']
  spec.add_development_dependency 'bundler', ['~> 1.0']
  spec.add_development_dependency 'rake', ['>= 10.0']
end
