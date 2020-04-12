class MultimediaController < ApplicationController

    def add
        #Revisando el usuario
        usuario = ReviewUsuario.call(params[:idUsuario])

        #Revisando las etiquetas
        etiquetas = []
        params[:idEtiquetas].each do |idEtiqueta|
            etiquetas.push(ReviewEtiqueta.call(idEtiqueta))
        end

        #Se guarda el archivo multimedia en el bucket
        data_bucket = UploadMultimedia.call(params[:file].tempfile);


        newMultimedia = Multimedia.new(
            descripcion: params[:descripcion],
            formato: params[:file].content_type,
            tamano: params[:file].size,
            url: data_bucket[:url_imagen],
            id_bucket: data_bucket[:id_bucket],
            usuario_creador: usuario,
            etiquetas_relacionadas: etiquetas
        )

        newMultimedia.save!
        usuario.update_attributes()
        etiquetas.each do |etiqueta|
            etiqueta.update_attributes()
        end



        # message: JSON.parse(params[:file])["content_type"]
        payload = {
            message: newMultimedia
        }
        render :json => payload, :status => :ok
    end





    def delete 
        #Rescatando datos de la multimedia
        multimedia = Multimedia.find_by(_id: params[:id])
        
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

        
        payload = {
            message: "OK"
        }
        render :json => payload, :status => :ok
    end


    def update
        #Rescatando datos de la multimedia
        multimedia = Multimedia.find_by(_id: params[:id])

        #Revisando nuevas etiquetas
        etiquetas = []
        params[:idEtiquetas].each do |idEtiqueta|
            etiquetas.push(ReviewEtiqueta.call(idEtiqueta))
        end
        
        #Desasociando viejas etiquetas
        multimedia.etiquetas_relacionadas.each do |etiqueta|
            if etiquetas.include?(etiqueta)
            else
                etiqueta.multimedia_relacionada.delete(multimedia)
                etiqueta.update_attributes()
            end    
            
        end

        
        #actualizando multimedia
        multimedia.update_attributes(
            descripcion: params[:descripcion],
            etiquetas_relacionadas: etiquetas
        )
        
        #actualizando nuevas etiquetas
        etiquetas.each do |etiqueta|
            etiqueta.update_attributes()
        end

        payload = {
            message: "OK"
        }
        render :json => payload, :status => :ok
    end



    def addEtiqueta
        #Rescatando datos de la multimedia
        multimedia = Multimedia.find_by(_id: params[:id])

        #Verificando etiqueta
        etiqueta = ReviewEtiqueta.call(params[:idEtiqueta])

        if multimedia.etiquetas_relacionadas.include?(etiqueta)
            payload = {
                message: "Ya esta"
            }
            render :json => payload, :status => :ok
        else
            multimedia.etiquetas_relacionadas.push(etiqueta)
            multimedia.update_attributes()
            etiqueta.update_attributes()
            payload = {
                message: "OK"
            }
            render :json => payload, :status => :ok
        end

    end


    def deleteEtiqueta
        #Rescatando datos de la multimedia
        multimedia = Multimedia.find_by(_id: params[:id])

        #Verificando etiqueta
        etiqueta = ReviewEtiqueta.call(params[:idEtiqueta])

        if multimedia.etiquetas_relacionadas.include?(etiqueta)
            multimedia.etiquetas_relacionadas.delete(etiqueta)
            multimedia.update_attributes()
            etiqueta.update_attributes()
            
            payload = {
                message: "Etiqueta Eliminada"
            }

            render :json => payload, :status => :ok
        else
            payload = {
                message: "Etiqueta no asociada"
            }
            render :json => payload, :status => :ok
        end

    end

end
