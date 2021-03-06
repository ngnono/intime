require 'cacheable'
module Stage
  class Product < Stage::Base
    self.collection_name = :product
    extend Cacheable
    class << self
      def fetch(id)
        new(get(id)['data'])
      end

      def list(options = {})
        get(:list, options)
      end

      def search(options = {})
        get(:search, options)
      end

      def item_list(options = {})

        raw_data = list(options)['data']

        products = raw_data['products'].inject([]) do |_r, _p|
          _r << self.new(_p)
          _r
        end

        Kaminari.paginate_array(
          products,
          total_count: raw_data['totalcount'].to_i
        ).page(raw_data['pageindex']).per(raw_data['pagesize'])
      end
      
      def list_configurations
        cache_get('product_list_configurations',4.hours) {
          stores   = Stage::Store.list
          brands   = Stage::Brand.group_brands[:brands]
          tags     = Stage::Tag.list
          hotwords = Stage::HotWord.list
          configurations = {:stores=>stores,:brands=>brands,:tags=>tags,:hotwords=>hotwords}
          configurations
        }
      end
    end

    def image_urls(size = 320)
      return [] if resources.blank?

      resources.map { |resource| [PIC_DOMAIN, resource.name, "_#{size}x0.jpg"].join('')}
    end
  end
end
