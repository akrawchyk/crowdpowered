class SuppliesController < ApplicationController
  def create
      @supply = Event.find(params[:event_id]).supplies.new(supply_params)
      @supply.save

      flash[:notice] = "Supply has been added!"
      redirect_to edit_event_path(@supply.event)
    end

    private
    def supply_params
      params.require(:supply).permit(:name, :quantity, :price)
    end
  end