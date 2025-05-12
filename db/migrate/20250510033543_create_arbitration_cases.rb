class CreateArbitrationCases < ActiveRecord::Migration[8.0]
  def change
    create_table :arbitration_cases do |t|
      t.string :title
      t.string :user_ref_claimant
      t.string :user_ref_respondent
      t.integer :status
      t.jsonb :vote_options
      t.integer :quorum_size
      t.datetime :submission_deadline
      t.datetime :judgment_deadline
      t.boolean :public
      t.string :tags
      t.datetime :resolved_at
      t.datetime :archived_at

      t.timestamps
    end
  end
end
