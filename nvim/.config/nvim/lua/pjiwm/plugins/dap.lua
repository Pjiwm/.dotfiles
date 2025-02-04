return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-lua/plenary.nvim",
        "nvim-neotest/nvim-nio",
        "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
        local dap = require("dap")
        require("mason-nvim-dap").setup({
            ensure_installed = { "python", "codelldb", "jsnode", "firefox-debug-adapter", "haskell" },
            automatic_installation = true,
            handlers = {}
        })

        -- Firefox
        dap.adapters.firefox = {
            type = "executable",
            command = "node",
            args = { os.getenv("HOME") .. "/.local/share/nvim/mason/packages/firefox-debug-adapter/dist/adapter.bundle.js" },
        }

        dap.configurations.javascript = {
            {
                name = "Launch Firefox",
                type = "firefox",
                request = "launch",
                reAttach = true,
                -- url = "http://localhost:5173",
                url = function()
                    return vim.fn.input("Enter URL (default: http://localhost:5173): ", "http://localhost:5173")
                end,
                webRoot = "${workspaceFolder}",
                firefoxExecutable = "/usr/bin/firefox",
            },
        }

        dap.configurations.typescript = dap.configurations.javascript
        dap.configurations.vue = dap.configurations.javascript




        local dapui = require("dapui")
        dapui.setup({
            icons = {
                expanded = "",
                collapsed = "",
                circular = "",
            },
        })

        vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError" })
        vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticError" })

        vim.keymap.set("n", "<F5>", function() dap.continue() end, { noremap = true, silent = true })
        vim.keymap.set("n", "<leader><F5>", function() dap.terminate() end, { noremap = true, silent = true })
        vim.keymap.set("n", "<F10>", function() dap.step_over() end, { noremap = true, silent = true })
        vim.keymap.set("n", "<F11>", function() dap.step_into() end, { noremap = true, silent = true })
        vim.keymap.set("n", "<F12>", function() dap.step_out() end, { noremap = true, silent = true })

        vim.keymap.set("n", "<leader>b", function() dap.toggle_breakpoint() end, { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>lp", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
            { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>lb",
            function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
            { noremap = true, silent = true })

        vim.keymap.set("n", "<leader>du", function() dapui.toggle() end, { noremap = true, silent = true })

        dap.listeners.after["event_initialized"]["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before["event_terminated"]["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before["event_exited"]["dapui_config"] = function()
            dapui.close()
        end
    end
}
