class RiddlesController < ApplicationController
	# better way than to query the database twice?
  def show
    @riddle ||= Riddle.find(rand(1..Riddle.count))
  end

  def create
    @riddle = Riddle.new(riddle_params)
    if @riddle.save!
      redirect_to @riddle
    else
      # This line overrides the default rendering behavior, which
      # would have been to render the "create" view.
      render "new"
    end
  end

  def new
    @riddle = Riddle.new
  end

  def guess
    guess = guess_params[:guess]
    puts guess * 50
    @riddle = Riddle.find(guess_params[:riddle_id])
    success if guess == @riddle.answer else guess_again
    render :show
  end

  def success
    puts "Great success!" * 50
    @riddle = Riddle.find(rand(1..Riddle.count))
    flash.now[:notice] = "That's correct! I knew you could do it!"

  end

  def guess_again
    flash.now[:notice] = "Wrong answer #{ email_without_domain }!"
  end


  private
    def riddle_params
      params.require(:riddle).permit(:riddle_after_guess, :question, :answer, :upvotes, :guess)
    end

    def guess_params
      params.permit(:riddle_id, :guess)
    end

    def email_without_domain
      current_user.email.split('@')[0]
    end


end

