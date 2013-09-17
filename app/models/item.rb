class Item
  include Mongoid::Document
  belongs_to :items

  field :type,			:type => String
  field :name,			:type => String
  field :size,			:type => String
  field :sauce,			:type => String
  field :flavor,		:type => String
  field :veggies,		:type => Array

  field :quantity,		:type => Integer
  field :single_cost,	:type => Integer
  field :total_cost,	:type => Integer

  validates :items, :presence => :true
  before_save :calculate_data

  def calculate_data
	total_cost = single_cost * quantity  	
  end
end
