module Stage
  class Product < Stage::Base
    self.collection_name = :store

    class << self
      def fetch(id)
        new(get(:detail, id: id)['data'])
      end

    end

    def image_urls(size = 320)
      return [] if resources.blank?

      resources.map { |resource| [PIC_DOMAIN, resource.name, "_#{size}X0.jpg"].join('')}
    end
  end
end
