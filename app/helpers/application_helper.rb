module ApplicationHelper
  def yes_no(boolean)
    boolean ? t('yes') : t('no')
  end
end
