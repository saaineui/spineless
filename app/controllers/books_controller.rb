class BooksController < ApplicationController
    before_action :admin_user, only: [:index, :new, :create, :edit, :update, :destroy, :upload, :update_length]

    def index
        @books = Book.all
    end

    def new
        @book = Book.new
    end

    def create
        @book = Book.new(book_params)
        if @book.save
            flash[:success] = "#{@book.title} has been added."
            redirect_to @book
        else
            render 'new'
        end
    end

    def show
		@override_title_logo = true
		@book = Book.find(params[:id])
		@location = params[:l].to_i || 0
		
		@override_background = @book.background_image_url.present?
		@background_image_url = @book.background_image_url
    end

    def edit
		@book = Book.find(params[:id])
    end

	def update
		@book = Book.find(params[:id])
		if @book.update_attributes(book_params)
			redirect_to @book
			flash[:success] = "#{@book.title} has been updated."
		else
			render 'edit'
		end
	end

	def upload
		@book = Book.find(params[:id])
	end

    def update_length
		@book = Book.find(params[:id])
        @book.text_length = 0
		@book.sections.each do |section|
			@book.text_length += section.text.length
		end
        if @book.save
            flash[:success] = "#{@book.title} text length has been updated to #{@book.text_length}."
		end
		redirect_to books_path
    end

    def destroy
    end

  private
  def book_params
      params.require(:book).permit(:title, :author, :logo_url, :copyright, :epigraph, :cover_image_url, :background_image_url, :text_length, section_attributes: [:id,:title])
  end
  
  # Before filters
  
  # Confirms an admin user.
  def admin_user
      redirect_to(root_url) unless logged_in? && current_user.admin?
  end
end
