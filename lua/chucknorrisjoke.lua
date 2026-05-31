local function fetch_url(url, target_key)
        local cmd = string.format("curl -sL '%s'", url)
        local output = vim.fn.system(cmd)

        if vim.v.shell_error ~= 0 then
                -- vim.notify("Failed to fetch URL: " .. url, vim.log.levels.ERROR)
                return nil
        end

        local success, data = pcall(vim.json.decode, output)

        if not success then
                vim.notify("Invalid JSON received", vim.log.levels.ERROR)
                return nil
        end

        local value = data[target_key]

        if value == nil then
                vim.notify("Key '" .. target_key .. "' not found in response", vim.log.levels.WARN)
                return nil
        end

        return value
end

local function print_joke()
        -- local url = "https://api.chucknorris.io/jokes/random"
        local url = "https://api.chucknorris.io/jokes/random?category={dev}"
        local key_to_get = "value"

        local joke = (fetch_url(url, key_to_get))

        if joke then
                print(joke)
        else
                local choice = math.random(0, 2)

                local messages = {
                        [0] = "Chuck Norris doesn't need APIs. The internet submits to him.",
                        [1] = "Chuck Norris roundhouse kicked the API server. It's offline now.",
                        [2] = "Chuck Norris already knows the joke. The API is just catching up."
                }

                print(messages[choice])
        end
end

-- pressing space, c and then n will display a random chuck norris joke (requires internet)
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>cn', print_joke)
