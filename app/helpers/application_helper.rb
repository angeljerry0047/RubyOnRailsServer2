module ApplicationHelper

  def display_base_errors resource
    if resource.errors.empty?
      return ''
    else
      messages = ''.html_safe
      resource.errors.each do |id, msg|
        if [id, msg].join(' ').capitalize == 'Password is invalid' 
          messages += content_tag(:p, [id, msg].join(' ').capitalize + 
          ' it must contain at least one numeric character')  
        else
          messages += content_tag(:p, [id, msg].join(' ').capitalize)  
        end        
      end
      bootstrap_alert(messages)
    end
  end
  
  def field_class(resource, field_name)
    puts "#{field_name}: #{resource.errors[field_name].count}"
    if resource.errors[field_name].count > 0
      return "error".html_safe
    else
      return "".html_safe
    end
  end

  def bootstrap_alert(text)
    content_tag :div, :class => "alert alert-error alert-block" do
      buf = content_tag :button, "&#215;".html_safe, :class => 'close', :"data-dismiss" => 'alert', :type => 'button'
      buf + text
    end
  end
  
  def invite_pagination range
    html = ''
    num_pages = range.last

    if @page - 5 > 0 && @page + 5 <= num_pages
      left = @page - 5
    elsif @page - 5 > 0 && num_pages - 10 > 0
      left = num_pages - 10
    end

    if @page + 5 < 10 && num_pages > 10
      right = 10
    elsif @page + 5 >= 10 && @page + 5 <= num_pages
      right = @page + 5
    end

    unless @page == 1
      html += link_to "First", params.merge(:page => 1)
      html += link_to "Previous", params.merge(:page => @page-1)
    end

    
    ((left || 1)..(right || num_pages)).each do |page|
      html += link_to page, params.merge(:page => page), :class => (page == @page ? "active" : "")
    end

    if @page + 5 < num_pages && num_pages > 10
      html += " ... "
      html += link_to num_pages, params.merge(:page => num_pages)
    end
    
    html += link_to "Next", params.merge(:page => @page+1) unless @page >= num_pages
    
    return html.html_safe
  end
  
  def site_title
    Serve2perform::Application.config.site_title
  end
  
  def site_description
    Serve2perform::Application.config.site_title
  end
  
  def markdown
    renderer = Redcarpet::Render::HTML.new(filter_html: true, hard_wrap: true, link_attributes: { target: "_blank" })
    markdown = Redcarpet::Markdown.new(renderer, extensions = {autolink: true})
  end
  
  def selected?(current_user, child)
    return '' if !current_user.is_a?(User)
    if current_user.has_child?(child)
      'selected'
    else
      ''
    end
  end

  def valid_api_key?
    ApiKey.where(access_token: request.headers['Authorization']).first
  end
  
end
