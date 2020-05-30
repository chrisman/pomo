(local fennel (require :fennel))

(fn load-config [config-path fallback]
  (let [config (match (pcall fennel.dofile config-path)
    (true user-config) user-config
    (false err) (do
      (print "🚨 Could not load config file 🚨")
      (print "🚨 Please edit ~/.pomo-config.fnl 🚨")
      fallback))]
    (tset config :pomo-count 0)
    config))
