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
            ensure_installed = { "python", "codelldb", "jsnode", "haskell" },
            automatic_installation = true,
            handlers = {}
        })
        local dapui = require("dapui")
        dapui.setup({
            icons = {
                expanded = "",
                collapsed = "",
                circular = "",
            },
            controls = {
                icons = {
                    pause = "",
                    play = "",
                    step_into = "",
                    step_over = "󱞰",
                    step_out = "",
                    run = "▶",
                    stop = "■"
                }
            }
        })

        vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError" })
        vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticError" })

        vim.keymap.set("n", "<F5>", function() dap.continue() end, { noremap = true, silent = true })
        vim.keymap.set("n", "<S-F5>", function() dap.terminate() end, { noremap = true, silent = true })
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
