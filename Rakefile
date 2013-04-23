#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Replay::Application.load_tasks


task :system do
	p 'system test'
	system('ruby --version')
	system('ruby -e "p 1111"')
end
