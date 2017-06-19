require 'test_helper'

class BooksGalleyTest < ActionDispatch::IntegrationTest
    
    def setup
        @book = books(:public) 
    end
    
    test "galley sections render" do
        get galley_book_path(@book, position: "front")
        assert_select ".page", count: 3
        assert_select ".sidebar", count: 3
        
        @book.sections.each do |section|
            assert_select ".rendered-text", section.text
        end
    end
            
end
