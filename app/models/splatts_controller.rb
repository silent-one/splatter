def create
	@splatt = Splatt.new
	@splatt.id = SecureRandom.uuid
	@splatt.created_at = Time.now
	@splatt.body = params[:body]
	client = Riak::Client.new
	user = UserRepository.new(client).find(params[:user])
	db = SplattRepository.new(client, user)

	if db.save(@splatt)
		render json: @splatt, status: :created, location: @splatt
	else
		render json: @splatt.errors, status: :unprocessable_entity
	end
end
