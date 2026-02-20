# frozen_string_literal: true

require_relative '../lib/background'
require_relative '../lib/link'
require_relative '../lib/monster'

# This takes care of the basic game functionality
module Game
  BASE_SPEED = 0
  MAX_SPEED = 10
  SHORT_PRESS_FRAME = 15

  # Keyboard
  SPACE_KEY = Gosu::KbSpace
  ESC_KEY = Gosu::KbEscape
  P_KEY = Gosu::KbP

  # Gosu specific methods
  def update
    return if @game_over

    @frame += 1

    @link.update
    @background.update

    spawn_obstacle

    @obstacles.each do |obstacle|
      obstacle.update
      @game_over = true if collision?(obstacle)
    end

    @obstacles.delete_if(&:off_screen?)

    @score = Gosu::Image.from_text("Score: #{(@background.x / 10).abs.to_i}", 30)

    increase_speed
  end

  def button_down(id)
    close if id == ESC_KEY

    @space_down_frame = @frame if id == SPACE_KEY
  end

  def button_up(id)
    # pressing "P" restarts the game on game over
    return unless id == P_KEY && @game_over

    restart_game
  end

  def draw
    @link.draw
    @obstacles.each(&:draw)
    @background.draw

    @score.draw(0, 0, 100)

    show_game_over if @game_over
  end

  private

  def spawn_obstacle
    # If there are no obstacles, or the last one is far enough to the left
    if @obstacles.empty? || (@obstacles.last.x < width - @next_spawn)
      # Randomly choose between Octorok (ground) and Keese (air)
      # Weight it towards Octorok (95%)
      new_obstacle = if rand < 0.95
        Octorok.new(self)
      else
        Keese.new(self)
      end

      @obstacles << new_obstacle

      # Calculate when the next spawn should happen
      # Minimum gap plus a random variation
      # As speed increases, the minimum gap should increase slightly to be fair
      min_gap = 400 + (@speed * 10)
      @next_spawn = rand(min_gap..min_gap + 400)
    end
  end

  # Checks if link's bounding box overlaps enemy's
  def collision?(enemy)
    # link is to the right of enemy
    return false if @link.left > enemy.right

    # link is to the left of enemy
    return false if @link.right < enemy.left

    # link is below enemy
    return false if @link.top > enemy.bottom

    # link is above enemy
    return false if @link.bottom < enemy.top

    # If none of the above are true, they must be colliding
    true
  end

  def show_game_over
    draw_explosion
    @punch_sound.play

    game_over_text
    restart_options
  end

  def draw_explosion
    explosion = Gosu::Image.new('assets/sprites/collision.png')
    explosion.draw(@link.x, @link.y, 100)
  end

  def game_over_text
    game_over_text = Gosu::Image.new('assets/sprites/game_over.png')
    x = (width / 2) - (game_over_text.width / 2)
    y = (height / 2) - (game_over_text.height / 2)
    game_over_text.draw(x, y, 100)
  end

  def restart_options
    restart_options = Gosu::Image.from_text('Press [P] to try again. Press [Esc] to exit.', 30)
    x = (width / 2) - (restart_options.width / 2)
    y = height - 35
    restart_options.draw(x, y, 100)
  end

  def restart_game
    @frame = 0
    @speed = 4

    @link.reset
    @obstacles = []
    @next_spawn = 0

    @game_over = false
  end

  def increase_speed
    return if @speed >= MAX_SPEED

    increased_speed = (@frame / 1000) + 3

    @speed = [increased_speed, MAX_SPEED].min
  end

  def init_game
    @frame = 0
    @speed = 3
    @ground = 440
    @ceiling = 50
    @game_over = false
    @space_down_frame = 0

    # Moving objects
    @link = Link.new(self)
    @obstacles = []
    @next_spawn = 0
    @background = Background.new(self)

    # Sounds
    @punch_sound = Gosu::Sample.new('assets/sounds/punch.mp3')
  end
end
