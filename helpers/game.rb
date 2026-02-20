# frozen_string_literal: true

module Game
  BASE_SPEED = 0
  MAX_SPEED = 10
  SHORT_PRESS_FRAME = 15

  # Keyboard
  SPACE_KEY = Gosu::KbSpace
  ESC_KEY = Gosu::KbEscape
  P_KEY = Gosu::KbP

  CLUSTER_CHANCE = 0.20
  CLUSTER_CONTINUE_CHANCE = 0.70
  TIGHT_GAP_RANGE = 30..50
  WHITE_KEESE_SPAWN_INTERVAL = 150

  # Main game loop - update positions, check for collisions, spawn new obstacles and increase speed
  def update
    return if @game_over

    @frame += 1

    @link.update
    @background.update

    spawn_check
    spawn_white_keese_check

    @obstacles.each do |obstacle|
      obstacle.update
      @game_over = true if collision?(obstacle)
    end

    @obstacles.delete_if(&:off_screen?)

    @current_score = (@background.x / 10).abs.to_i

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

  # Draw everything on the screen
  def draw
    @link.draw
    @obstacles.each(&:draw)
    @background.draw

    score = Gosu::Image.from_text("Score: #{@current_score}", 30)
    score.draw(0, 0, 100)

    show_game_over if @game_over
  end

  private

  def spawn_white_keese_check
    @score_val = @current_score || 0
    return if @score_val < 400

    # Initialize last spawn score if it doesn't exist
    @last_white_keese_score ||= 400

    # Check if enough score has passed since the last spawn
    if @score_val - @last_white_keese_score >= WHITE_KEESE_SPAWN_INTERVAL
      # Calculate a random variance for the next spawn interval (e.g., +/- 50 points)
      variance = rand(-20..20)

      play_sound('white_keese')

      @obstacles << WhiteKeese.new(self)
      @last_white_keese_score = @score_val + variance
    end
  end

  # Check if it's time to spawn a new obstacle and whether it should be part of a monster-cluster
  def spawn_check
    # If there are no obstacles, or the last one is far enough to the left
    return unless @obstacles.empty? || (@obstacles.last.x < width - @next_spawn)

    @obstacles << new_obstacle
    @score_val = @current_score || 0

    if should_continue_cluster?
      handle_cluster_continuation
    elsif should_start_cluster?
      start_new_cluster
    else
      handle_normal_spawn
    end
  end

  def max_cluster_size
    # 1 extra obstacle per 200 points, capped at 5
    [(@score_val / 200).to_i + 1, 5].min
  end

  # We only want to continue adding tight gaps if count < (max_cluster - 1).
  def should_continue_cluster?
    @cluster_count > 0 && @cluster_count < (max_cluster_size - 1)
  end

  def should_start_cluster?
    @cluster_count == 0 && max_cluster_size > 1 && rand < CLUSTER_CHANCE
  end

  def handle_cluster_continuation
    # Chance to stop cluster early so we don't always hit max size
    if rand < CLUSTER_CONTINUE_CHANCE
      spawn_tight_gap
      @cluster_count += 1
    else
      # End the cluster early
      @cluster_count = 0
      @next_spawn = calculate_normal_gap + rand(0..300)
    end
  end

  def start_new_cluster
    spawn_tight_gap
    @cluster_count = 1 # We just spawned item #1 of a cluster
  end

  def spawn_tight_gap
    @next_spawn = rand(TIGHT_GAP_RANGE)
  end

  def handle_normal_spawn
    @cluster_count = 0

    gap = calculate_normal_gap

    # Add variance for unpredictability
    variance = rand(0..300) + rand(0..(@speed * 20))

    # 1 in 5 chance of a "long gap" given variance
    variance += (@speed * rand(100..150)) if rand < 0.2

    @next_spawn = gap + variance
  end

  def calculate_normal_gap
    # Base safe gap based on speed
    safe_gap = 300 + (@speed * 15)

    # Difficulty scaling
    if @score_val > 400
      safe_gap * 0.8
    elsif @score_val > 200
      safe_gap * 0.9
    else
      safe_gap
    end
  end

  # Randomly choose between Octorok (ground) and Keese (air)
  # Weight towards Octorok (90%)
  def new_obstacle
    return Octorok.new(self, @current_score || 0) if @current_score.to_i < 200

    if rand < 0.90
      Octorok.new(self, @current_score || 0)
    else
      Keese.new(self)
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
    draw_collision
    play_sound('game_over3', once: true)
    game_over_text

    restart_options
  end

  def play_sound(name, once: false)
    return if @played_sounds[name]

    @sounds[name] ||= Gosu::Sample.new("assets/sounds/#{name}.mp3")
    @sounds[name].play

    @played_sounds[name] = true if once
  end

  def increase_speed
    return if @speed >= MAX_SPEED

    increased_speed = (@frame / 1000) + 3

    @speed = [increased_speed, MAX_SPEED].min
  end

  def draw_collision
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

  def reset_values
    @frame = 0
    @speed = 3

    @sounds = {}
    @played_sounds = {}

    @obstacles = []
    @cluster_count = 0
    @next_spawn = 0
    @last_white_keese_score = 400

    @game_over = false
  end

  def restart_game
    @sounds = {}
    @played_sounds = {}
    @current_score = 0

    @link.reset

    reset_values
  end

  def init_game
    @ground = 440
    @ceiling = 50
    @space_down_frame = 0

    @link = Link.new(self)
    @background = Background.new(self)

    reset_values
  end
end
