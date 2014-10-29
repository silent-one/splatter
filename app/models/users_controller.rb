def splatts
	db = UserRepository.new(Riak::Client.new)
	@user = db.find(params[:id])
	db = SplattRepository.new(Riak::Client.new, @user)
	render json: db.all
end
