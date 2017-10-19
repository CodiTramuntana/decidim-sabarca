module Decidim
  module Sabarca
    # Abstract class from which all models in this engine inherit.
    class MayorNeighborhood < Decidim::ApplicationRecord
      belongs_to :organization, foreign_key: "decidim_organization_id", class_name: "Decidim::Organization"
      belongs_to :scope, foreign_key: "decidim_scope_id", class_name: "Decidim::Scope"


      validates :title, presence: true, uniqueness: { scope: :organization }
      validates :decidim_scope_id, presence: true
      validates :slug, uniqueness: { scope: :organization }

      geocoded_by :address

      after_validation :geocode

    end
  end
end
