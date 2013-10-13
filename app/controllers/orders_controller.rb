class OrdersController < ApplicationController
  #before_filter :authenticate_user!
  def index
    @orders = Event.find(params[:event_id]).orders.where(user: current_user).all( :limit => 10, :order => "id DESC" )
  end

  # GET /events/new
  def new
    @event = Event.find(params[:event_id])
    @order = Order.new(event: @event)
  end

  def create
    @event = Event.find(params[:event_id])
    @order = current_user.orders.build
    @order.attributes = params[:order]
    @order.event = @event

    @order.return_url = order_execute_url(":order_id")
    @order.cancel_url = order_cancel_url(":order_id")
    if @order.payment_method and @order.save
      if @order.approve_url
        redirect_to @order.approve_url
      else
        redirect_to orders_path, :notice => "Order[#{@order.description}] placed successfully"
      end
    else
      render :create, :alert  => @order.errors.to_a.join(", ")
    end
  end

  def execute
    order = current_user.orders.find(params[:order_id])
    if order.execute(params["PayerID"])
      redirect_to orders_path, :notice => "Order[#{order.description}] placed successfully"
    else
      redirect_to orders_path, :alert => order.payment.error.inspect
    end
  end

  def cancel
    order = current_user.orders.find(params[:order_id])
    unless order.state == "approved"
      order.state = "cancelled"
      order.save
    end
    redirect_to orders_path, :alert => "Order[#{order.description}] cancelled"
  end

  def show
    @order = current_user.orders.find(params[:id])
  end
end
