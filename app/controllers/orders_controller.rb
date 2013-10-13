class OrdersController < ApplicationController
  #before_filter :authenticate_user!

  def cancel
    order = current_user.orders.find(params[:order_id])
    unless order.state == "approved"
      order.state = "cancelled"
      order.save
    end
    redirect_to order.event, :alert => "Order was cancelled"
  end

  def create
    @event = Event.find(params[:event_id])
    @order = current_user.orders.new(order_params)
    @order.event = @event

    @order.credit_card = CreditCard.new(credit_card_params)
    raise @order.credit_card..inspect

    @order.return_url = event_order_execute_url(@event, :order_id => ':order_id')
    @order.cancel_url = event_order_cancel_url(@event, :order_id => ':order_id')
    if @order.payment_method and @order.save
      if @order.approve_url
        redirect_to @order.approve_url
      else
        redirect_to @event, :notice => "Order was placed successfully"
      end
    else
      render :create, :alert => @order.errors.to_a.join(", ")
    end
  end

  def execute
    order = current_user.orders.find(params[:order_id])
    if order.execute(params["PayerID"])
      redirect_to order.event, :notice => "Order was placed successfully"
    else
      redirect_to order.event, :alert => order.payment.error.inspect
    end
  end

  def index
    @orders = Event.find(params[:event_id]).orders.where(user: current_user).all(:limit => 10, :order => "id DESC")
  end

  # GET /events/new
  def new
    @event = Event.find(params[:event_id])
    @order = Order.new(event: @event)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  private
  def order_params
    params.require(:order).permit(:user_id, :event_id, :payment_method, :amount, :description, :credit_card)
  end

  def credit_card_params
    params.require(:order).require(:credit_card).permit(:type, :number, :expire_month, :expire_year, :cvv2)
  end
end
