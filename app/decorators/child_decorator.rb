class ChildDecorator < Draper::Decorator
  delegate_all

  def age_at(target_date)
    return nil if object.birthday.blank? || target_date.blank?

    birth_date = object.birthday.to_date
    target_date = target_date.to_date

    years = target_date.year - birth_date.year
    months = target_date.month - birth_date.month

    if target_date.day < birthd_date.day
      months -= 1
    end

    if months < 0
      years -= 1
      months += 12
    end

    return nil if years.negative?

    "#{years}歳#{months}か月"
  end

  def current_age
    age_at(Date.current)
  end
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
