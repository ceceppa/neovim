local config = {}

config.path = "/opt/homebrew/bin/php-cs-fixer" -- Replace with your actual path if needed

-- php-cs-fixer version (1.x or 2.x)
config.version = 2 -- Change to 2 if using php-cs-fixer 2.x

-- php-cs-fixer options
config.rules = "@PSR2"    -- For version 2.x
config.config = "default" -- For both versions
config.allow_risky = nil  -- For version 2.x, allow risky fixes
config.dry_run = false    -- Run with dry-run option
config.verbose = false    -- Print verbose output

-- Path to PHP executable
config.php_path = "php"

-- Enable mapping by default (assuming you define a mapping later)
config.enable_mapping = true

function PhpCsFixerFixFile()
    local filename = vim.api.nvim_buf_get_name(0)

    vim.cmd([[!]] .. config.php_path .. " " .. config.path .. " fix --rules=" .. config.rules .. " '" .. filename .. "'")
    --
    -- vim.notify(filename, nil, {
    --     title = "PhpCsFixer",
    -- })
end
