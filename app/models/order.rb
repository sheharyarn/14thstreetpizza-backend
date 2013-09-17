class Order
  include Mongoid::Document

  has_many :items
  belongs_to :user

  field :location_auto,		:type => Array
  field :location_pinned,	:type => Array
  field :location_address,	:type => String
  field :comments,			:type => String
  field :total_cost,		:type => Integer
end
