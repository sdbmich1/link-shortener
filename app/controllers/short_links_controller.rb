class ShortLinksController < ApplicationController
  before_action :fetch_short_link, only: [:show, :edit, :update]

  def index
    @short_link = ShortLink.find_by_short_url(params[:short_url])
    if @short_link.nil? || @short_link&.expired
      render file: "#{Rails.root}/public/404.html", status: 404
    else
      ShortLink.increment_counter(:view_count, @short_link.id)
      redirect_to @short_link.original_url
    end
  end

  def new
    @short_link = ShortLink.new
  end

  def create
    dup_link = ShortLink.find_by_original_url(params[:short_link][:original_url])
    if dup_link.nil?
      @short_link = ShortLink.new(original_url: params[:short_link][:original_url])
      if @short_link.save
        redirect_to @short_link
      else
        flash[:error] = @short_link.errors.full_messages
        render 'new'
      end
    else
      flash[:notice] = 'A short link already exists for this URL in our database.'
      redirect_to dup_link
    end
  end

  def show
    render_output('show')
  end

  def edit
    render_output('edit')
  end

  def update
    if @short_link.update(expired: params[:short_link][:expired])
      flash[:notice] = 'Update Successful.'
      redirect_to @short_link
    else
      flash[:error] = @short_link.errors.full_messages
      redirect_to :edit
    end
  end

  private

  def fetch_short_link
    @short_link = ShortLink.find_by_id(params[:id]) || ShortLink.find_by_uuid(params[:id])
  end

  def url_params
    params.require(:short_link).permit(:original_url, :expired)
  end

  def render_output(template_name)
    if @short_link
      render template_name
    else
      render file: "#{Rails.root}/public/404.html", status: 404
    end
  end
end
