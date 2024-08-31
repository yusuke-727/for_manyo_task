class User < ApplicationRecord
  has_secure_password

  has_many :tasks, dependent: :destroy
  before_save { self.email = email.downcase }
  before_validation :set_default_password_confirmation, if: -> { password.present? && password_confirmation.nil? }

  # バリデーション
  validates :name, presence: true
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true,
                       length: { minimum: 6 }
  validates :password_confirmation, presence: true,
                                    confirmation: true

  # コールバック
  before_destroy :ensure_admin_remains
  before_update :ensure_admin_remains_for_update

  # タスク数を返すメソッド
  def tasks_count
    tasks.count
  end
  
  private
  
  # パスワード確認がない場合、自動的に設定
  def set_default_password_confirmation
    self.password_confirmation = password
  end

  # 管理者が0人になることを防ぐ
  def ensure_admin_remains
    if self.admin? && User.where(admin: true).count == 1
      errors.add(:base, '管理者が0人になるため削除できません')
      throw(:abort)
    end
  end

  def ensure_admin_remains_for_update
    if self.admin_changed? && !self.admin && User.where(admin: true).count == 1
      errors.add(:base, '管理者が0人になるため権限を変更できません')
      throw(:abort)
    end
  end
end
