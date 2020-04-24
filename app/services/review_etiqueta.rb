class ReviewEtiqueta < ApplicationService
    def initialize(idEtiqueta)
      @idEtiqueta = idEtiqueta
    end
  
    def execute
        if @idEtiqueta == nil
            raise "Etiqueta invalida"
        else
            if Etiqueta.where(_id:@idEtiqueta).count() == 0
                newEtiqueta = Etiqueta.new(
                    _id:@idEtiqueta
                )
                newEtiqueta.save!
                return newEtiqueta
            else
                return Etiqueta.find_by(_id:@idEtiqueta)
            end
        end
    end
end
