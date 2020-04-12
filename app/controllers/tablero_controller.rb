class TableroController < ApplicationController


    

    def addMultimedia
        #verificar que multimedia exista
        if Multimedia.where(_id: params[:idMultimedia]).count() == 0
            payload = {
                message: "La multimedia no existe"
            }
            render :json => payload, :status => :ok
        else
            #Se trae la multimedia
            multimedia = Multimedia.find_by(_id: params[:idMultimedia])

            #verifica la existencia del tablero
            tablero = ReviewTablero.call(params[:idTablero])

            if tablero.multimedia_agregada.include?(multimedia)
                payload = {
                    message: "La multimedia ya esta agregada"
                }
                render :json => payload, :status => :ok
            else
                tablero.multimedia_agregada.push(multimedia)
                tablero.update_attributes()
                multimedia.update_attributes()
                payload = {
                    message: "La multimedia agregada al tablero"
                }
                render :json => payload, :status => :ok
            end
        end
    end




    def deleteMultimedia
        multimedia = Multimedia.find_by(_id: params[:idMultimedia])
        tablero = Tablero.find_by(_id: params[:idTablero])

        if tablero.multimedia_agregada.include?(multimedia)
            tablero.multimedia_agregada.delete(multimedia)
            tablero.update_attributes()
            multimedia.update_attributes()
            payload = {
                message: "Multimedia eliminada del tablero"
            }
            render :json => payload, :status => :ok
        else
            payload = {
                message: "La multimedia no esta agregada al tablero"
            }
            render :json => payload, :status => :ok
        end

    end


    def delete
        tablero = Tablero.find_by(_id: params[:id])

        tablero.multimedia_agregada.each do |multimedia|
            multimedia.tableros_agregados.delete(tablero)
            multimedia.update_attributes()
        end

        tablero.delete()
        payload = {
            message: "Tablero eliminado"
        }
        render :json => payload, :status => :ok
    end
end