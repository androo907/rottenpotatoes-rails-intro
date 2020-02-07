class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']
    @saved_ratings = {'G'=>'1','PG'=>'1','PG-13'=>'1','R'=>'1'}
    if params[:commit] == 'Refresh'
      session[:ratings] = params[:ratings]
    end
    
    if params[:order] == 'title' || params[:order] == 'release_date'
      session[:order] = params[:order]
    end
    
    if session[:ratings].nil?
      session[:ratings] = @saved_ratings
    end
    
    @saved_ratings.each do |rating|
      @saved_ratings = session[:ratings]
    end
      
    @movies = Movie.order(session[:order]).with_ratings(session[:ratings].keys)
    
    
    if session[:order] == 'title'
      @title_header = 'hilite'
    elsif session[:order] == 'release_date'
      @release_date_header = 'hilite'
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
