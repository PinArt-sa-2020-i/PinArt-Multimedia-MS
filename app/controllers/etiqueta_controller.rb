class EtiquetaController < ApplicationController
    #before_action :authorize_request

    def delete
        #Verificando Parametros
        if  (params[:id] == nil)
            payload = {
                message: "Parametros Incompletos"
            }
            render :json => payload, :status => 400
            return
        end

        #verificar que el usuario exista
        if Etiqueta.where(_id: params[:id]).count() == 0
            payload = {
                message: "La etiqueta no existe"
            }
            render :json => payload, :status => 400
            return
        else
            #Se trae la etiqueta
            etiqueta = Etiqueta.find_by(_id: params[:id])
        end


        #Actualizando multimedia
        begin
            etiqueta.multimedia_relacionada.each do |multimedia|
                multimedia.etiquetas_relacionadas.delete(etiqueta)
                multimedia.update_attributes()
            end
        rescue Exception => e
            payload = {
                message: "Error al desasociar multimedia de la etiqueta",
                error: e.to_s
            }
            render :json => payload, :status => 500
            return
        end

        #Eliminado etiqueta
        begin
            etiqueta.delete()
            payload = {
                message: "Etiqueta eliminada"
            }
            render :json => payload, :status => :ok
            return
        rescue Exception => e
            payload = {
                message: "Error al eliminar etiqueta",
                error: e.to_s
            }
            render :json => payload, :status => 500
            return
        end

    end
end