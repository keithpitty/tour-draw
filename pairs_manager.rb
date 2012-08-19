class ImpossibleScenarioException < Exception
end 

require_relative 'player'

class PairsManager

  attr :player_partners

  def initialize(players, courses)
    @player_names = players
    @courses = courses
    reset_pairs
  end

  def choose_pairs
    begin
      (1..@courses.length).each do |day_number|
        (0..(@player_names.length - 1)).each do |index|
          player = @players[@player_names[index]]
          choose_partner(day_number, index) unless player.taken_for_day?(day_number)
        end
        @daily_pairs[day_number - 1].shuffle!
      end
    rescue ImpossibleScenarioException
      reset_pairs
      choose_pairs
    end
  end

  def report_pairs
    (0..(@courses.length - 1)).each_with_index do | index |
      puts "Pairs for #{@courses[index]}: #{@daily_pairs[index].join(', ')}."
    end
  end

  private

  def choose_partner(day_number, player_index)
    player = @players[@player_names[player_index]]
    partner_found = false
    attempted_indices = { player_index => true }
    until partner_found do
      partner_index = rand(@player_names.length)
      next if attempted_indices[partner_index]
      attempted_indices[partner_index] = true
      potential_partner = @players[@player_names[partner_index]]
      partner_found = true if potential_partner.available?(player, day_number)
      raise ImpossibleScenarioException if exhausted_partners?(attempted_indices) && !partner_found
    end
    partner = @players[@player_names[partner_index]]
    player.add_partner(partner)
    partner.add_partner(player)
    @daily_pairs[day_number -  1] << "#{player.name} & #{partner.name}"
  end

  def exhausted_partners?(indices)
    (0..(@player_names.length - 1)).each { |index| return false unless indices[index] }
  end

  def reset_pairs
    @players = {}
    @player_names.each { |name| @players[name] = Player.new(name) }
    @daily_pairs = []
    (0..(@courses.length - 1)).each { |i| @daily_pairs[i] = [] }
  end

end