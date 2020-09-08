module Paginable
  extend ActiveSupport::Concern
  included do
    before_action :validate_page_param, only: %i[index]
    before_action :validate_per_page_param, only: %i[index]
  end

  MAX_PER_PAGE = 100
  PAGE_DEFAULT = 1
  PER_PAGE_DEFAULT = 20

  private

  def validate_page_param
    return if params[:page].blank?

    return if Integer(params[:page]) && params[:page].to_i.positive? rescue nil

    head(:bad_request)
  end

  def validate_per_page_param
    return if params[:per_page].blank?

    return if Integer(params[:per_page]) &&
              params[:per_page].to_i < MAX_PER_PAGE rescue nil

    head(:bad_request)
  end

  protected

  def current_page
    (params[:page] || PAGE_DEFAULT).to_i
  end

  def per_page
    (params[:per_page] || PER_PAGE_DEFAULT).to_i
  end

  def links_serializer_options(links_path, collection)
    {
      links: {
        first: send(links_path, page: PAGE_DEFAULT),
        last: send(links_path, page: collection.total_pages),
        prev: send(links_path, page: collection.prev_page),
        next: send(links_path, page: collection.next_page)
      }
    }
  end
end
