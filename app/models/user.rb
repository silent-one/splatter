class User
 	include Mongoid::Document
	embeds_many :splatts	

	field :name, type: String
	field :email, type: String
	field :password, type: String
	field :blurb, type: String
	
	has_and_belongs_to_many :follows, class_name: "User"
	has_and_belongs_to_many :followers, class_name: "User"		

end
