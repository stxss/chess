require "date"
require "json"

module Serialize
  def serialize
    fen_string = piece_placement + active_color + castling_rights + en_passant_targets + half_moves + full_moves

    player_info = "#{@board.player1.name} #{@board.player1.score}\n#{@board.player2.name} #{@board.player2.score}"
    movement = @board.translated_jumps.to_json

    castles = "#{@board.castles_white} #{@board.castles_black}"

    "#{fen_string}\n#{player_info}\n#{castles}\n#{movement}"
  end

  def piece_placement
    result = ""
    @board.grid.each_with_index do |i, row_index|
      empty_count = 0
      i.each_with_index do |piece, column_index|
        if piece.painted == "   "
          empty_count += 1
          next
        end

        result << empty_count.to_s unless empty_count.zero?
        empty_count = 0
        result << piece.fen_notation.to_s
      end
      result << empty_count.to_s unless empty_count.zero?
      result << "/" unless row_index == 7
    end
    result
  end

  def active_color
    @board.turn.even? ? " w" : " b"
  end

  def castling_rights
    rights = @board.castle_handler(purpose: :fen)

    return " -" if rights.all?(false)

    output = " "
    output << "K" if rights[0] && @board.castles_white < 1
    output << "Q" if rights[1] && @board.castles_white < 1
    output << "k" if rights[2] && @board.castles_black < 1
    output << "q" if rights[3] && @board.castles_black < 1

    output
  end

  def en_passant_targets
    output = " "
    @board.grid.each_with_index do |i, row_index|
      i.each_with_index do |piece, column_index|
        if piece.ep_flag == true
          if piece.color == :white
            output << NAMED_SQUARES[[row_index + 1, column_index]].to_s
          elsif piece.color == :black
            output << NAMED_SQUARES[[row_index - 1, column_index]].to_s
          else
            next
          end
        end
      end
    end
    output = " -" if output == " "
    output
  end

  def half_moves
    " " + @board.half_counter.to_s
  end

  def full_moves
    " " + @board.full_counter.to_s
  end

  def save_file(filename)
    Dir.mkdir("saved") unless Dir.exist?("saved")

    File.open("saved/#{filename}", "w") { |fen| fen.puts serialize }
  end

  def create_filename
    user_filename = nil
    puts "\nEnter the name of how you want to save the file or press the 'Enter' key for a random filename generation"

    loop do
      user_filename = gets.chomp.downcase
      if /^[a-zA-Z0-9 _]+$/.match?(user_filename) || user_filename == ""
        if File.file?("saved/#{user_filename}")
          puts "\nA file with that name already exists. Please enter another name:"
          next
        end
        break
      end
    end

    if user_filename == ""
      d = DateTime.now
      date = d.strftime("%d_%m_%Y__%H:%M")
      user_filename = "#{@board.player1.name} - #{@board.player1.score} vs #{@board.player2.score} - #{@board.player2.name} at #{date}"
    end
    user_filename
  end
end
