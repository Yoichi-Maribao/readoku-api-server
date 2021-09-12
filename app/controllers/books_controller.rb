class BooksController < ApplicationController
  before_action :authenticate_user!
  impressionist :actions => [:show]
  def index
    @user = current_user
    @books = Book.includes(:favorites).sort {|a,b| b.favorites.size <=> a.favorites.size }
    @book = Book.new
  end

  def show
    @book = Book.find(params[:id])
    @book_new = Book.new
    @book_comment = BookComment.new
    impressionist(@book, nil, uniquie: [:session_hash])
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user_id != current_user.id
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book.id), notice: "You have updated book successfully."
    else
      render 'edit'
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private
  def book_params
    params.require(:book).permit(:title, :body)
  end
end
