class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
    @nears = Event.near(current_user) if user_signed_in?
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @comment = Comment.new
  end

  # GET /events/new
  def new
    if user_signed_in?
      authorize! :create, Event
      @event = Event.new
    else
      flash[:alert] = 'You must be signed in to create an event.'
      redirect_to new_user_session_path
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    #@user = @event.users.new
  end

  # POST /events
  # POST /events.json
  def create
    authorize! :create, Event
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to "/events/#{@event.id}/edit", notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_volunteer
    user = User.new({:first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :email => params[:user][:email]})
    user.skip_confirmation!
    user.save!

    Event.new(event_params).users << user
  end


  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  def add_user
    @event = Event.find(params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :deadline, :description, :website, :properties, :zipcode)
    end
end
