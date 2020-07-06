require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test' << 'lib'
  t.pattern = "test/test_*.rb"
  t.ruby_opts << "-r test_helper"
end

task :default => :test

#rake test TEST=test/test_qcloud_cos.rb
