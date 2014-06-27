class UrlsController < ApplicationController
  before_action :set_url, only: [:show, :edit, :update, :destroy]

  def redirect
    @url = Url.find_by_shortened_extension(params[:shortened_extension])
    redirect_to @url.original_url, :status => @url.status
  end

  def show
  end

  # GET index
  # /urls
  def index
    @urls = Url.all
  end

  # GET new
  # /urls/new
  def new
    @url = Url.new
  end

  # GET edit
  # /urls/:id/edit
  def edit
  end

  # POST create
  # /urls
  # Looks for a url match to several formats of a valid url. Otherwise, will initialize a new url.
  def create
    existing_url = params[:url][:original_url]

    @url = Url.where(original_url: [existing_url, "http://#{existing_url}", "http://www.#{existing_url}"]).first_or_initialize
    @url.assign_attributes(url_params)

    respond_to do |format|
      if @url.persisted?
        format.html {redirect_to @url, notice: "We've already redirected this url. Check out the shortened url below."}
      elsif @url.save
        format.html { redirect_to @url, notice: 'Url was successfully created.' }
        format.json { render action: 'show', status: :created, location: @url }
      else
        format.html { render action: 'new' }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH update
  # urls/:id
  def update
    respond_to do |format|
      if @url.update(url_params)
        format.html { redirect_to @url, notice: 'Url was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /urls/1
  # DELETE /urls/1.json
  def destroy
    @url.destroy
    respond_to do |format|
      format.html { redirect_to urls_url }
      format.json { head :no_content }
    end
  end

  private
    def set_url
      @url = Url.find(params[:id])
    end

    def url_params
      params.require(:url).permit(:original_url, :shortened_extension, :status)
    end
end
