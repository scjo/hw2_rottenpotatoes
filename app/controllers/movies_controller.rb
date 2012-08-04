class MoviesController < ApplicationController

  def initialize
    @ratings = []
    super
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @all_ratings = Movie.all_ratings
    @header_class={}

    if params[:ratings]
      @ratings = params[:ratings]

      if @ratings.is_a?(Hash)
        @ratings = @ratings.keys
      end
    end

    if ["title", "rating", "release_date"].include? params[:sort_by]
      @movies = Movie.find(:all, :order => params[:sort_by], :conditions => {:rating => @ratings})
      @header_class[params[:sort_by].to_sym] = "hilite"
    else
      @movies = Movie.find(:all, :conditions => {:rating => @ratings})
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
