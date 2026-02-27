# frozen_string_literal: true

require 'gosu'
require 'pry'
require 'optparse'

# Option parsing for command-line arguments
options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: play [options]'

  opts.on('-s', '--score SCORE', Integer, 'Starting score') do |s|
    options[:score] = s
  end

  opts.on('-i', '--invincible', 'Invincible mode') do
    options[:invincible] = true
  end

  opts.on('-h', '--help', 'Prints this help') do
    puts opts
    exit
  end
end.parse!

Dir.glob('helpers/*.rb').each { |file| require_relative file }
Dir.glob('lib/*.rb').each { |file| require_relative file }

class JumpAdventure < Gosu::Window
  include Sound
  include Game

  attr_accessor :speed,
    :frame,
    :ground,
    :ceiling,
    :game_over,
    :short_press,
    :start_score,
    :invincible

  def initialize(start_score: 0, invincible: false, width: 1450, height: 600, fullscreen: false)
    super(width, height, fullscreen: fullscreen)

    self.caption = "Link's Jump Adventure"
    self.start_score = start_score
    self.invincible = invincible

    init_game
  end
end

window = JumpAdventure.new(start_score: options[:score], invincible: options[:invincible])
window.show
