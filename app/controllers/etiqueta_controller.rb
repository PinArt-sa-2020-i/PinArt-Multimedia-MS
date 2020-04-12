class EtiquetaController < ApplicationController

    def delete
        etiqueta = Etiqueta.find_by(_id: params[:id])

        #Actualizando multimedia
        etiqueta.multimedia_relacionada.each do |multimedia|
            multimedia.etiquetas_relacionadas.delete(etiqueta)
            multimedia.update_attributes()
        end
        etiqueta.delete()


        payload = {
            message: "Etiqueta eliminada"
        }
        render :json => payload, :status => :ok

    end
end