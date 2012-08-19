class Player

  attr :name

  def initialize(name)
    @name = name
    @partner_names = []
  end

  def available?(partner, day_number)
    !taken_for_day?(day_number) &&
      !already_played_with?(partner)
  end

  def taken_for_day?(day_number)
    @partner_names.length == day_number
  end

  def add_partner(player)
    @partner_names << player.name
  end

  private

  def already_played_with?(player)
    @partner_names.include? player.name
  end

end