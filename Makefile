.PHONY: default
default:
	@echo "No default targets. Use one of the following targets."
	@grep "^# target" Makefile	

# target: dev -- start a watcher on pomo.fnl
dev: pomo.fnl
	ls pomo.fnl | entr -c -r fennel pomo.fnl

# target: compile -- compile to a lua file
compile: pomo.fnl
	@fennel --compile pomo.fnl > pomo.lua
	@echo "Created pomo.lua"
