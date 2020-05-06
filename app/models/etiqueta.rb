class Etiqueta
  include Mongoid::Document
  include Mongoid::Timestamps
  
  store_in collection: 'etiquetas'

  field :_id, type:String
  has_and_belongs_to_many :multimedia_relacionada, class_name: "Multimedia", inverse_of: :etiquetas_relacionadas
end
