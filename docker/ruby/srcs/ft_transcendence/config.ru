# This file is used by Rack-based servers to start the application.

require 'dotenv'
Dotenv.load

errors = []
errors << "Env value 42_OAUTH_CLIENT not set" if ENV["42_OAUTH_CLIENT"].nil?
errors << "Env value 42_OAUTH_SECRET not set" if ENV["42_OAUTH_SECRET"].nil?
if errors.count > 0
	puts "Cannot start:"
	errors.each do |msg|
		puts "| " + msg
	end
	exit
end

require_relative 'config/environment'

run Rails.application
