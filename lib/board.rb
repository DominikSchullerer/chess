require_relative "./string"
require_relative "./rules_gamestate"

class Board
  def new_game
    create_board
    parse_FEN_string(RulesGamestate::START_FEN)
  end

  def create_board
    @squares = []
    8.times { @squares << [] }
    @squares.each do |rank|
      8.times { rank << nil }
    end
  end

  def parse_FEN_string(fen_string)
    fen_array = fen_string.split(/\s|\//)
    8.times.each do |rank|
      file = 0
      fen_array[7 - rank].chars do |char|
        case char
        when /^[KQRBNPkqrbnp]$/
          @squares[rank][file] = char
          file += 1
        when /^\d$/
          char.to_i.times do
            @squares[rank][file] = nil
            file += 1
          end
        end
      end
    end

    @active_color = fen_array[8]

    @castling_availability = fen_array[9]
    @en_passant_availability = fen_array[10]

    @half_turn_without_advance = fen_array[11]
    @turn = fen_array[12]
  end

  def FEN_string
    fen_array = []

    fen_array << position_string
    fen_array << @active_color
    fen_array << @castling_availability
    fen_array << @en_passant_availability
    fen_array << @half_turn_without_advance
    fen_array << @turn

    fen_array.join(" ")
  end

  def position_string
    position_array = Array.new(8)
    8.times.each do |rank|
      rank_array = []
      empty_count = 0
      8.times.each do |file|
        if @squares[rank][file].nil?
          empty_count += 1
        else
          rank_array << empty_count.to_s if empty_count > 0
          empty_count = 0
          rank_array << @squares[rank][file]
        end
      end
      rank_array << empty_count.to_s if empty_count > 0
      position_array[7 - rank] = rank_array.join
    end
    position_array.join("/")
  end

  def draw_board
    7.downto(0).each do |rank|
      row_string = ""
      8.times.each do |file|
        row_string += square_string(rank, file)
      end
      puts row_string
    end
  end

  def square_string(rank, file)
    square_string = case @squares[rank][file]
    when nil
      "   "
    when "K"
      " \u2654 "
    when "Q"
      " \u2655 "
    when "R"
      " \u2656 "
    when "B"
      " \u2657 "
    when "N"
      " \u2658 "
    when "P"
      " \u2659 "
    when "k"
      " \u265A "
    when "q"
      " \u265B "
    when "r"
      " \u265C "
    when "b"
      " \u265D "
    when "n"
      " \u265E "
    when "p"
      " \u265F "
    end

    if (rank + file) % 2 == 0
      square_string.bg_black
    else
      square_string.bg_white
    end
  end
end

board = Board.new
board.new_game
board.draw_board
p board.FEN_string
