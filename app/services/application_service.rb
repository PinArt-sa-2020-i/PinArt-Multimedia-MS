class ApplicationService
    def self.call(*args, &block)
      new(*args, &block).execute
    end
end


# class name < ApplicationService
#   def initialize()
    
#   end

#   def execute
      
#   end
# end