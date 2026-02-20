# frozen_string_literal: true

require 'gosu'
require 'pry'

Dir.glob('helpers/*.rb').each { |file| require_relative file }
Dir.glob('lib/*.rb').each { |file| require_relative file }

class JumpAdventure < Gosu::Window
  include Game

  attr_accessor :speed, :frame, :ground, :ceiling, :game_over, :short_press

  def initialize(width = 1450, height = 600, fullscreen: false)
    super

    self.caption = "Link's Jump Adventure"

    init_game
  end
end

window = JumpAdventure.new
window.show
