;; https://www.lua.org/pil/9.2.html
(local c coroutine)

(fn receive [prod]
  (let [(_ value) (c.resume prod)]
    value))

(fn send [x]
  (c.yield x))

(fn producer []
  (c.create (fn []
    (while true 
      (let [x "hey"]
        (send x))))))

(fn filter [prod]
  (c.create (fn []
    (var line 1)
      (while true 
        (let [x (string.format "%5d %s" line (receive prod))]
          (send x)
          (set line (+ line 1)))))))

(fn consumer [prod]
  (for [i 1 10]
    (let [x (receive prod)]
      (print x))))

(consumer (filter (producer)))
