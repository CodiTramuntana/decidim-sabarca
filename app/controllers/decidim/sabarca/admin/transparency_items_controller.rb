# frozen_string_literal: true

module Decidim
  module Sabarca
    module Admin
      class TransparencyItemsController < Decidim::Admin::ApplicationController
        def index
          enforce_permission_to :read, :admin_dashboard
          @transparency_items ||= collection
        end

        def new
          enforce_permission_to :read, :admin_dashboard
          @form = form(Decidim::Sabarca::Admin::TransparencyItemForm).from_params({})
        end

        def create
          enforce_permission_to :read, :admin_dashboard

          @form = form(Decidim::Sabarca::Admin::TransparencyItemForm).from_params(form_params)

          CreateTransparencyItem.call(@form) do
            on(:ok) do
              flash[:notice] = I18n.t("transparency_items.create.success", scope: "decidim.admin.actions")
              redirect_to decidim_sabarca.admin_transparency_items_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("transparency_items.create.error", scope: "decidim.admin.actions")
              render :new
            end
          end
        end

        def edit
          @transparency_item = collection.find(params[:id])
          enforce_permission_to :read, :admin_dashboard

          @form = form(Decidim::Sabarca::Admin::TransparencyItemForm).from_model(@transparency_item)
        end

        def update
          @transparency_item = collection.find(params[:id])
          enforce_permission_to :read, :admin_dashboard

          @form = form(Decidim::Sabarca::Admin::TransparencyItemForm).from_params(form_params)

          UpdateTransparencyItem.call(@transparency_item, @form) do
            on(:ok) do
              flash[:notice] = I18n.t("transparency_items.update.success", scope: "decidim.admin.actions")
              redirect_to decidim_sabarca.admin_transparency_items_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("transparency_items.update.error", scope: "decidim.admin.actions")
              render :edit
            end
          end
        end

        def destroy
          @transparency_item = collection.find(params[:id])
          enforce_permission_to :read, :admin_dashboard

          DestroyTransparencyItem.call(@transparency_item) do
            on(:ok) do
              flash[:notice] = I18n.t("transparency_items.destroy.success", scope: "decidim.admin.actions")
            end

            on(:invalid) do
              flash[:alert] = I18n.t("transparency_items.destroy.error", scope: "decidim.admin.actions")
            end

            redirect_back(fallback_location: decidim_sabarca.admin_transparency_items_path)
          end
        end

        private

        def form_params
          form_params = params.to_unsafe_hash
          form_params["transparency_item"] ||= {}
          form_params["transparency_item"]["decidim_organization_id"] = current_organization.id

          form_params
        end

        def transparency_item
          @transparency_item ||= collection.find_by(id: params[:id])
        end

        def collection
          Decidim::Sabarca::TransparencyItem.where(decidim_organization_id: current_organization.id)
        end
      end
    end
  end
end
