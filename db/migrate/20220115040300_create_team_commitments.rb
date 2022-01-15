class CreateTeamCommitments < ActiveRecord::Migration[6.1]
  def change
    create_table :team_commitments do |t|
      t.references :team, null: false, foreign_key: true
      t.references :commitment, null: false, foreign_key: true
      t.timestamps
    end
  end
end
