local tsc = require('tsc')
tsc.setup({
    auto_close = true,
    auto_start_watch_mode = true,
    auto_focus_qflits = false,
    flags = {
        watch = true,
    },
    verbose = false,
})

