require 'rake'
require 'jruby-warck/version'
require 'jruby-warck/constants'
require 'jruby-warck/manipulations'
require 'optparse'
require 'zip'
require 'erb'

class JrubyWarck::Application < Rake::Application
  include JrubyWarck::Constants
  include JrubyWarck::Manipulations
  include Rake::DSL

  def name
    'warck'
  end

  def initialize
    super 
  end 

  def load_rakefile
    Rake::TaskManager.record_task_metadata = true
    task :default do
      options.show_tasks        = :tasks
      options.show_task_pattern = //
      puts "#{name} #{JrubyWarck::VERSION.version} -- package your Rack application in a .war file that can be run from the command line or in a servlet container!"
      puts "Available commands:"
      display_tasks_and_comments
    end
    
    load 'jruby-warck/tasks/jruby.rake'
  end 

  def run
    Rake.application = self

    super
  end
end
