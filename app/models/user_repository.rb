class UserRepository
BUCKET = 'users'
# sets up our connection to the Riak db
def initialize(client)
	@client = client
end

def all
end

def delete(user)
end

def find(key)
	riak_obj = @client.bucket(BUCKET)[key]
	user = User.new
	user.email = riak_obj.data['email']
	user.name = riak_obj.data['name']
	user.password = riak_obj.data['password']
	user.blurb = riak_obj.data['blurb']
	user.follows = riak_obj.data['follows']
	user.followers = riak_obj.data['followers']
	user
end

def save(user)
	users = @client.bucket(BUCKET)
	key = user.email

	unless users.exists?(key)
		riak_obj = users.new(key)
		riak_obj.data = user
		riak_obj.content_type = 'application/json'
		riak_obj.store
	end
end

def update(user)
end

def create
	@user = User.new
	@user.email = params[:email]
	@user.name = params[:name]
	@user.password = params[:password]
	@user.blurb = params[:blurb]

	db = UserRepository.new(Riak::Client.new)

	if db.save(@user)
		render json: @user, status: :created, location: @user
	else
		render json: "error", status: :unprocessable_entity
	end
end

def show
	db = UserRepository.new(Riak::Client.new)
	@user = db.find(params[:id])
	render json: @user
end


def follow(follower, followed)
	if follower.follows
		follower.follows << followed.email
	else
		follower.followed = [followed.email]
	end

	if followed.followers
		followed.followers << follower.email
	else
		followed.followers = [follows.email]
	end
	update(followed)
	update(follwer)
end

end
