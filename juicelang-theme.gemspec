# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "juicelang-theme"
  spec.version       = "0.5.4"
  spec.authors       = ["Josef Zoller"]
  spec.email         = ["josef@walterzollerpiano.com"]

  spec.summary       = "The theme of the website of the juice programming language"
  spec.homepage      = "https://github.com/juice-lang/juicelang-theme"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|lib|_layouts|_includes|_plugins|_sass|LICENSE|README|_config\.yml)!i) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency "jekyll", "~> 4.2"
  spec.add_runtime_dependency "kramdown", "~> 2.4"
  spec.add_runtime_dependency "liquid", "~> 4.0"
  spec.add_runtime_dependency "webrick", "~> 1.7"

  spec.add_development_dependency "bundler", "~> 2.0"
end
