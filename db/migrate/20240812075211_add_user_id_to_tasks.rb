class AddUserIdToTasks < ActiveRecord::Migration[6.1]
  def change
    # まず、user_idカラムをnullを許可して追加します
    add_reference :tasks, :user, foreign_key: true, null: true

    # 既存のタスクにデフォルトのユーザーIDを設定します（ID=1のユーザーを想定）
    # Userが存在する場合にのみIDを設定する
    # マイグレーションファイルで使えるメソッドのみに変更
    reversible do |dir|
    dir.up do
      if User.exists?
        default_user_id = User.first.id
        Task.update_all(user_id: default_user_id)
      end
    end
  end

    # 最後にnullを許可しないように制約を追加します
    change_column_null :tasks, :user_id, false
  end
end
