class UsersController < ApplicationController
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    render json: @users
  end
  
  # GET /users/splatts-feed/1
  def splatts_feed
    @feed = Splatt.find_by_sql("SELECT splatts.body, splatts.user_id, splatts.id, splatts.created_at FROM splatts JOIN follows ON follows.followed_id=splatts.user_id WHERE follows.follower_id=#{params[:id]} ORDER BY created_at DESC")

    render json: @feed
  end

  # GET /users/splatts/[:id]
  def splatts
    @user = User.find(params[:id])
    
    render json: @user.splatts
  end

  # GET /users/follows/[:id]
  def show_follows
    @user = User.find(params[:id])

    render json: @user.follows
  end

  # POST /users/follows
def add_follows
	@user = User.find(params[:id])
	@follows = User.find(params[:follows_id])
	if @user.follows << @follows and @follows.followers << @user
		head :no_content
		render json: @user.follows
	else
		render json: @user.errors, status: :unprocessable_entity
	end
end

  # DELETE /users/follows/1/2
  def delete_follows
    @user = User.find(params[:id])
    @follows = User.find(params[:follows_id])

    if @user.follows.delete(@follows)
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    render json: @user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params(params))
    
    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])

    if @user.update(user_params(params))
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    head :no_content
  end

private
  def user_params(params)
	  logger.info "params:  #{params}"
          params.permit(:id, :name, :email, :password, :blurb)
  end

  def set_headers
	  headers['Access-Control-Allow-Origin'] = '*'
  end

  # For all responses in this controller, return the CORS access control headers.
  def cors_set_access_control_headers
          headers['Access-Control-Allow-Origin'] = '*'
          headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
          headers['Access-Control-Max-Age'] = '1728000'
  end
  
  #                   # If this is a preflight OPTIONS request, then short-circuit the
  #                     # request, return only the necessary headers and return an empty
  #                       # text/plain.
  #
  def cors_preflight_check
          headers['Access-Control-Allow-Origin'] = '*'
          headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
          headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
          headers['Access-Control-Max-Age'] = '1728000'
  end

end
