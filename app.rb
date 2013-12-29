#gosu file
require 'bundler'
Bundler.require

require 'gosu'
Dir.glob('./lib/*.rb') do |model|
  require_relative model
end

class GameOfLifeWindow < Gosu::Window

	def initialize(height=1800, width=1600)
		@height = height
		@width = width
		super height, width, false
		self.caption = "Gosu Tutorial Game"

		#color
		@background_color = Gosu::Color.new(0xffdedede)
		@alive_color = Gosu::Color.new(0xff00ffff)
		@dead_color = Gosu::Color.new(0xffff00ff)

		#game itself
		@cols = width/10
		@rows = height/10

		@col_width = width/@cols #width div by number of cols
		@row_height = height/@rows #height div by number of rows

		@world = World.new(@cols, @rows)
		@game = Game.new(@world)
		@game.world.randomly_populate
	end

	def update
		@game.tick!
	end

	def draw
		draw_quad(0, 0, @background_color, #top left corner of scree
							width, 0, @background_color, #top right corner 
							width, height, @background_color, #bottom right
							0, height, @background_color) #bottom left

		@game.world.cells.each do |cell|
			if cell.alive?
				draw_quad(cell.x * @col_width, cell.y * @row_height, @alive_color,
									cell.x * @col_width + @col_width, cell.y * @row_height, @alive_color,
									cell.x * @col_width + @col_width, cell.y * @row_height + @row_height, @alive_color,
									cell.x * @col_width, cell.y * @row_height + @row_height, @alive_color)
			else
				draw_quad(cell.x * @col_width, cell.y * @row_height, @dead_color,
									cell.x * @col_width + @col_width, cell.y * @row_height, @dead_color,
									cell.x * @col_width + @col_width, cell.y * @row_height + @row_height, @dead_color,
									cell.x * @col_width, cell.y * @row_height + @row_height, @dead_color)
			end
		end

	end

	def needs_cursor?; true; end

 end

GameOfLifeWindow.new.show