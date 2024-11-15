# frozen_string_literal: true

require_relative '../lib/background'
require_relative '../lib/link'
require_relative '../lib/monster'

# This takes care of the basic game functionality
module Game
  BASE_SPEED = 4
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
    @octorok.update
    @keese.update
    @background.update

    # TODO: fix deprecation
    # "DEPRECATION WARNING: Passing a Window to Image.from_text has been deprecated in Gosu 0.9 and this method now uses an options hash, see https://www.libgosu.org/rdoc/Gosu/Image.html"
    @score = Gosu::Image.from_text(
      self, "Score: #{(@background.x / 50).abs}", Gosu.default_font_name, 30
    )

    increase_speed

    @game_over = true if collision?(@octorok)
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
    @octorok.draw
    @keese.draw
    @background.draw

    @score.draw(0, 0, 100)

    show_game_over if @game_over
  end

  private

  def collision?(monster)
    @link.front >= monster.front && @link.bottom >= monster.top
  end

  def show_game_over
    explosion
    game_over_text
    restart_options
  end

  def explosion
    explosion = Gosu::Image.new('assets/collision.png')
    explosion.draw(@link.x, @link.y, 100)
  end

  def game_over_text
    game_over_text = Gosu::Image.new('assets/game_over.png')
    x = width / 2 - game_over_text.width / 2
    y = height / 2 - game_over_text.height / 2
    game_over_text.draw(x, y, 100)
  end

  def restart_options
    # TODO: fix deprecation
    # "DEPRECATION WARNING: Passing a Window to Image.from_text has been deprecated in Gosu 0.9 and this method now uses an options hash, see https://www.libgosu.org/rdoc/Gosu/Image.html"
    restart_options = Gosu::Image.from_text(
      self, 'Press [P] to try again. Press [Esc] to exit.', Gosu.default_font_name, 30
    )
    x = width / 2 - restart_options.width / 2
    y = height - 35
    restart_options.draw(x, y, 100)
  end

  def restart_game
    @frame = 0
    @speed = 4

    @link.reset
    @octorok.reset
    @keese.reset

    @game_over = false
  end

  def increase_speed
    increased_speed = @frame / 750 + BASE_SPEED

    @speed = increased_speed
  end

  def init_game
    @frame = 0
    @speed = 4
    @ground = 440
    @ceiling = 50
    @game_over = false
    @space_down_frame = 0

    @link = Link.new(self)
    @octorok = Octorok.new(self)
    @keese = Keese.new(self)
    @background = Background.new(self)
  end
end
