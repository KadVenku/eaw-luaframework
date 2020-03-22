# Empire at War LUA Framework

(c) 2017 - [Kad_Venku](mailto:venkukad@gmail.com)

## Description
This is an event driven framework for the Petroglyph game Star Wars: Empire at War - Forces of Corruption written entirely in LUA 5.1.  
The purpose of this framework is providing mod makers with the ability to add new gameplay mechanics on top of the existing game as well as allowing easy interaction with the game's GUI and story scripting system.  

## General Idea
The general idea is to mirror every necessary game object (planets, factions,...) as a LUA object. This way interaction between registered objects can be programmed and extended to one's liking via LUA 5.1 and only has to fall back to onto the game's default functionality to interact directly with the mirrored and linked game object.

In addition the framework provides a fully functional event handler which registers custom event types which inherit from a base event class. These can be affiliated with in-game actions or LUA object actions.

## Remarks

Since the framework had been designed and implemented in 2017, @SvenMarcus released the [EaWX Galactic Framework](https://github.com/SvenMarcus/eawx-galactic-framework) which I would recommend over this project.

## License
The project is provided under the MIT License, see LICENSE for details.