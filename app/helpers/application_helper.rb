module ApplicationHelper
  
  def title
    base_title = "Ruby test app"
    if @title.nil? then
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def logo
    src = '/images/logo.png'
    alt = "Sample App"
    cls = "round"
    #/images/logo.png', :alt=> "Sample App", :class => "round"
    image_tag( src, :alt => alt, :class => cls)
    
  end
end
