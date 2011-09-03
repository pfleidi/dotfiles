require 'command-t/ext' # CommandT::Matcher
require 'command-t/scanner'

module CommandT
  # Encapsulates a Scanner instance (which builds up a list of available files
  # in a directory) and a Matcher instance (which selects from that list based
  # on a search string).
  class Finder
    def initialize path = Dir.pwd, options = {}
      @scanner = Scanner.new path, options
      @matcher = Matcher.new @scanner, options
    end

    # Options:
    #   :limit (integer): limit the number of returned matches
    def sorted_matches_for str, options = {}
      @matcher.sorted_matches_for str, options
    end

    def flush
      @scanner.flush
    end

    def path= path
      @scanner.path = path
    end
  end # class Finder
end # CommandT
