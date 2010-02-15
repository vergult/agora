class QuotesController < ApplicationController
  before_filter  :login_required

  def create
    quote = current_user.quotes.build(params[:quote])
    quote.message = quote.message[0..139]
    quote.created_at = Time.now # Hack, have to figure why created_at not automatically updated
    quote.save!
    redirect_to root_path
  end
  
  def destroy
    
  end

end
