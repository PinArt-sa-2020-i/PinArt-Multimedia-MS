class MultimediaController < ApplicationController
    before_action :authorize_request

    def add
        #Verificando Parametros
        if  (params[:descripcion] == nil) ||
            (params[:idUsuario] == nil) ||
            (params[:idEtiquetas] == nil) ||
            (params[:file] == nil)
            payload = {
                message: "Parametros Incompletos"
            }
            render :json => payload, :status => 400
            return
        end

        #Revisando el usuario y las etiquetas
        begin  
            usuario = ReviewUsuario.call(params[:idUsuario])

            etiquetas = []
            params[:idEtiquetas].each do |idEtiqueta|
                etiquetas.push(ReviewEtiqueta.call(idEtiqueta))
            end

        rescue  Exception => e
            payload = {
                message: "Ha ocurrido un error al verificar las referencias",
                error: e.to_s
            }
            render :json => payload, :status => 500
            return
        end  
          
    

        #Se guarda el archivo multimedia en el bucket
        begin
            data_bucket = UploadMultimedia.call(params[:file].tempfile);
        rescue Exception => e
            payload = {
                message: "Ha ocurrido un error cargar el archivo multimedia",
                error: e.to_s
            }
            render :json => payload, :status => 500
            return
        end


        #Creando la multimedia
        newMultimedia = Multimedia.new(
            descripcion: params[:descripcion],
            formato: params[:file].content_type,
            tamano: params[:file].size,
            url: data_bucket[:url_imagen],
            id_bucket: data_bucket[:id_bucket],
            usuario_creador: usuario,
            etiquetas_relacionadas: etiquetas
        )

        #Guardando Multimedia
        begin
            newMultimedia.save!
        rescue Exception => e
            payload = {
                message: "Ha ocurrido un guardar multimedia",
                error: e.to_s
            }
            render :json => payload, :status => 500
            return
        end


        #Actualizando Usuario
        usuario.update_attributes()


        #Actualizando Etiquetas
        etiquetas.each do |etiqueta|
            etiqueta.update_attributes()
        end


        #Solicitud procesada de manera correcta
        payload = {
            message: "Multimedia Creada de Manera Correcta",
            multimedia: newMultimedia
        }
        render :json => payload, :status => :ok
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
        
        #Rescatando datos de la multimedia
        if Multimedia.where(_id: params[:id]).count() == 0
            payload = {
                message: "Esta Multimedia no existe"
            }
            render :json => payload, :status => 400
            return
        else
            multimedia = Multimedia.find_by(_id: params[:id])
        end



        #Eliminado la multimedia del bucket
        begin
            # DeleteMultimediaBucket.call(multimedia.id_bucket)
        rescue  Exception => e
            payload = {
                message: "Ha ocurrido un error al eliminar el archivo del bucket",
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
        rescue  Exception => e
            payload = {
                message: "Ha ocurrido un error al eliminar las referencias de las etiquetas",
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
        rescue  Exception => e
            payload = {
                message: "Ha ocurrido un error al eliminar las referencias de los tableros",
                error: e.to_s
            }
            render :json => payload, :status => 500
            return
        end 



        #Eliminando la multimedia
        begin
            multimedia.delete()
        rescue  Exception => e
            payload = {
                message: "Ha ocurrido un error al eliminar la multimedia",
                error: e.to_s
            }
            render :json => payload, :status => 500
            return
        end 
        
        #Solicitud procesada de manera correcta
        payload = {
            message: "Multimedia eliminada de manera correcta"
        }
        render :json => payload, :status => :ok
    end

















    def update
        #Verificando Parametros
        if  (params[:id] == nil)
            payload = {
                message: "Parametros Incompletos"
            }
            render :json => payload, :status => 400
            return
        end

        #Rescatando datos de la multimedia
        if Multimedia.where(_id: params[:id]).count() == 0
            payload = {
                message: "Esta Multimedia no existe"
            }
            render :json => payload, :status => 400
            return
        else
            multimedia = Multimedia.find_by(_id: params[:id])
        end



        #Verificando Descripcion
        if params[:descripcion] == nil
            params[:descripcion] = multimedia.descripcion
        end


        #Verificanfo etiquetas
        if params[:idEtiquetas] == nil
            #actualizando multimedia (Sin Etiquetas)
            begin
                multimedia.update_attributes(
                    descripcion: params[:descripcion]
                )  
            rescue  Exception => e
                payload = {
                    message: "Ha ocurrido un error guardar la actualizacion de la multimedia",
                    error: e.to_s
                }
                render :json => payload, :status => 500
                return
            end 
        else
            #Seleccionando etiquetas a actualizar
            begin
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
            rescue  Exception => e
                payload = {
                    message: "Ha ocurrido un error al desasociar las viejas etiquetas",
                    error: e.to_s
                }
                render :json => payload, :status => 500
                return
            end   
            
            #actualizando multimedia (Con etiquetas)
            begin
                multimedia.update_attributes(
                    descripcion: params[:descripcion],
                    etiquetas_relacionadas: etiquetas
                )
                
            rescue  Exception => e
                payload = {
                    message: "Ha ocurrido un error guardar la actualizacion de la multimedia",
                    error: e.to_s
                }
                render :json => payload, :status => 500
                return
            end 

            #actualizando nuevas etiquetas
            begin
                etiquetas.each do |etiqueta|
                    etiqueta.update_attributes()
                end
            rescue  Exception => e
                payload = {
                    message: "Ha ocurrido un error al asociar las nuevas etiquetas",
                    error: e.to_s
                }
                render :json => payload, :status => 500
                return
            end
        end
    
         

        #Solicitud procesada de manera correcta
        payload = {
            message: "Multimedia actualizada de manera correcta"
        }
        render :json => payload, :status => :ok


    end













    





    def addEtiqueta
        #Verificando Parametros
        if  (params[:idMultimedia] == nil) ||
            (params[:idEtiqueta] == nil) 
            payload = {
                message: "Parametros Incompletos"
            }
            render :json => payload, :status => 400
            return
        end


        #Rescatando datos de la multimedia
        if Multimedia.where(_id: params[:idMultimedia]).count() == 0
            payload = {
                message: "Esta Multimedia no existe"
            }
            render :json => payload, :status => 400
            return
        else
            multimedia = Multimedia.find_by(_id: params[:idMultimedia])
        end


        #Verificando etiqueta
        begin
            etiqueta = ReviewEtiqueta.call(params[:idEtiqueta])
        rescue  Exception => e
            payload = {
                message: "Ha ocurrido un error obtener la etiqueta",
                error: e.to_s
            }
            render :json => payload, :status => 500
            return
        end
        


        #Revisando si la etiqeuta esta agregada
        if multimedia.etiquetas_relacionadas.include?(etiqueta)
            payload = {
                message: "Esta etiqueta ya esta agregada a la multimedia"
            }
            render :json => payload, :status => 400
        else
            #se agrega la etiqueta
            begin
                multimedia.etiquetas_relacionadas.push(etiqueta)
                multimedia.update_attributes()
                etiqueta.update_attributes()
                payload = {
                    message: "Etiqueta Agregada"
                }
                render :json => payload, :status => :ok
            rescue  Exception => e
                payload = {
                    message: "Ha ocurrido un error al agregar la etiqueta",
                    error: e.to_s
                }
                render :json => payload, :status => 500
                return
            end
        end

    end



    


    







    def deleteEtiqueta
        #Verificando Parametros
        if  (params[:idMultimedia] == nil) ||
            (params[:idEtiqueta] == nil) 
            payload = {
                message: "Parametros Incompletos"
            }
            render :json => payload, :status => 400
            return
        end


        #Rescatando datos de la multimedia
        if Multimedia.where(_id: params[:idMultimedia]).count() == 0
            payload = {
                message: "Esta Multimedia no existe"
            }
            render :json => payload, :status => 400
            return
        else
            multimedia = Multimedia.find_by(_id: params[:idMultimedia])
        end

        #Verificando etiqueta
        begin
            etiqueta = ReviewEtiqueta.call(params[:idEtiqueta])
        rescue  Exception => e
            payload = {
                message: "Ha ocurrido un error obtener la etiqueta",
                error: e.to_s
            }
            render :json => payload, :status => 500
            return
        end
        

        #Verificando la existencia de la etiqueta
        begin
            if multimedia.etiquetas_relacionadas.include?(etiqueta)
                multimedia.etiquetas_relacionadas.delete(etiqueta)
                multimedia.update_attributes()
                etiqueta.update_attributes()
                
                payload = {
                    message: "Etiqueta desasociada a la multimedia"
                }

                render :json => payload, :status => :ok
            else
                payload = {
                    message: "Etiqueta no asociada a la multimedia"
                }
                render :json => payload, :status => 400
            end
        rescue  Exception => e
            payload = {
                message: "Ha ocurrido un error desasociar la etiqueta a la multimedia",
                error: e.to_s
            }
            render :json => payload, :status => 500
            return
        end
    end




end
