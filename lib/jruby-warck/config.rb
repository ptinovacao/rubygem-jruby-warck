require 'optparse'
class << (Config = Class.new)
  def force!
    @force = true
  end

  def force?
    !!@force
  end
end

OptionParser.new do |opts|
  opts.on("-f", "--force", "Force overwrite of WAR file") { Config.force! }
end.parse(ARGV)
