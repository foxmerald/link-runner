# frozen_string_literal: true

require_relative 'character'

# parent class for all monsters
class Monster < Character
  SLOWDOWN = 20

  def initialize(window)
    super

    @facing = :left
  end

  def update
    @x -= @window.speed
  end

  def off_screen?
    @x < -@width
  end

  def draw
    # @sprites.size
    f = (@window.frame / SLOWDOWN) % 4

    image = @sprites[f]

    image.draw(@x, @y, 1)
  end

  private

  def set_default_position(x_offset: 0, y_offset: 0)
    @x = @window.width + x_offset
    @y = @window.ground + y_offset
  end
end

# ground enemy
class Octorok < Monster
  def initialize(window, score = 0)
    super(window)

    @width = 100
    @height = 79

    color = case (score / 100) % 3
    when 0 then 'red'
    when 1 then 'blue'
    when 2 then 'yellow'
    end

    @sprites = Gosu::Image.load_tiles(
      @window, "assets/sprites/octorok_#{color}.png", @width, @height, true
    )

    set_default_position(y_offset: 20)
  end
end

# flying enemy
class Keese < Monster
  def initialize(window)
    super

    @width = 76
    @height = 72

    @sprites = Gosu::Image.load_tiles(
      @window, 'assets/sprites/keese.png', @width, @height, true
    )

    # 3 positions:
    # 1. High up (current) -> -150
    # 2. Middle (stacked on 1 Octorok) -> -60
    # 3. Ground (same top as Octorok) -> 20
    possible_offsets = [-150, -60, 20]
    set_default_position(y_offset: possible_offsets.sample)
  end
end

# stronger flying enemy
class WhiteKeese < Keese
  def initialize(window)
    super

    @sprites = Gosu::Image.load_tiles(
      @window, 'assets/sprites/keese_white.png', @width, @height, true
    )
  end

  def update
    @x -= @window.speed * 2
  end
end
