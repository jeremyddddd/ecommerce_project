class Province < ApplicationRecord
  has_many :users

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "gst", "hst", "id", "id_value", "name", "pst", "updated_at" ]
  end
end
