#spec file

require 'rspec'

Dir.glob('./lib/*.rb') do |model|
  require_relative model
end

describe 'Game of life' do

  let!(:world) { World.new }
  let!(:cell) { Cell.new(1,1) }

  context 'World' do
    subject { World.new }
    
    it 'should create a new world subject' do
      subject.is_a?(World).should be_true
    end

    it 'should respond to proper methods' do 
      subject.should respond_to(:rows)
      subject.should respond_to(:cols)
      subject.should respond_to(:cell_grid)
      subject.should respond_to(:live_neighbors_around_cell)
      subject.should respond_to(:cells)
      subject.should respond_to(:live_cells)
      subject.should respond_to(:randomly_populate)
    end

    it 'should create proper cell grid upon initialization' do
      subject.cell_grid.is_a?(Array).should be_true
      subject.cell_grid.each do |row| 
        row.is_a?(Array).should be_true
        row.each do |col| 
          col.is_a?(Cell).should be_true
        end
      end
    end

    it 'should detect a neighbor to the north' do
      subject.cell_grid[0][1].should be_dead
      subject.cell_grid[0][1].alive = true
      subject.cell_grid[0][1].should be_alive
      subject.live_neighbors_around_cell(cell).count.should eq(1)
    end

    it 'should detect a neighbor to the northeast' do
      subject.cell_grid[0][2].should be_dead
      subject.cell_grid[0][2].alive = true
      subject.cell_grid[0][2].should be_alive
      subject.live_neighbors_around_cell(cell).count.should eq(1)
    end

    it 'should detect a neighbor to the east' do
      subject.cell_grid[1][2].should be_dead
      subject.cell_grid[1][2].alive = true
      subject.cell_grid[1][2].should be_alive
      subject.live_neighbors_around_cell(cell).count.should eq(1)
    end

    it 'should detect a neighbor to the southeast' do
      subject.cell_grid[2][2].should be_dead
      subject.cell_grid[2][2].alive = true
      subject.cell_grid[2][2].should be_alive
      subject.live_neighbors_around_cell(cell).count.should eq(1)
    end

    it 'should detect a neighbor to the south' do
      subject.cell_grid[2][1].should be_dead
      subject.cell_grid[2][1].alive = true
      subject.cell_grid[2][1].should be_alive
      subject.live_neighbors_around_cell(cell).count.should eq(1)
    end

    it 'should detect a neighbor to the southwest' do
      subject.cell_grid[2][0].should be_dead
      subject.cell_grid[2][0].alive = true
      subject.cell_grid[2][0].should be_alive
      subject.live_neighbors_around_cell(cell).count.should eq(1)
    end

    it 'should detect a neighbor to the west' do
      subject.cell_grid[1][0].should be_dead
      subject.cell_grid[1][0].alive = true
      subject.cell_grid[1][0].should be_alive
      subject.live_neighbors_around_cell(cell).count.should eq(1)
    end

    it 'should detect a neighbor to the northwest' do
      subject.cell_grid[0][0].should be_dead
      subject.cell_grid[0][0].alive = true
      subject.cell_grid[0][0].should be_alive
      subject.live_neighbors_around_cell(cell).count.should eq(1)
    end

    it 'should count the number of live cells' do
      subject.live_cells.size.should eq(0)
    end

    it 'should randomly populate the world' do
      subject.live_cells.size.should eq(0)
      subject.randomly_populate
      subject.live_cells.size.should_not eq(0)
    end

  end

  context 'Cell' do
    subject { Cell.new }

    it 'should create a new cell subject' do
      subject.is_a?(Cell).should be_true
    end

    it 'should respond to proper methods' do
      subject.should respond_to(:alive)
      subject.should respond_to(:x)
      subject.should respond_to(:y)
      subject.should respond_to(:alive?)
      subject.should respond_to(:die!)
    end

    it 'should initialize properly' do
      subject.alive.should be_false
      subject.x.should eq(0)
      subject.y.should eq(0)
    end

  end

  context 'Game' do

    subject { Game.new }

    it 'should create a new game subject' do
      subject.is_a?(Game).should be_true
    end

    it 'should respond to proper methods' do
      subject.should respond_to(:world)
      subject.should respond_to(:seeds)
    end

    it 'should initialize properly' do
      subject.world.is_a?(World).should be_true
      subject.seeds.is_a?(Array).should be_true
    end

    it 'should seed properly' do
      game = Game.new(world, [[1, 2], [0,2]])
      world.cell_grid[1][2].alive?.should be_true
    end

  end

  context 'Rules' do

    let!(:game) { Game.new }
    let!(:cell) { Cell.new(1,1) }
    
    context 'Rule 1: Any live cell with fewer than two live neighbors dies, as if caused by under-population.' do

      it 'should kill a live cell with 0 live neighbors' do
        game.world.cell_grid[1][1].alive = true
        game.world.cell_grid[1][1].alive.should be_true
        game.tick!
        world.cell_grid[1][1].should be_dead
      end
      
      it 'should kill a live cell with 1 live neighbor' do
        game = Game.new(world, [[0,1], [1,1]])
        world.live_neighbors_around_cell(cell).count.should eq(1)
        game.tick!
        world.cell_grid[0][1].should be_dead
        world.cell_grid[1][1].should be_dead
      end

      it 'doesnt kill a live cell with 2 live neighbors' do
        game = Game.new(world, [[0,1], [1,1], [2,1]])
        world.live_neighbors_around_cell(cell).count.should eq(2)
        game.tick!
        world.cell_grid[1][1].should be_alive
      end

    end

    context 'Rule 2: Any live cell with two or three live neighbours lives on to the next generation.' do
      
      it 'should let a live cell with 2 neighbors live' do
        game = Game.new(world, [[0,1], [1,1], [2,1]])
        world.live_neighbors_around_cell(cell).count.should eq(2)
        game.tick!
        world.cell_grid[0][1].should be_dead
        world.cell_grid[1][1].should be_alive
        world.cell_grid[2][1].should be_dead
      end

      it 'should let a live cell with 2 or 3 neighbors live' do
        game = Game.new(world, [[0,1], [1,1], [2,1], [2,2]])
        world.live_neighbors_around_cell(cell).count.should eq(3)
        game.tick!
        world.cell_grid[0][1].should be_dead
        world.cell_grid[1][1].should be_alive
        world.cell_grid[2][1].should be_alive
        world.cell_grid[2][2].should be_alive
      end

    end

    context 'Rule 3: Any live cell with more than three live neighbours dies, as if by overcrowding.' do

      it 'should kill a live cell with more than 3 neighbors' do
        game = Game.new(world, [[0,1], [1,1], [2,1], [1,2], [2,2]])
        world.live_neighbors_around_cell(cell).count.should eq(4)
        game.tick!
        world.cell_grid[0][1].should be_alive
        world.cell_grid[1][1].should be_dead
        world.cell_grid[2][1].should be_alive
        world.cell_grid[1][2].should be_dead
        world.cell_grid[2][2].should be_alive
      end
    end

    context 'Rule 4: Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction' do
      it 'should reanimate any dead cell with exactly three live neighbors' do
        game = Game.new(world, [[1,1], [2,1], [1,2], [2,2]])
        game.world.cell_grid[1][1].alive = false
        world.live_neighbors_around_cell(cell).count.should eq(3)
        game.tick!
        world.cell_grid[1][1].should be_alive
        world.cell_grid[2][1].should be_alive
        world.cell_grid[1][2].should be_alive
        world.cell_grid[2][2].should be_alive
      end
    end
  end

end




