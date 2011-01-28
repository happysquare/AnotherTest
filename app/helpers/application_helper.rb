module ApplicationHelper
  def title
    base_title = "Ruby test app"
    if @title.nil? then
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end
