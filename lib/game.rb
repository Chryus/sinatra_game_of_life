Dir.glob('/*.rb') do |model|
  require_relative model
end

class Game

	attr_accessor :world, :seeds

	def initialize(world=World.new, seeds=[])
		@world = world
		@seeds = seeds

		seeds.each do |seed|
			world.cell_grid[seed[0]][seed[1]].alive = true
		end

	end

	def tick!
		next_round_live_cells = []
		next_round_dead_cells = []
		world.cells.each do |cell|
			#rule 1
			if cell.alive? && world.live_neighbors_around_cell(cell).count < 2
				next_round_dead_cells << cell
			end
			#rule 2
			if cell.alive? && world.live_neighbors_around_cell(cell).count.between?(2,3)
				next_round_live_cells << cell 
			end
			#rule 3
			if cell.alive? && world.live_neighbors_around_cell(cell).count > 3
				next_round_dead_cells << cell
			end
			#rule 4
			if cell.dead? && world.live_neighbors_around_cell(cell).count == 3
				next_round_live_cells << cell 
			end
		end
		next_round_live_cells.collect {|cell| cell.revive!}
		next_round_dead_cells.collect {|cell| cell.die!}	
	end

end
