module LoadableForQuiz
  extend ActiveSupport::Concern

  private

  def load_quiz
    @quiz = Quiz.find_by url: params[:id]
    authorize @quiz
  end

  def load_contributors_quizzes
    @contributor_profile = ContributorProfile.find_by(
      url: params[:contributor_profile_id]
    )
    raise 'Contributor profile not found.' unless @contributor_profile
    @quizzes = policy_scope(
      Quiz.joins(:contributions).where(
        contributions: { contributor_profile_id: @contributor_profile.id }
      ).order(:name).page(params[:page])
    )
  end

  def load_draft_quizzes
    @quizzes = policy_scope(
      Quiz.where(publish: false).order(:name).page(params[:page])
    )
  end
end
