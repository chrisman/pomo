local fennel = require("lib.fennel")
table.insert(package.loaders or package.searchers, fennel.searcher)
local pomo = require("pomo")
