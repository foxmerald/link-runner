# frozen_string_literal: true

# Access the coordinates of various positions more easily
module Coords
  def top
    y
  end

  def bottom
    y + height
  end

  def left
    x
  end

  def right
    x + width
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
