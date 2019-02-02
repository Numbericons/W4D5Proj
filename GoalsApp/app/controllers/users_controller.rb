class UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
    end

    def index
        @users = User.all 
    end

    def new
        render :new 
    end

    def create
        
    end

    private
    def user_params
        params.require(:user).permit(:username, :password)
    end
end
