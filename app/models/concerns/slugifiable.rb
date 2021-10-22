module Slugifiable
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def find_by_slug(query)
      self.all.find{ |item| item.slug ==  query}
    end
  end

  module InstanceMethods
    def slug
      name.parameterize
    end
  end
end
