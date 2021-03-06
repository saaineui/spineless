module ApplicationHelper
  def clean_title
    @title ||= {}
    @title[:title] = 'Spineless' unless @title.key?(:title)
    @title[:subtitle] = @title[:subtitle].present? ? ' | ' + @title[:subtitle] : ''
    @title[:title] + @title[:subtitle]
  end
  
  def render_body_classes
    [controller.controller_name, controller.action_name].join(' ')
  end
  
  def render_css(props, data)
    props.map { |prop| [prop.sub('_', '-'), data[prop]].join(': ') }.join('; ')
  end
  
  def books_show?
    controller.controller_name.eql?('books') && controller.action_name.eql?('show')
  end
  
  def to_valid_dividend(num)
    num.to_i.zero? ? 1 : num
  end
end
