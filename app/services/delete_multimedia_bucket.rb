class DeleteMultimediaBucket < ApplicationService
  def initialize(id_bucket)
    @id = id_bucket
  end

  def execute
    require 'httparty'
    require 'json'

    if @id == nil
        raise "No existe ID, error en la eliminacion de la imagen"
    else
        response = HTTParty.delete("http://3.227.65.124:8081/api/S3Bucket/DeleteFile/#{@id}")
        if response.code == 200
            return OK
        else
            raise "Error al eliminar la Imagen" 
        end
    end
  end
end