(local c coroutine)
(local config-default (require :defaults))
(local config-path (.. (os.getenv :HOME)))
(local config-file :/.pomo-config.fnl)
(local load-config (require :load-config))
(local config (load-config
  (.. config-path config-file)
  config-default))

;; wrapper for coroutine.resume
;; takes a producer and returns the value resumed from it
(fn receive [prod]
  (let [(_ x) (c.resume prod)] x))

;; wrapper for coroutine.yield
;; takes a value and yields it
;; must be called from within a coroutine
(fn send [...] (c.yield [...]))


(fn sleep []
  (os.execute (.. "sleep " 1)))


(fn pretty-time [s]
  (let [minutes (math.floor (/ s 60))
        seconds (% s 60)]
    (string.format "%02d:%02d" minutes seconds)))


(fn producer []
  (c.create (fn []
    (for [i 1 config.max-pomos 1]
      (for [i config.focus-time 1 -1]
        (send i :focus))
      (when (< i config.max-pomos)
        (if (= (% i 4) 0) 
          (for [i config.long-rest-time 1 -1] (send i :long-rest))
          (for [i config.short-rest-time 1 -1] (send i :short-rest))))))))


(fn filter [prod]
  (c.create (fn []
    (while (~= "dead" (c.status prod)) 
      (match (receive prod)
        ([time config-keystem] ? (~= time nil))
          (let [emoji (. config (.. config-keystem :-emoji))
                time (pretty-time time)]
            (send (.. emoji " " time " " emoji))))))))

(fn consumer [prod]
  (while (~= "dead" (c.status prod))
    (match (receive prod)
      ([x] ? (~= x nil))
        (do
          (print x)
          (sleep))))
  (print "🏁 POMODORO COMPLETE 🏁"))

(->
  (producer)
  (filter)
  (consumer))
