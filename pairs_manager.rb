class ImpossibleScenarioException < Exception
end 

class PairsManager

  attr :player_partners

  def initialize(players, courses)
    @players = players
    @courses = courses
    reset_pairs
  end

  def choose_pairs
    begin
      (1..@courses.length).each do |day_number|
        (0..(@players.length - 1)).each do |index|
          player = @players[index]
          choose_partner(day_number, index) unless player_taken?(day_number, player)
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
    player = @players[player_index]
    partner_found = false
    partner_index = 0
    attempted_indices = { player_index => true }
    until partner_found do
      partner_index = rand(@players.length)
      next if attempted_indices[partner_index]
      attempted_indices[partner_index] = true
      potential_partner = @players[partner_index]
      partner_found = true unless already_played_with?(player, potential_partner) || 
                                    player_taken?(day_number, potential_partner)
      raise ImpossibleScenarioException if exhausted_partners?(attempted_indices)
    end
    partner = @players[partner_index]
    @player_partners[player] << partner
    @player_partners[partner] << player
    @daily_pairs[day_number -  1] << "#{player} & #{partner}"
  end

  def already_played_with?(player, potential_partner)
    @player_partners[player].include? potential_partner
  end

  def player_taken?(day_number, player)
    @player_partners[player].length == day_number
  end

  def exhausted_partners?(indices)
    (0..(@players.length - 1)).each { |index| return false unless indices[index] }
  end

  def reset_pairs
    @player_partners = {}
    @players.each { |player| @player_partners[player] = [] }
    @daily_pairs = []
    (0..(@courses.length - 1)).each { |i| @daily_pairs[i] = [] }
  end

end