# frozen_string_literal: true

module Decidim
  module Sabarca
    # Abstract class from which all models in this engine inherit.
    class MayorNeighborhood < Decidim::Sabarca::ApplicationRecord
      belongs_to :organization, foreign_key: "decidim_organization_id", class_name: "Decidim::Organization"
      belongs_to :scope, foreign_key: "decidim_scope_id", class_name: "Decidim::Scope"

      validates :title, presence: true, uniqueness: { scope: :organization }
      validates :decidim_scope_id, presence: true
      validates :slug, uniqueness: { scope: :organization }

      geocoded_by :address

      after_validation :geocode

      scope :upcoming, -> { where("start_time >= ? ", Time.current).order(start_time: :asc) }
      scope :past, -> { where("start_time <= ? ", Time.current).order(start_time: :desc) }
    end
  end
end
