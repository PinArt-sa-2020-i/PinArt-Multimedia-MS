class TableroController < ApplicationController
    #before_action :authorize_request

    

    def addMultimedia
        #Verificando Parametros
        if  (params[:idMultimedia] == nil) ||
            (params[:idTablero] == nil) 
            payload = {
                message: "Parametros Incompletos"
            }
            render :json => payload, :status => 400
            return
        end

        
        #verificar que multimedia exista
        if Multimedia.where(_id: params[:idMultimedia]).count() == 0
            payload = {
                message: "La multimedia no existe"
            }
            render :json => payload, :status => 400
            return
        else
            #Se trae la multimedia
            multimedia = Multimedia.find_by(_id: params[:idMultimedia])
        end

        #verifica la existencia del tablero
        begin
            tablero = ReviewTablero.call(params[:idTablero])
        rescue Exception => e
            payload = {
                message: "Error al verificar el tablero",
                error: e.to_s
            }
            render :json => payload, :status => 500
            return
        end


        #Verifica que el tablero incluya la multimedia
        if tablero.multimedia_agregada.include?(multimedia)
            payload = {
                message: "La multimedia ya esta agregada a este tablero"
            }
            render :json => payload, :status => 400
            return
        else
            begin
                tablero.multimedia_agregada.push(multimedia)
                tablero.update_attributes()
                multimedia.update_attributes()

                multimedia_agregada_ids = []
                tablero.multimedia_agregada_ids.each do |idEtiqueta|
                    multimedia_agregada_ids.push(idEtiqueta.to_s)
                end

                payload = {
                    message: "La multimedia agregada al tablero",
                    tablero: {
                            id: tablero._id,
                            multimedia_agregada_ids: multimedia_agregada_ids
                    }    
                }
                render :json => payload, :status => :ok
                return
            rescue Exception => e
                payload = {
                    message: "Error al agregar multimedia al tablero",
                    error: e.to_s
                }
                render :json => payload, :status => 500
                return
            end
        end
    end












    def deleteMultimedia
        #Verificando Parametros
        if  (params[:idMultimedia] == nil) ||
            (params[:idTablero] == nil) 
            payload = {
                message: "Parametros Incompletos"
            }
            render :json => payload, :status => 400
            return
        end

        #verificar que multimedia exista
        if Multimedia.where(_id: params[:idMultimedia]).count() == 0
            payload = {
                message: "La multimedia no existe"
            }
            render :json => payload, :status => 400
            return
        else
            #Se trae la multimedia
            multimedia = Multimedia.find_by(_id: params[:idMultimedia])
        end

        #Verificar que el tablero existe
        if Tablero.where(_id: params[:idTablero]).count() == 0
            payload = {
                message: "El tablero no existe"
            }
            render :json => payload, :status => 400
            return
        else
            tablero = Tablero.find_by(_id: params[:idTablero])
        end


        #Verifica que la multimedia esta agregada al tablero
        if tablero.multimedia_agregada.include?(multimedia)
            begin
                tablero.multimedia_agregada.delete(multimedia)
                tablero.update_attributes()
                multimedia.update_attributes()

                multimedia_agregada_ids = []
                tablero.multimedia_agregada_ids.each do |idEtiqueta|
                    multimedia_agregada_ids.push(idEtiqueta.to_s)
                end

                payload = {
                    message: "Multimedia eliminada del tablero",
                    tablero: {
                        id: tablero._id,
                        multimedia_agregada_ids: multimedia_agregada_ids
                    } 
                }
                render :json => payload, :status => :ok
                return
            rescue Exception => e
                payload = {
                    message: "Error al eliminar multimedia de tablero",
                    error: e.to_s
                }
                render :json => payload, :status => 500
                return
            end
        else
            payload = {
                message: "La multimedia no esta agregada al tablero"
            }
            render :json => payload, :status => 400
            return
        end

    end










    def delete
        #Verificando Parametros
        if  (params[:id] == nil)
            payload = {
                message: "Parametros Incompletos"
            }
            render :json => payload, :status => 400
            return
        end


        #Verificar que el tablero existe
        if Tablero.where(_id: params[:id]).count() == 0
            payload = {
                message: "El tablero no existe"
            }
            render :json => payload, :status => 400
            return
        else
            tablero = Tablero.find_by(_id: params[:id])
        end

        #Desasociando multimedia del tablero
        begin
            tablero.multimedia_agregada.each do |multimedia|
                multimedia.tableros_agregados.delete(tablero)
                multimedia.update_attributes()
            end
        rescue Exception => e
            payload = {
                message: "Error al desasociar multimedia de tablero",
                error: e.to_s
            }
            render :json => payload, :status => 500
            return
        end

        #Eliminando Tablero
        begin
            tablero.delete()
            payload = {
                message: "Tablero eliminado"
            }
            render :json => payload, :status => :ok
            return
        rescue Exception => e
            payload = {
                message: "Error al eliminar el tablero",
                error: e.to_s
            }
            render :json => payload, :status => 500
            return
        end
    end
end