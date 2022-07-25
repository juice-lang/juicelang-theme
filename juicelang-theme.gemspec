# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "juicelang-theme"
  spec.version       = "0.2.1"
  spec.authors       = ["Josef Zoller"]
  spec.email         = ["josef@walterzollerpiano.com"]

  spec.summary       = "The theme of thewebsite of the juice programming language"
  spec.homepage      = "https://gthub.com/juice-lang/juicelang-theme"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_sass|LICENSE|README|_config\.yml)!i) }

  spec.add_runtime_dependency "jekyll", "~> 4.2"
  spec.add_runtime_dependency "webrick", "~> 1.7"
end
