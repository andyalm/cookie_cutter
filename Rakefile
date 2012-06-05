#!/usr/bin/env rake

#use bundler to resolve dependencies
require 'bundler'
Bundler.require(:default, :development, :test)

#import standard bundler gem tasks
require "bundler/gem_tasks"

#import/define rspec task
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

desc 'Runs all the tests'
task :tests => :spec
task :t => :tests

task :default => [:tests,:build]
