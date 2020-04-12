class ReviewUsuario < ApplicationService
    def initialize(idUsuario)
      @idUsuario = idUsuario
    end
  
    def execute
        #Revisando Usuario
        if Usuario.where(_id:@idUsuario).count() == 0
            newUsuario = Usuario.new(
                _id: @idUsuario
            )
            newUsuario.save!
            
            return newUsuario
        else
            return Usuario.find_by(_id: @idUsuario)
        end
    end
end
