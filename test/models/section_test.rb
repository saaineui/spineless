require 'test_helper'

class SectionTest < ActiveSupport::TestCase

    def setup
        @section = Section.new(title: "Functions", order: 3, chapter: 2, text: "Lorem ipsum", indexable: true)
    end
    
    test "should be valid" do
        assert @section.valid?
    end

    test "order should be present" do
        @section.order = nil
        assert_not @section.valid?
    end
    
    test "chapters scope returns array of all indexable sections" do
        assert_equal Section.chapters.count, 3
        
        Section.chapters.each do |section|
            assert section.indexable
        end
    end
    
    test "index_prefix method returns formatted chapter number if chapter exists" do
        assert_equal @section.index_prefix, "2. "
    end
    
    test "index_prefix method returns empty string if chapter is nil" do
        @section.chapter = nil
        
        assert_equal @section.index_prefix, ""
    end
    
    test "index_title method returns expressive title string" do
        assert_equal @section.index_title, "2. Functions"
    end
    
    test "index_title method returns expressive title string if chapter is nil" do
        @section.chapter = nil
        
        assert_equal @section.index_title, "Functions"
    end
    
    test "book_location method returns location pointing to section" do
        @section_with_book = sections(:one)
        
        assert_equal @section_with_book.book_location, 4
        @section_with_book.books.uniq.each do |book| # did wrong data structure here should be 1:many book:sections
            assert_equal book.get_section_from_location(@section_with_book.book_location), @section_with_book
        end
    end
    
end