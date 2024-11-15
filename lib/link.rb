# frozen_string_literal: true

require_relative 'character'

# The playable character
class Link < Character
  X = 16
  SLOWDOWN = 10
  JUMP_VELOCITY = -20  # Initial upward velocity (negative for upward movement)
  GRAVITY = 0.5        # Gravity pulls the character down
  MAX_VELOCITY = 20    # Maximum downward velocity to prevent endless fall

  def initialize(window)
    super(window)

    @width = 96
    @height = 104

    @sprites = Gosu::Image.load_tiles(
      @window, 'assets/link.png', @width, @height, true
    )[70..79]

    @game_over_sprite = Gosu::Image.load_tiles(
      @window, 'assets/link.png', @width, @height, true
    )[2]

    @x = X
    @y = @window.ground

    @velocity = 0 
    @facing = :right

    @framess = 0
  end

  def update
    init_jump if @window.button_down?(Gosu::KbSpace)

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

  def reset
    @x = X
    @y = @window.ground
    @velocity = 0
    @is_jumping = false
    @is_falling = false
  end

  private

  def init_jump
    # Start the jump if not already in the air (this is assuming we can only jump when grounded)
    return if @is_jumping

    @velocity = JUMP_VELOCITY # Set initial jump velocity
    @is_jumping = true
    @is_falling = false
  end

  # Jump upwards until the ceiling is reached and then go down until back on the floor
  def perform_jump
    @is_falling ? go_down : go_up

    @framess += 1
    puts @framess
  end

  def go_up
    # Apply vertical movement
    @y += @velocity
    @velocity += GRAVITY # Apply gravity

    # Check if the jump has reached the apex (the character has reached the ceiling)
    return if @y >= @window.ceiling

    # Clamp to ceiling and stop downward velocity
    @y = @window.ceiling
    @velocity = 0
    @is_falling = true
  end

  def go_down
    # Apply vertical movement and gravity, but clamp max fall speed
    @y += @velocity
    @velocity = [@velocity + GRAVITY, MAX_VELOCITY].min

    # Check if the character has hit the ground
    return unless @y >= @window.ground

    # Clamp to the ground and stop downward velocity
    @y = @window.ground
    @velocity = 0

    @is_jumping = false
    @is_falling = false
  end

  # Show stretched legs on jumping up and narrow legs on falling down
  def jumping_sprite
    @is_falling ? @sprites[7] : @sprites[5]
  end
end
