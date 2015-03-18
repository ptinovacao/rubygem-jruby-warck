module JrubyWarck
  module VERSION
    MAJOR = 1 
    MINOR = 2
    PATCH = 0

    STRING = [MAJOR, MINOR, PATCH].compact.join('.')

    def self.version
      STRING
    end
  end
end
