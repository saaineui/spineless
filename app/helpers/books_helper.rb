module BooksHelper
  PAGE_POSITIONS = %w[FL FR BL BR].freeze
    
  def link_to_next(book, location) 
    return nil if location + 1 >= book.max_number_of_locations
    link_to 'Next', open_book_path(book, location + 1), id: 'next-btn'
  end
  
  def link_to_previous(book, location) 
    return nil if location <= 0
    link_to 'Back', open_book_path(book, location - 1), id: 'back-btn'  
  end
  
  def sidebar_text(page) 
    if page
      [
        'S' + page['signature'].to_s,
        'So' + page['signature_order'].to_s,
        PAGE_POSITIONS[page['page_position']],
        '--' + page['page_num'].to_s
      ].join('-')
    else
      '[sidebar]'
    end
  end
end
