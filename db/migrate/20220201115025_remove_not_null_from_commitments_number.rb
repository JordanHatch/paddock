class RemoveNotNullFromCommitmentsNumber < ActiveRecord::Migration[7.0]
  def change
    change_column_null :commitments, :number, true
  end
end
