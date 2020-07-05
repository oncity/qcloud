#lib = File.expand_path("../lib", __FILE__)
#$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name        = 'qcloud_api'
  spec.version     = '0.0.1'
  spec.date        = '2020-07-06'
  spec.summary     = 'template!'
  spec.description = 'qcloud api ruby gem'
  spec.authors     = ['sysop']
  spec.email       = '138852298@qq.com'
  spec.homepage    = 'https://oncity.cc'
  spec.license     = 'MIT'

#  spec.files = `git ls-files -z`.split("\x0").reject do |f|
#    f.match(%r{^(test|spec|features)/})
 # end
  spec.files = Dir['lib/**/*.rb']

  spec.require_paths = ["lib"]
end
