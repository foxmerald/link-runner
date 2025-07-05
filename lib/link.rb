# frozen_string_literal: true

require_relative 'character'

# Link is the playable character class, handling movement and jumping
class Link < Character
  X = 16
  SLOWDOWN = 10

  # Constants for jump physics
  JUMP_VELOCITY_BASE = -14 # Height for jump
  JUMP_VELOCITY_BOOST = -4 # Additional jump height for long press
  JUMP_GRAVITY = 0.4
  FALL_GRAVITY = 0.9
  MAX_VELOCITY = 20
  BOOST_MS = 200

  def initialize(window)
    super(window)

    @width = 96
    @height = 104

    # Load character animation sprites
    @sprites = Gosu::Image.load_tiles(
      @window, 'assets/link.png', @width, @height, true
    )[70..79]

    # Sprite shown on game over
    @game_over_sprite = Gosu::Image.load_tiles(
      @window, 'assets/link.png', @width, @height, true
    )[2]

    # Initial position and state
    @x = X
    @y = @window.ground

    @velocity = 0
    @facing = :right
    @jump_pressed_at = nil
    @jump_boosted = false
    @frames = 0
  end

  def update
    handle_jump_input
    perform_jump if @is_jumping
  end

  def draw
    return @game_over_sprite.draw(@x, @y, 1) if @window.game_over

    image = if @is_jumping
              jumping_sprite
            else
              f = (@window.frame / SLOWDOWN) % @sprites.size
              @sprites[f]
            end

    image.draw(@x, @y, 1)
  end

  # Reset character to initial state
  def reset
    @x = X
    @y = @window.ground
    @velocity = 0
    @is_jumping = false
    @is_falling = false
    @jump_pressed_at = nil
    @jump_boosted = false
  end

  private

  # Detect jump press and apply boost if key is held
  def handle_jump_input
    return @jump_pressed_at = nil unless @window.button_down?(Gosu::KbSpace)

    # Start jump immediately on key down
    return start_jump if !@is_jumping && !@jump_pressed_at

    add_jump_boost
  end

  # Begin jump with base velocity
  def start_jump
    @velocity = JUMP_VELOCITY_BASE
    @is_jumping = true
    @is_falling = false

    @jump_pressed_at = Gosu.milliseconds
    @jump_boosted = false
  end

  # Apply extra boost during jump if key still held within boost window
  def add_jump_boost
    return unless @is_jumping && !@jump_boosted && @jump_pressed_at && Gosu.milliseconds - @jump_pressed_at > BOOST_MS

    @velocity += JUMP_VELOCITY_BOOST
    @jump_boosted = true
  end

  # Execute upward or downward motion
  def perform_jump
    @is_falling ? go_down : go_up
    @frames += 1
  end

  # Apply upward movement with jump gravity
  def go_up
    @y += @velocity
    @velocity += JUMP_GRAVITY

    # Switch to falling when upward velocity is depleted
    return unless @velocity >= 0

    @is_falling = true
  end

  # Apply downward movement with fall gravity
  def go_down
    @y += @velocity
    @velocity = [@velocity + FALL_GRAVITY, MAX_VELOCITY].min

    # Stop falling when reaching ground
    return unless @y >= @window.ground

    @y = @window.ground
    @velocity = 0
    @is_jumping = false
    @is_falling = false
    @jump_boosted = false
  end

  # Sprite depending on jump phase
  def jumping_sprite
    @is_falling ? @sprites[7] : @sprites[5]
  end
end
