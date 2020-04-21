class Tablero
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in collection: 'tableros'

  field :_id, type:String
  has_and_belongs_to_many :multimedia_agregada, class_name: "Multimedia", inverse_of: :tableros_agregados 
end
