# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'invite_only/version'

Gem::Specification.new do |spec|
  spec.name          = "invite_only"
  spec.version       = InviteOnly::VERSION
  spec.authors       = ["Mez Gebre"]
  spec.email         = ["mez@jetcode.io"]
  spec.summary       = %q{Low level invite system.}
  spec.description   = %q{If you have a model (User, Account, etc..) and you only want invited people to be allowed creating those resource.
                          Good example is while in beta, invite only account creation.}
  spec.homepage      = "https://github.com/mez/invite_only"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_development_dependency "rake"
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec-rails')
  spec.add_development_dependency('database_cleaner')
  spec.add_development_dependency('sqlite3')
  spec.add_development_dependency('debugger')

  spec.add_dependency('rails','~> 3.2')
end
