module JrubyWarck
  module VERSION
    MAJOR = 1 
    MINOR = 0
    PATCH = 1

    STRING = [MAJOR, MINOR, PATCH].compact.join('.')

    def self.version
      STRING
    end
  end
end
