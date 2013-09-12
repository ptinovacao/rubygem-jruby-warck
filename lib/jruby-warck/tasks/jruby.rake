require 'jruby-warck/manipulations'
require 'jruby-warck/constants'

include JrubyWarck::Manipulations
include JrubyWarck::Constants

desc "Create a .war package out of this application"
task :package, [:archive_name, :framework] do |t, args|
  args.with_defaults(:archive_name => File.basename(RUNNING_FROM), :framework => :rack)

  create_archive_dirs
  add_manifest_file
  add_deployment_descriptor(args[:framework])
  add_rackup_file if File.exists?(RACKUP_FILE)
  add_ruby_files
  add_public_files
  add_additional_files
  add_bootstrap_script(args[:archive_name])
  archive_war(args[:archive_name])
end

desc "Create a .war package out of this application, compiling Ruby sources to .class files"
task :package_compiled, [:archive_name, :framework] do |t, args|
  args.with_defaults(:archive_name => File.basename(RUNNING_FROM), :framework => :rack)

  create_archive_dirs
  add_manifest_file
  add_deployment_descriptor(args[:framework])
  add_rackup_file if File.exists?(RACKUP_FILE)
  compile_ruby_scripts
  add_class_files
  add_public_files
  add_additional_files
  add_bootstrap_script(args[:archive_name])
  archive_war(args[:archive_name])
end

desc "Generate a deployment descriptor (web.xml) to be customized for this application"
task :webxml, :framework do |t, args|
  args.with_defaults(:framework => :rack)

  generate_deployment_descriptor("web.xml", args[:framework]) 
end
