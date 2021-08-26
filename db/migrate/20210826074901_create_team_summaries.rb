class CreateTeamSummaries < ActiveRecord::Migration[6.1]
  def change
    create_view :team_summaries
  end
end
