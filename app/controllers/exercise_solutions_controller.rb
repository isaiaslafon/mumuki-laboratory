class ExerciseSolutionsController < AjaxController
  include Mumuki::Laboratory::Controllers::NestedInExercise
  include Mumuki::Laboratory::Controllers::ResultsRendering
  include Mumuki::Laboratory::Controllers::ExerciseSeed

  before_action :set_messages, only: :create
  before_action :validate_accessible!, only: :create

  def create
    assignment = @exercise.try_submit_solution!(current_user, solution_params)
    render_results_json assignment, status: assignment.visible_status
  end

  private

  def accessible_subject
    @exercise.navigable_parent
  end

  def set_messages
    @messages = @exercise.messages_for(current_user)
  end

  def solution_params
    {
      content: params.require(:solution).permit!.to_h[:content],
      client_result: params[:client_result].try { |it| it.permit(:status, test_results: [:title, :status, :result, :summary]).to_h }
    }
  end
end
