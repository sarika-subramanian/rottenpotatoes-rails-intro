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
    #@movies = Movie.all
    if session[:ratings] == nil
      session[:ratings] = Movie.all_ratings
    end
    @sort = nil
    @ratings = Movie.all_ratings
    if params[:sort] != nil
      @sort = params[:sort]
      session[:sort] = @sort
    end
    if params.keys.any?
      if params[:ratings]
        @ratings = params[:ratings].keys
        session[:ratings] = @ratings
      end
    end
    
    if session[:sort] != nil && session[:ratings].empty?
      @movies = Movie.order(session[:sort])
    elsif session[:ratings].any? && session[:sort] != nil
      @movies = Movie.order(session[:sort]).where(rating: session[:ratings])
    elsif session[:ratings].any?
      @movies = Movie.where(rating: session[:ratings])
    else
      @movies = Movie.all
    end
    @hilite = session[:sort]
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