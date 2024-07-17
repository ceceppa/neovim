local tsc = require('tsc')
tsc.setup({
    auto_open_qflist = false,
    auto_close = false,
    auto_start_watch_mode = true,
    auto_focus_qflits = false,
    pretty_errors = false,
    enable_progress_notifications = false,
    enable_error_notifications = false,
    flags = {
        watch = true,
    },
    verbose = false,
})
