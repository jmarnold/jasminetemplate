COMPILE_TARGET = ENV['config'].nil? ? "debug" : ENV['config']

include FileTest
require 'albacore'

PRODUCT = "FUBUPROJECTNAME"
COPYRIGHT = 'Copyright FUBUPROJECTNAME. All rights reserved.';
COMMON_ASSEMBLY_INFO = 'src/CommonAssemblyInfo.cs';
CLR_TOOLS_VERSION = "v4.0.30319"

buildsupportfiles = Dir["#{File.dirname(__FILE__)}/buildsupport/*.rb"]
raise "Run `git submodule update --init` to populate your buildsupport folder." unless buildsupportfiles.any?
buildsupportfiles.each { |ext| load ext }

props = { :stage => File.expand_path("build"), :artifacts => File.expand_path("artifacts") }

desc "**Default**"
task :default => [:restore_if_missing, :open_jasmine]

desc "Opens the Serenity Jasmine Runner in interactive mode"
task :open_jasmine do
	serenity "jasmine interactive src/serenity.txt"
end

desc "Runs the Jasmine tests"
task :run_jasmine do
	serenity "jasmine run src/serenity.txt"
end

def self.serenity(args)
  serenity = Platform.runtime(Nuget.tool("Serenity", "SerenityRunner.exe"))
  sh "#{serenity} #{args}"
end