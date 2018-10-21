class Redesign::SagasController < ApplicationController
  include LoadableForSaga
  layout 'redesign'

  def show
    load_saga
  end
end
