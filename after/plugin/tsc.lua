local tsc = require('tsc')
tsc.setup({
    auto_open_qflist = false,
    auto_close = false,
    auto_start_watch_mode = true,
    auto_focus_qflits = false,
    pretty_errors = false,
    flags = {
        watch = true,
    },
    verbose = false,
})

