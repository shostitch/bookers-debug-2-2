class UsersController < ApplicationController

  before_action :ensure_correct_user, only: [:edit,:update]

  def show
    @user = User.find(params[:id])
    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    @books = @user.books.includes(:favorited_users).
      sort {|a,b|
        b.favorited_users.includes(:favorites).where(created_at: from...to).size <=>
        a.favorited_users.includes(:favorites).where(created_at: from...to).size
      }
    @book_new = Book.new

  end

  def index
    @users = User.all
    @book = Book.new
    @user = current_user

  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
