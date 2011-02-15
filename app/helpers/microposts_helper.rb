module MicropostsHelper
  
  def full_feed
    if signed_in? then
      @feed_items = current_user.feed.paginate(:page => params[:page])
    else
      @feed_items = []
    end
  end
end
