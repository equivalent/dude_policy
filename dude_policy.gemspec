require_relative 'lib/dude_policy/version'

Gem::Specification.new do |spec|
  spec.name          = "dude_policy"
  spec.version       = DudePolicy::VERSION
  spec.authors       = ["Tomas Valent"]
  spec.email         = ["equivalent@eq8.eu"]

  spec.summary       = %q{Policy objects for Ruby on Rails from perspectvie of current account}
  spec.description   = %q{current user (current account) oriented Plain Ruby Object Policy for Ruby on Rails}
  spec.homepage      = "https://github.com/equivalent/dude_policy"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/equivalent/dude_policy/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", '> 4.2' # ensures compatibility for ruby 2.0.0+ to head
end
