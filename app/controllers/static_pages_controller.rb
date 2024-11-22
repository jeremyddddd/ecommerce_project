class StaticPagesController < ApplicationController
  def show
    @page = Page.find_by(slug: params[:slug])
    if @page.nil?
      render plain: "Page not found", status: :not_found
    end
  end
end
