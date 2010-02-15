class HomeController < ApplicationController
  # login_required in lib/authentication
  before_filter :login_required
  
  def index
    @quotes = current_user.all_quotes
    @last_quote = current_user.quotes.last
  end
  
  def show
    @user = User.find_by_username params[:username]
    @quotes = @user.quotes
  end
  
  def toggle_follow
    @user = User.find_by_username params[:username]
    if current_user.is_friend? @user
      flash[:notice] = "You are no longer following #{@user.username}"
      current_user.remove_friend(@user)
    else
      flash[:notice] = "You are now following #{@user.username}"
      current_user.add_friend(@user)
    end
    redirect_to user_quotes_path(@user.username)
  end
  
  def toggle_follow_via_ajax
    user = User.find_by_username params[:username]
    if current_user.is_friend? user
      current_user.remove_friend(user)
    else
      current_user.add_friend(user)
    end
    render :text => user.username
end
  
  def following
    @friends = current_user.friends
  end
  
  def remove_friend
    friend = User.find_by_username params[:username]
    if friend
      current_user.remove_friend(friend)
      render :text => friend.username
    else
      render :text => "None"
    end
  end
  
  def search
    @q = params[:q]
    @users = User.find_by_search_query(@q)
    @users.delete(current_user) if @users.include? current_user
  end
  
end
