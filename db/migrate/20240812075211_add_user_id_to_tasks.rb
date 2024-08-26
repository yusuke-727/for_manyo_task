class AddUserIdToTasks < ActiveRecord::Migration[6.1]
  def change
    # まず、user_idカラムをnullを許可して追加します
    add_reference :tasks, :user, foreign_key: true, null: true

    # 既存のタスクにデフォルトのユーザーIDを設定します（ID=1のユーザーを想定）
    # 必要に応じて、適切なユーザーIDに変更してください
    Task.update_all(user_id: User.first.id)

    # 最後にnullを許可しないように制約を追加します
    change_column_null :tasks, :user_id, false
  end
end
