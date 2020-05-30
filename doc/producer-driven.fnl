;; https://www.lua.org/pil/9.2.html
(local c coroutine)

(fn receive [prod]
  (let [(_ value) (c.resume prod)]
    value))

(fn send [x]
  (c.yield x))

(fn producer []
  (c.create (fn []
    (for [i 1 10]
      (send i)))))

(fn filter [prod]
  (c.create (fn []
    (var line 1)
      (while (~= "dead" (c.status prod))
        (match (receive prod)
          (x ? (~= x nil))
            (let [s (string.format "%5d" line)]
              (send (..  s " " x)) 
              (set line (+ line 1))))))))

(fn consumer [prod]
  (while (~= "dead" (c.status prod))
    (match (receive prod)
      (x ? (~= x nil))
        (print x))))

(->
  (producer)
  (filter)
  (consumer))
