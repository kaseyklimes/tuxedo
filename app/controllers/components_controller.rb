class ComponentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  layout "application"

  def show
    @component = Component.friendly.find(params[:id])
    @layout_object = @component
  end

  def edit
    @component = Component.find(params[:id])
  end

  def new
  end

  def update
    component = Component.find(params[:id])
    component.update_attributes(component_params)
    component.create_or_update_list(params[:component][:list_as_markdown])
    redirect_to action: "show", id: component.id
  end

  def create
    component = Component.create(component_params)
    component.create_list(params[:component][:list_as_markdown])
    redirect_to action: "show", id: component.id
  end

  def all
    @components = Component.all.map(&:name)
    respond_to do |format|
      format.json {}
    end
  end

  def delete
    Component.find(params[:id]).delete() if user_signed_in?
    redirect_to action: "admin", controller: "lists"
  end

  private

  def component_params
    params.require(:component).permit(:name, :description, :image, :nick)
  end
end