class PlacesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_place, only: [:show, :edit, :update, :destroy]
  before_action :check_user, only: [:edit, :update, :destroy]

  def index
    @places = Place.order(:name).page params[:page]
  end

  def new
    @place = Place.new
  end

  def create
    @place = current_user.places.create(place_params)
    if @place.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @comment = Comment.new
    @photo = Photo.new
  end

  def edit
  end

  def update
    @place.update_attributes(place_params)
    if @place.valid?
      flash[:notice] = "Successfully updated!"
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @place.destroy
    redirect_to root_path
  end

  private

  def set_place
    @place = Place.find(params[:id])
  end

  def check_user
    if @place.user != current_user
      render plain: "Not Allowed", status: :forbidden
    end
  end


  def place_params
    params.require(:place).permit(:name, :description, :address)
  end

end
