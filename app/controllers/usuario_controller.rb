class UsuarioController < ApplicationController

    def delete
        usuario = Usuario.find_by(_id:params[:id])

        #Eliminando la multimedia del  usuario
        Multimedia.where(usuario_creador_id: params[:id]).each do |multimedia|
            #Eliminado la multimedia
            # DeleteMultimediaBucket.call(multimedia.id_bucket)
            
            #Quitando la asociacion de cada etiqueta
            multimedia.etiquetas_relacionadas.each do |etiqueta|
                etiqueta.multimedia_relacionada.delete(multimedia)  
                etiqueta.update_attributes()
            end

            #Quitando la asociacion de cada tablero
            multimedia.tableros_agregados.each do |tablero|
                tablero.multimedia_agregada.delete(multimedia)
                tablero.update_attributes()
            end
            
            #Eliminando la multimedia
            multimedia.delete()
        end
        
        usuario.delete()

        payload = {
            message: "Usuario Eliminado"
        }
        render :json => payload, :status => :ok
    
    end

    
end