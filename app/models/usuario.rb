class Usuario
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in collection: 'usuarios'

  field :_id, type:String
  has_many :multimedia_creada, class_name: "Multimedia", inverse_of: :usuario_creador

end
