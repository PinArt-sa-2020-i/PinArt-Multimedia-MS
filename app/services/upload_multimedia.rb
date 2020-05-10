class UploadMultimedia < ApplicationService
    def initialize(image)
      @image = image
    end
  
    def execute
        data_imagen = Hash.new
        #Cargar la imagen
        data_imagen[:id_bucket] = upload

        #Recupera la URL
        data_imagen[:url_imagen] = getUrl(data_imagen[:id_bucket])

        return data_imagen
        

    end

    private
        def upload
            require 'httparty'
            require 'json'
            if @image == nil
                raise "No existe imagen"
            else
                response = HTTParty.post("http://ec2-3-227-65-124.compute-1.amazonaws.com:8081/api/S3Bucket/AddFile", body: {file: @image})
                if response.code == 200
                    #Aqui se debe devolver el id, de momento solo recibe el url
                    return JSON.parse(response.body)["message"]

                    #Retorno provisional 100% funcional
                    # return JSON.parse(response.body)["message"].slice(47,JSON.parse(response.body)["message"].length)
                else 
                    raise "Fallo en la subida de la imagen"
                end
            end
        end

        def getUrl(id_bucket)
            require 'httparty'
            require 'json'
            if id_bucket == nil
                raise "No existe ID, error en la subida de la imagen"
            else
                response = HTTParty.get("http://ec2-3-227-65-124.compute-1.amazonaws.com:8081/api/S3Bucket/GetFile/#{id_bucket}")
                if response.code == 200
                    return JSON.parse(response.body)["message"]
                else
                    raise "Error al recuperar la Imagen" 
                end
            end
        end
end