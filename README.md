# Link Runner

A small Zelda-themed jump'n'run adventure inspired by the [Dinosaur Game](https://en.wikipedia.org/wiki/Dinosaur_Game) from Chrome offline mode. 

Link is on his way through the Forbidden Woods, jumping over red Octoroks and trying to dodge flying Keese.

Written in Ruby with the [Ruby Gosu Gem](https://github.com/gosu/gosu).

## Getting Started

- install gosu `gem install gosu` (see guides for installing the gem on 
[macOS](https://github.com/gosu/gosu/wiki/Getting-Started-on-OS-X), [Linux](https://github.com/gosu/gosu/wiki/Getting-Started-on-Linux) or
[Windows](https://github.com/gosu/gosu/wiki/Getting-Started-on-Windows))
- enter the directory and run `ruby jump_adventure.rb`

## Screenshots

<img width="1312" alt="Screen Shot 2021-10-15 at 19 25 46" src="https://user-images.githubusercontent.com/12692752/137528579-3c3ee5f5-c328-468e-abb2-e15e9b5e465b.png">

<img width="1312" alt="Screen Shot 2021-10-15 at 19 26 08" src="https://user-images.githubusercontent.com/12692752/137528627-64484596-8fbd-4e7a-bed7-58bd644ad365.png">

<img width="1312" alt="Screen Shot 2021-10-15 at 19 25 52" src="https://user-images.githubusercontent.com/12692752/137528542-e9dda7d9-c6a5-4408-a27a-6945110854da.png">

## TODOs:
Handle monsters:
- [ ] add switching between monsters (9:1 octo to keese)
- [ ] add switching between colors of octoroks (maybe couple with highscore?)
- [ ] check collision detection for keese
- [ ] add random, sensible spawning of monsters

Gameplay
- [ ] add increasing speed
