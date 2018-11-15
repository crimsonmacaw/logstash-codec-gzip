Gem::Specification.new do |s|
  s.name          = 'logstash-codec-gzip'
  s.version       = '0.3.0'
  s.licenses      = ['Apache-2.0']
  s.summary       = 'Logstash code for reading data in gzip format'
  s.description   = 'Logstash code for reading data in gzip format'
  s.authors       = ['robert.bruce@crimsonmacaw.com']
  s.email         = 'robert.bruce@crimsonmacaw.com'
  s.require_paths = ['lib']

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "codec" }

  # Gem dependencies
  s.add_runtime_dependency 'logstash-core-plugin-api', "~> 2.0"
  s.add_runtime_dependency 'logstash-codec-line'
  s.add_development_dependency 'logstash-devutils'
end
