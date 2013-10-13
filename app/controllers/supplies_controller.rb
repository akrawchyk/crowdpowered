class SupplyController < ApplicationController
  def create
      @supply = Event.find(param[:event_id]).supplies.new(supply_params)
      @supply.save

      flash[:notice] = "Supply has been added!"
      redirect_to @supply.event
    end

    private
    def supply_params
      params.require(:comment).permit(:comment, :commentable_id, :commentable_type)
    end
  end