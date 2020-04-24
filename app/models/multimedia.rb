class Multimedia
  include Mongoid::Document
  include Mongoid::Timestamps


  store_in collection: 'multimedias'

  field :descripcion, type: String
  field :url, type: String
  field :formato, type: String
  field :tamano, type: String
  field :id_bucket, type: String

  belongs_to :usuario_creador, class_name: "Usuario", inverse_of: :multimedia_creada 
  has_and_belongs_to_many :etiquetas_relacionadas, class_name: "Etiqueta", inverse_of: :multimedia_relacionada 
  has_and_belongs_to_many :tableros_agregados, class_name: "Tablero", inverse_of: :multimedia_agregada 
  
end
