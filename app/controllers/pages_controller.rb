class PagesController < ApplicationController
  caches_action :index, :cache_path => Proc.new{|controller| controller.send(:pages_url, :no => controller.params[:no] || 1)}
  
  def index
    @page_no, list_per_page = request.format.atom? ? [1, Site.list_per_page_atom] : [(params[:no] || 1).to_i, Site.list_per_page]
    @pages = Page.list[(@page_no-1)*list_per_page...(@page_no)*list_per_page].map{|id| Page.find(id)}

    respond_to do |format|      
      format.html
      format.atom { render :layout => false }
    end
  end
  
  def show
    @page = page(params[:id]) 
    return render_404 unless @page

    @comments = Comment.find(@page)
  end
end