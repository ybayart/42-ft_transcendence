class Api::PostsController < ApiController
	before_action :set_post, only: [:show, :edit, :update, :destroy]

	# GET /posts
	# GET /posts.json
	def index
		@posts = Post.all
		render json: @posts
	end

	# GET /posts/1
	# GET /posts/1.json
	def show
		render json: @post
	end

	# GET /posts/new
	def new
		@post = Post.new
	end

	# GET /posts/1/edit
	def edit
	end

	# POST /posts
	# POST /posts.json
	def create
		@post = Post.new(post_params)

		if @post.save
			render json: @post
		else
			render json: @post.errors, status: :unprocessable_entity
		end
	end

	# PATCH/PUT /posts/1
	# PATCH/PUT /posts/1.json
	def update
		if @post.update(post_params)
			render :show, status: :ok, location: @post
		else
			render json: @post.errors, status: :unprocessable_entity
		end
	end

	# DELETE /posts/1
	# DELETE /posts/1.json
	def destroy
		@post.destroy
		head :no_content
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_post
			@post = Post.find(params[:id])
		end

		# Only allow a list of trusted parameters through.
		def post_params
			params.require(:post).permit(:title, :content)
		end
end