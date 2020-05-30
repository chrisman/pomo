It's a small pomodoro timer that runs in the terminal.

**WARNING**: because of the way the `sleep` function is written, you will have to manually kill this process to exit early. It's a feature: you are COMMITTED to the timer! 😁

## How I use it

![screenshot of pomo.fnl running in a small pane in tmux](doc/tmux.png)

I let the pomo run in a small pane in tmux next to other auxiliary panes like server logs, test runners, etc.

## Run it

1. configure: `cp pomo-config-example.fnl ~/.pomo-config.fnl` and edit it how you like it.

2. execute:

    - Run it directly with `fennel pomo.fnl`

    - or if fennel is not installed, `lua main.lua`

## Dependencies

- [fennel](https://fennel-lang.org/) (optional): `luarocks install fennel` (`brew install luarocks` if necessary)

- entr (optional): the makefile (`make dev`) uses entr to watch for changes to pomo.fnl (`brew install entr`)
