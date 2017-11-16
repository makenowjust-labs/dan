MRuby::Gem::Specification.new('dan') do |spec|
  spec.license = 'MIT'
  spec.author  = 'TSUYUSATO Kitsune'
  spec.summary = 'dan'
  spec.bins    = ['dan']

  spec.add_dependency 'mruby-print', :core => 'mruby-print'
  spec.add_dependency 'mruby-time', :core => 'mruby-time'
  spec.add_dependency 'mruby-sprintf', :core => 'mruby-sprintf'

  spec.add_dependency 'mruby-io', :mgem => 'mruby-io'
  spec.add_dependency 'mruby-mtest', :mgem => 'mruby-mtest'
  spec.add_dependency 'mruby-optparse', :mgem => 'mruby-optparse'
  spec.add_dependency 'mruby-process', :mgem => 'mruby-process'
  spec.add_dependency 'mruby-shellwords', :mgem => 'mruby-shellwords'
  spec.add_dependency 'mruby-sqlite', :mgem => 'mruby-sqlite'
  spec.add_dependency 'mruby-tempfile', :mgem => 'mruby-tempfile'
end
