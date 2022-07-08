class PostsController < ApplicationController
    before_action :authenticate_user!
      def index
          if params[:search] == nil
              @posts= Post.all.page(params[:page]).per(3)
          elsif params[:search] == ''
              @posts= Post.all.page(params[:page]).per(3)
          else
              #部分検索
              @posts = Post.where("name LIKE ? ",'%' + params[:search] + '%').page(params[:page]).per(3)
          end
          if params[:search] == nil
            @posts= Post.all
          elsif params[:search] == ''
            @posts= Post.all
          else
            @posts = Post.where("name LIKE ? ",'%' + params[:search] + '%')
          end
          @random = Post.order("RANDOM()").first
          @rank_posts = Post.order(impressions_count: 'DESC')
      end
      def new
          @post=Post.new
      end
      def create
          post= Post.new(post_params)
          post.user_id = current_user.id
              if post.save
                redirect_to :action => "index"
              else
                redirect_to :action => "new"
              end
      end
      def show
          @post = Post.find(params[:id])
          impressionist(@post, nil, unique: [:ip_address])
          @comments = @post.comments
          @comment = Comment.new
          #@post = Post.find(params[:id])
        #if user_signed_in?
          #@post.browsing_history(current_user)
        #end
      end
      def edit
          @post = Post.find(params[:id])
      end
      def update
          post = Post.find(params[:id])
          if post.update(post_params)
            redirect_to :action => "show", :id => post.id
          else
            redirect_to :action => "new"
          end
        end
        def destroy
          post = Post.find(params[:id])
          post.destroy
          redirect_to action: :index
        end
      
      private
      def post_params
        params.require(:post).permit(:name, :image, :material, :process)
      end
  end