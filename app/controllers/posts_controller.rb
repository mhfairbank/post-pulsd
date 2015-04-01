class PostsController < ApplicationController
	def index
		@posts = Post.all
		@user = User.new
	end

	def new
		@post = Post.new
	end

	def show
		@post = Post.find(params[:id])
	end

	def create
		Post.create(post_params)
		redirect_to root_path
	end

	private
    def post_params
      params.require(:post).permit(:venue, :details, :address, :price, :description, :url)
    end
end