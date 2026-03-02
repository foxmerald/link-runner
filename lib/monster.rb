# frozen_string_literal: true

# Parent class for all monsters
class Monster < Character
  SLOWDOWN = 20
  KEESE_Y_OFFSETS = [-150, -60, 20]

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
    if @window.draft
      Gosu.draw_rect(@x, @y, @width, @height, Gosu::Color::RED, 1)
      return
    end

    # Pick the correct sprite based on the current frame and monster type
    frame = (@window.frame / SLOWDOWN) % @sprites.size
    image = @sprites[frame]

    image.draw(@x, @y, 1)
  end

  private

  def set_default_position(x_offset: 0, y_offset: 0)
    @x = @window.width + x_offset
    @y = @window.ground + y_offset
  end
end

# Ground enemy
class Octorok < Monster
  def initialize(window, score = 0)
    super(window)

    @width = 100
    @height = 79

    color = case (score.to_i / 100) % 3
    when 0 then :octorok_red
    when 1 then :octorok_blue
    when 2 then :octorok_yellow
    end

    @sprites = @window.sprites[color]

    set_default_position(y_offset: 20)
  end
end

# Flying enemy
class Keese < Monster
  def initialize(window)
    super

    @width = 76
    @height = 72

    @sprites = @window.sprites[:keese]

    set_default_position(y_offset: KEESE_Y_OFFSETS.sample)
  end
end

# Stronger flying enemy
class WhiteKeese < Keese
  def initialize(window)
    super

    @sprites = @window.sprites[:keese_white]
  end

  def update
    @x -= @window.speed * 2
  end
end
