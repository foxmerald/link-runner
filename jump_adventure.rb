# frozen_string_literal: true

require 'gosu'
require 'pry'

require_relative 'helpers/game'

class JumpAdventure < Gosu::Window
  include Game

  attr_accessor :speed, :frame, :ground, :ceiling, :game_over, :short_press

  def initialize(width = 1200, height = 600, fullscreen: false)
    super

    self.caption = "Link's Jump Adventure"

    init_game
  end
end

window = JumpAdventure.new
window.show
