#!/usr/local/bin/fennel
(local fennel (require :fennel))

;; Helper Functions
(fn tcopy [src]
  "Returns a shallow copy of a table"
  (let [tbl {}]
    (each [k v (pairs src)]
      (tset tbl k v))
    tbl))
(fn sleep [s]
  "Uses OS `sleep` command to avoid 'busy wait'"
  (os.execute (.. "sleep " (tonumber s))))
(fn pretty-time [s]
  "Takes a number of seconds and returns a number of nice looking minutes and seconds"
  (let [minutes (math.floor (/ s 60))
        seconds (% s 60)]
    (string.format "%02d:%02d" minutes seconds)))
(fn stepper [tbl step]
  (fn [field] (tset tbl field (+ (. tbl field) step))))
(fn reset [dest src]
  (fn [fields]
    (each [_ field (pairs fields)]
      (tset dest field (. src field)))))


;; Globals
(local defaults {
                 :focus-time 3
                 :short-rest-time 1
                 :long-rest-time 2
                 :max-pomos 5
                 :focus-emoji "🍅"
                 :short-rest-emoji "🧘‍♀️"
                 :long-rest-emoji "💃"
                 })
(local config-path (.. (os.getenv :HOME) :/.pomo-config.fnl))
(local config (match (pcall fennel.dofile config-path)
                (true _config) _config
                (false err) defaults))
(tset config :pomo-count 0)

(var state (tcopy config))
(local reset-state (reset state config))
(local incr (stepper state 1))
(local decr (stepper state -1))

(fn print-time [k]
  (print (..
    (. state (.. k "-emoji"))
    " "
    (pretty-time (. state (.. k "-time")))
    " "
    (. state (.. k "-emoji")))))

(fn focus []
  (print-time :focus)
  (decr :focus-time)
  (sleep 1))

(fn rests [field resets]
  (fn [f]
    (let [time (.. field "-time")]
      (print-time field)
      (decr time)
      (sleep 1)
      (let [done? (= (. state time) 0)]
        (when done?
          (reset-state resets)
          (f))))))
(local short-rest (rests :short-rest [:short-rest-time :focus-time]))
(local long-rest (rests :long-rest [:focus-time :short-rest-time :long-rest-time]))

;; Main
(fn pomo []
  "A pomodoro timer"

  ; main loop
  (while (> state.max-pomos state.pomo-count)
    ;; focus
    (while (> state.focus-time 0) (focus))
    (incr :pomo-count)

    ;; check if complete
    (when (= state.pomo-count state.max-pomos)
      (print "🎉 work complete! 🎉"))

    ;; rest if needed
    (while (and (= state.focus-time 0)
                (~= (% state.pomo-count 4) 0)
                (~= state.pomo-count state.max-pomos))
      (short-rest pomo))
    (while (and (= (% state.pomo-count 4) 0)
                (~= state.pomo-count state.max-pomos))
      (long-rest pomo))))

;; Begin
(pomo)
