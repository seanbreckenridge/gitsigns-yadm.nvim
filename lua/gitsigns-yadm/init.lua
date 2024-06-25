local M = {}

---@class (exact) GitsignsYadm.Config
---@field homedir? string
---@field yadm_repo_git? string
M.Config = {
    homedir = nil,
    yadm_repo_git = nil,
}

local function resolve_config()
    if M.Config.homedir == nil then
        -- if default config has not been computed yet, compute it
        local os = require("os")
        local homedir = os.getenv("HOME")
        if homedir ~= nil then
            M.Config.homedir = homedir
        end
    end

    if M.Config.yadm_repo_git == nil then
        local pth = vim.fn.expand("~/.local/share/yadm/repo.git")
        if (vim.uv or vim.loop).fs_stat(pth) then
            M.Config.yadm_repo_git = pth
        end
    end
end

--- gitsigns yadm support
---@param callback fun(cb_value: {toplevel: string, gitdir: string}?): nil
---@return nil
function M.yadm_signs(callback)
    resolve_config()
    if M.Config.homedir == nil then
        vim.notify(
            'Could not determine $HOME, please set homedir in Config like:\nrequire("gitsigns-yadm").Config.homedir = "/home/your_name"',
            vim.log.levels.WARN
        )
        return callback()
    end
    if M.Config.yadm_repo_git == nil then
        vim.notify(
            'Could not determine location of yadm repo, please set yadm_repo_git in Config like:\nrequire("gitsigns-yadm").Config.yadm_repo_git = "/home/your_name/.local/share/yadm/repo.git"',
            vim.log.levels.WARN
        )
        return callback()
    end

    vim.schedule(function()
        -- if buffer is not a file, don't do anything
        local file = vim.fn.expand("%:p")
        -- if the file is not in your home directory, skip
        if not vim.startswith(file, M.Config.homedir) then
            return callback()
        end
        if not vim.fn.filereadable(file) then
            return callback()
        end
        -- use yadm ls-files to check if the file is tracked
        require("plenary.job")
            :new({
                command = "yadm",
                args = { "ls-files", "--error-unmatch", file },
                on_exit = vim.schedule_wrap(function(_, return_val)
                    if return_val == 0 then
                        return callback({
                            toplevel = M.Config.homedir,
                            gitdir = M.Config.yadm_repo_git,
                        })
                    else
                        return callback()
                    end
                end),
            })
            :sync()
    end)
end

return M
