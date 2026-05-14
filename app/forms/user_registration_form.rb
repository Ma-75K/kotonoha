class UserRegistrationForm
  include ActiveModel::Model

  attr_reader :user

  def initialize(user_params:, children_params:)
    @user_params = user_params
    @children_params = children_params
    @user = User.new(@user_params)
    build_children
  end

  def save
    return false unless user.valid?

    user.save
  end

  private

  attr_reader :user_params, :children_params

  def build_children
    return if children_params.blank?

    children_params.each_value do |child_params|
      user.children.build(child_params)
    end
  end
end
