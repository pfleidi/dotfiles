module CommandT
  module VIM
    module Screen
      def self.lines
        ::VIM::evaluate('&lines').to_i
      end
    end # module Screen
  end # module VIM
end # module CommandT
