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
    # @movies = Movie.all
    @all_ratings=Movie.load
    @select_ratings=params[:ratings]
    @sort=params[:s_method]

    use_session=false
    #handle session
    if @sort
      session[:s_method]=@sort
    elsif session[:s_method]
      @sort=session[:s_method]
      use_session=true
    else
      @sort=nil
    end

    if @select_ratings
      session[:ratings]=@select_ratings
    elsif session[:ratings]
      @select_ratings=session[:ratings]
      use_session=true
    else 
      @select_ratings=nil
    end 

    if use_session
      flash.keep
      redirect_to movies_path :s_method=>@sort, :ratings=>@select_ratings
    end

    if @select_ratings&&@sort
      @movies=Movie.where(:rating=>@select_ratings.keys).order(@sort)
    elsif @select_ratings
      @movies=Movie.where(:rating=>@select_ratings.keys).all
    elsif @sort
      @movies=Movie.order(@sort)
    else
      @movies=Movie.all
    end
    
    @select_ratings=params[:ratings]
    if @select_ratings==nil
       @select_ratings=Hash.new
    end
    @s_method=params[:s_method]


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

  # def sort
  #   @movies = Movie.all
  #   @movies=@movies.sort_by{|movie|movie.release_date}
  # #   # for i in 0..data.size-2
  #   #   for j in 1..data.size-1-i
  #   #     if(data(j)<(data(j-1)))
  #   #       temp=data(j)
  #   #       data(j)=data(j-1)
  #   #       data(j-1)=temp
  #   #     end 
  #   #   end
  #   # end 
  #   # redirect_to movies_path
  # end      
end
