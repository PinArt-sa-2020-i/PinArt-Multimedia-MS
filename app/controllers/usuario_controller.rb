class UsuarioController < ApplicationController

    before_action :authorize_request

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
        if Usuario.where(_id: params[:id]).count() == 0
            payload = {
                message: "El usuario no existe"
            }
            render :json => payload, :status => 400
            return
        else
            #Se trae el usuario
            usuario = Usuario.find_by(_id:params[:id])
        end


        #Eliminando la multimedia del  usuario
        Multimedia.where(usuario_creador_id: params[:id]).each do |multimedia|

            #Eliminado la multimedia
            begin
                DeleteMultimediaBucket.call(multimedia.id_bucket)
            rescue Exception => e
                payload = {
                    message: "Error al eliminar archivos multimedia del usuario",
                    error: e.to_s
                }
                render :json => payload, :status => 500
                return
            end
            

            #Quitando la asociacion de cada etiqueta
            begin
                multimedia.etiquetas_relacionadas.each do |etiqueta|
                    etiqueta.multimedia_relacionada.delete(multimedia)  
                    etiqueta.update_attributes()
                end
            rescue Exception => e
                payload = {
                    message: "Error al desasociar etiquetas de la multimedia del usuario",
                    error: e.to_s
                }
                render :json => payload, :status => 500
                return
            end

            #Quitando la asociacion de cada tablero
            begin
                multimedia.tableros_agregados.each do |tablero|
                    tablero.multimedia_agregada.delete(multimedia)
                    tablero.update_attributes()
                end
            rescue Exception => e
                payload = {
                    message: "Error al desasociar tableros de la multimedia del usuario",
                    error: e.to_s
                }
                render :json => payload, :status => 500
                return
            end

            #Eliminando la multimedia
            begin
                multimedia.delete()
            rescue Exception => e
                payload = {
                    message: "Error al eliminar multimedia del usuario",
                    error: e.to_s
                }
                render :json => payload, :status => 500
                return
            end
        end
        
        #Eliminando usuario
        begin
            usuario.delete()
            payload = {
                message: "Usuario Eliminado"
            }
            render :json => payload, :status => :ok
            return
        rescue Exception => e
            payload = {
                message: "Error al eliminar usuario",
                error: e.to_s
            }
            render :json => payload, :status => 500
            return
        end
    end

    
end