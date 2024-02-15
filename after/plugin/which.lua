local wk = require("which-key")

wk.register({
    c = {
        name = "Code",
    },
    d = {
        name = "Document",
    },
    b = {
        name = "Buffer",
    },
    f = {
        name = "File",
    },
    g = {
        name = "Git",
    },
    h = {
        name = "Harpoon/Hunks",
    },
    p = {
        name = "Project",
    },
    r = {
        name = "Replace/References",
    },
    s = {
        name = "Surround/Search",
    },
    t = {
        name = "TypeScript",
    },
    u = {
        name = "Undo",
    },
    v = {
        name = "Select content",
    },
    w = {
        name = "Window",
    },
    y = {
        name = "Copy",
    },
}, { prefix = "<leader>" })
