class ReviewTablero < ApplicationService
    def initialize(idTablero)
      @idTablero = idTablero
    end
  
    def execute
        #Revisando Tablero
        if Tablero.where(_id:@idTablero).count() == 0
            newTablero = Tablero.new(
                _id: @idTablero
            )
            newTablero.save!

            return newTablero
        else
            return Tablero.find_by(_id: @idTablero)
        end
    end
end