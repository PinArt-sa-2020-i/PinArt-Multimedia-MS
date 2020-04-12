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
        response = HTTParty.delete("http://ec2-3-227-65-124.compute-1.amazonaws.com:8081/api/S3Bucket/DelFile/#{@id}")
        if response.code == 200
            return "ok"
        else
            raise "Error al eliminar la Imagen" 
        end
    end
  end
end