# frozen_string_literal: true

require 'gosu'
require 'pry'
require 'optparse'

Dir.glob('helpers/*.rb').each { |file| require_relative file }
Dir.glob('lib/*.rb').each { |file| require_relative file }

# Option parsing for command-line arguments
options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: play [options]'

  opts.on('-s', '--score SCORE', Integer, 'Set starting score') do |s|
    options[:score] = s
  end

  opts.on('-i', '--invincible', 'Invincible mode') do
    options[:invincible] = true
  end

  opts.on('-d', '--draft', 'Draft mode') do
    options[:draft] = true
  end

  opts.on('-m', '--mute', 'Mute sounds') do
    options[:mute] = true
  end

  opts.on('-h', '--help', 'Prints this help') do
    puts opts
    exit
  end
end.parse!

class JumpAdventure < Gosu::Window
  include Sound
  include Game

  attr_reader :font, :sprites, :sounds

  attr_accessor :speed,
    :frame,
    :ground,
    :ceiling,
    :game_over,
    :short_press,
    :start_score,
    :invincible,
    :draft,
    :muted

  def initialize(start_score: 0, invincible: false, draft: false, muted: false, width: 1450, height: 600, fullscreen: false)
    super(width, height, fullscreen: fullscreen)

    self.caption = "Link's Jump Adventure"
    self.start_score = start_score
    self.invincible = invincible
    self.draft = draft
    self.muted = muted

    load_assets
    init_game
  end

  def load_assets
    @font = Gosu::Font.new(30)

    @sprites = {}
    @sounds = {}

    # Load static images
    @sprites[:background] = Gosu::Image.new('assets/sprites/background.png')
    @sprites[:collision] = Gosu::Image.new('assets/sprites/collision.png')
    @sprites[:game_over] = Gosu::Image.new('assets/sprites/game_over.png')

    # Load tiled sprites
    # Link: 96x104
    @sprites[:link] = Gosu::Image.load_tiles(self, 'assets/sprites/link.png', 96, 104, true)

    # Octorok: 100x79
    @sprites[:octorok_red] = Gosu::Image.load_tiles(self, 'assets/sprites/octorok_red.png', 100, 79, true)
    @sprites[:octorok_blue] = Gosu::Image.load_tiles(self, 'assets/sprites/octorok_blue.png', 100, 79, true)
    @sprites[:octorok_yellow] = Gosu::Image.load_tiles(self, 'assets/sprites/octorok_yellow.png', 100, 79, true)

    # Keese: 76x72
    @sprites[:keese] = Gosu::Image.load_tiles(self, 'assets/sprites/keese.png', 76, 72, true)
    @sprites[:keese_white] = Gosu::Image.load_tiles(self, 'assets/sprites/keese_white.png', 76, 72, true)

    # Load sounds
    Dir.glob('assets/sounds/*.mp3').each do |file|
      name = File.basename(file, '.mp3')
      @sounds[name] = Gosu::Sample.new(file)
    end
  end
end

window = JumpAdventure.new(
  start_score: options[:score],
  invincible: options[:invincible],
  draft: options[:draft],
  muted: options[:mute],
)
window.show
