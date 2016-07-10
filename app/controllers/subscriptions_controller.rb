class SubscriptionsController < ApplicationController
  before_action :load_question, only: [:create, :destroy]
  before_action :load_subscription, only: [:destroy]

  respond_to :js

  def create
    respond_with(@subscription = @question.subscriptions.create(user: current_user))
  end

  def destroy
    respond_with(@subscription.destroy_all)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_subscription
    @subscription = Subscription.where(question_id: @question.id, user_id: current_user.id)
  end
end
