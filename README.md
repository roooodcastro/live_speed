# Live Speed

<div align="center">
    <img alt="Live Speed Logo" src="https://github.com/roooodcastro/live_speed/raw/master/app/javascript/images/logo.png" height="400px">
</div>

## What is this?

Live Speed is an implementation of the card game "Speed". Speed is a
fast-paced card game, played with a standard 52-card deck. Its main goal is
to play and get rid of all of your cards before your opponent does. It's a
game more heavily focused on speed and reflexes, and less on strategy.

Live Speed is meant to be played online with friends or strangers. You can
also play against a CPU player. It was developed using the following stack:

* Ruby 2.6
* Rails 6.0 w/ Webpacker
* VueJS 2.5
* A few other JS libraries and their bazillion NPM dependencies
* Websockets w/ ActionCable
* PostgreSQL
* Hosted on Heroku

### You can access and PLAY the game now on: http://livespeed.rooood.com

Please note that the gameplay is still buggy and slow, and the game is
currently hosted on a free Heroku dyno, so it might take a while to boot.

## How to Play

You can currently play Live Speed matches with 2 players. Future expansion
may allow up to 4 players to play at the same time. A match consists of at
least one round, and can be extended in increments of 2 rounds (so that the
total number of rounds is always an odd number to avoid draws).

Each round is played as follows:

### Setup:

Each player is dealt five cards to form a hand, and additional 15 cards face
down to form a draw pile. Two stacks of five cards, placed face down on each
side between the players, serve as replacement piles. Finally, two cards are
placed face down in the center between the replacement piles. These form the
main game piles, in which most of the action occurs.

The game table looks something like this:

```
     Player 2 draw cards   Player 2 hand
                       ↓   ↓  ↓  ↓  ↓  ↓
                       🂠   🂣 🂣 🂣 🂣 🂣
Left replacement pile ↘         ↙ Right center pile
                       🂠    🂣 🂣    🂠
           Left center pile ↗         ↖ Right replacement pile
                       🂣 🂣 🂣 🂣 🂣   🂠
                       ↑  ↑  ↑  ↑  ↑   ↑
                   Player 1 hand    Player 1 draw cards
```


### Play:

The round begins when all players click the 'READY' button. At this point, the
face-down cards in the center piles at turned face-up at the same time. Using
cards from their hand, the players must simultaneously place cards of a rank
that is one above or one below on top of either of the center stacks without
hesitating to shuffle cards or otherwise delay the game (however a player may
only play one card at a time). For example, a pile with a six on top may have
a five or a seven placed on it, but not another six. Ace is both a high and
low card, considered one value above a King as well as one below a Two, so
that the cards form a looping sequence. Whenever the number of cards in a
player's hands drops below five, a card from the player's draw pile is
automaticaly drawn to their hand to maintain exactly five cards until that
player's draw pile is depleted.

When both players run out of options for play they must click their respective
replacement piles, and, when everyone has clicked, one card from each
replacement pile is flipped onto the top of the central piles. If these piles
become depleted, the central stacks are shuffled individually and are placed
face-down as new replacement piles from which cards can be flipped. If a
player has a card to place it must be placed, so the replacement piles can
only be played when no one has any valid plays left.

A player wins by running out of cards in his hand and draw pile before the
other player.

## Progress

Here's a quick overview of the project's progress:

### Gameplay

- [x] Card assets and positioning
- [x] Round loading through ActionCable
- [x] Card dealing animations
- [x] Wait until players ready
- [x] Drag-and-drop system to play cards
- [x] Play card
- [x] Draw card from draw pile
- [x] Wait until players ready for replacement play
- [x] Play replacement cards
- [x] Shuffle center piles back into replacement piles
- [x] End-game feedback
- [x] Redo card positioning to make it work for mobile
- [x] Fix visual bugs
- [x] Fix game ready bug where the cards don't flip when players are ready
- [x] Finish sound effects
- [x] Implement controls for disabling sound effects
- [x] Implement a HUD to show current round, current score, etc
- [x] Implement AI to serve as a tutorial
- [x] Pause game when player disconnects
- [x] Only reveal cards once both players are ready
- [x] Optimize for mobile gameplay
- [x] Replacement cards sometimes are placed behind the top center pile cards after reshuffle
- [x] Persist card being dragged after Vue update
- [ ] Add help timer to warn players of possible plays when they stay a long time without any moves
- [ ] End abandoned match by W.O. when player does not reconnect after a while
- [ ] Implement demo version of game to display on landing page
- [ ] Windows Solitaire card dropping animation
- [ ] Animate opponent card play
- [ ] Cards being pulled from random places instead of the draw pile

### Interface

- [x] Choose brand colours
- [x] Create basic layout
- [x] Create basic Vue components (buttons, links, form inputs, etc)
- [x] Style player creation page
- [x] Create landing page
- [ ] Add Google Analytics or similar user tracking service
- [ ] Implement GDPR
- [x] Optimize for mobile

### Main site

- [x] Basic login and sign up functionality
- [x] Able to play without signing up
- [x] Create new match
- [x] List existing matches
- [x] List matches that are waiting for players
- [x] Allow player to join a match
- [x] Able to start playing a round/new round from a match page
- [x] Define and implement full flow of player/user signup/login
- [ ] Add How to Play page with good instructions
- [ ] Let players with no account create an account with their existing Player
- [ ] Let players check their matches history
- [ ] Let players view and manage their accounts
- [ ] Show player statistics on profile page

### Deployment/misc

- [x] Setup Heroku deploy
- [x] Use Webpacker version of ActionCable and Turbolinks
- [x] Add JSRoutes with webpacker
- [x] Add i18n to Rails
- [x] Add i18n to JS/webpacker
- [x] Completely remove Sprockets in favour of Webpacker
- [x] Upgrade Webpack
- [ ] Add monitoring service
- [ ] Generate favicons in webpacker instead of sprockets
- [ ] Add some SEO stuff

## Credits

Author, Design & Implementation: Rodrigo Castro Azevedo

Playing Cards SVGs: Adrian Kennard from www.me.uk/cards

## License

This project is licensed under the [MIT License](LICENSE.md).