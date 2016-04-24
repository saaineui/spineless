class SectionsController < ApplicationController
    before_action :admin_user, only: [:new]
    
    def new
		@assign_chapter_numbers = params[:upload][:assign_chapters].to_i == 1
		@book = Book.find(params[:upload][:book_id])
		raw_text = Nokogiri::HTML(params[:upload][:ebook_file])
		
		# Destroy old sections - not sure about this...
		@book.sections.each do |section|
			section.delete
		end
		
		@book.text_length = raw_text.to_s.length
		@book.sections = []
		
		chapter_num = 0
		
		raw_text.xpath("//section").each do |section|
			this_section = Section.new
			this_section.order = @book.sections.count + 1
			this_section.title = ""
			if section.xpath("//header").length > 0 && section.xpath("//header").first.parent == section
				this_section.title = section.xpath("//header").first.inner_text.to_s.gsub(/\a/,"").gsub(/\s+/," ")
				if @assign_chapter_numbers
					chapter_num += 1
					this_section.chapter = chapter_num
				end 
			end
			this_section.text = section.to_s
			this_section.indexable = !this_section.title.empty?
			if this_section.save
				puts "Section #{this_section.title} saved."
			else
				flash[:error] = "Your upload failed."
			end
			@book.sections << this_section
			section.unlink
		end
		if @book.save
			flash[:success] = "Your file was uploaded successfully."
		else
			render upload_book_path(@book)
		end
    end
    
  private
  def section_params
      params.require(:section).permit()
  end
  
  # Before filters
  
  # Confirms an admin user.
  def admin_user
      redirect_to(root_url) unless logged_in? && current_user.admin?
  end
	
end
