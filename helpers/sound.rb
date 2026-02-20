# frozen_string_literal: true

# Sound effects helper module
module Sound
  def play_sound(name, once: false)
    @sounds ||= {}
    @played_sounds ||= {}

    return if once && @played_sounds[name]

    @sounds[name] ||= Gosu::Sample.new("assets/sounds/#{name}.mp3")
    @sounds[name].play

    @played_sounds[name] = true if once
  end
end
