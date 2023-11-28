local tsc = require('tsc')
tsc.setup({
    auto_close = true,
    auto_start_watch_mode = true,
    flags = {
        watch = true,
        auto_focus_qflits = true,
    }
})

