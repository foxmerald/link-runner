# frozen_string_literal: true

# Access the coordinates of various positions more easily
module Coords
  def top
    y + 20
  end

  def bottom
    y + height - 10
  end

  def left
    x + 24
  end

  def right
    x + width - 24
  end

  def center_horizontal
    x + (width / 2)
  end

  def center_vertical
    y + (height / 2)
  end

  def front
    case facing
    when :right then right
    when :left then left
    end
  end
end
