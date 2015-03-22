# -*- encoding: utf-8 -*-
require File.expand_path('../lib/fron/active_record/version', __FILE__)

Gem::Specification.new do |s|
  s.name         = 'fron-acr'
  s.version      = Fron::ActiveRecord::VERSION
  s.author       = 'Gusztav Szikszai'
  s.email        = 'gusztav.szikszai@digitalnatives.hu'
  s.homepage     = ''
  s.summary      = 'Active Record bridge for Fron'
  s.description  = 'Active Record bridge for Fron'

  s.files          = `git ls-files`.split("\n")
  s.executables    = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.test_files     = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths  = ['lib']

  s.add_runtime_dependency 'opal', ['~> 0.6.2']
  s.add_runtime_dependency 'sprockets', '~> 2.12.3'
  s.add_runtime_dependency 'activesupport'
  s.add_runtime_dependency 'cancancan', '~> 1.10'
  s.add_development_dependency 'opal-rspec', '~> 0.3.0.beta3'
end
