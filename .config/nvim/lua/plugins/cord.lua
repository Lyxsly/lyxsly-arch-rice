return {
  {
    "vyfor/cord.nvim",

    opts = function()
      local async = require("cord.core.async")
      local process = require("cord.core.uv.process")

      local music_timer

      local function stop_music_timer()
        if music_timer then
          music_timer:stop()

          if not music_timer:is_closing() then
            music_timer:close()
          end

          music_timer = nil
        end
      end

      return {
        editor = {
          client = "lazyvim",
          tooltip = "LazyVim",
        },

        display = {
          view = "full",
          theme = "default",
          flavor = "dark",
        },

        text = {
          default = "Using Neovim",

          editing = function(opts)
            if opts.tooltip and opts.tooltip ~= "" then
              return "Writing " .. opts.tooltip
            end

            if opts.filetype and opts.filetype ~= "" then
              return "Writing " .. opts.filetype
            end

            return "Writing code"
          end,

          viewing = function(opts)
            if opts.tooltip and opts.tooltip ~= "" then
              return "Viewing " .. opts.tooltip
            end

            return "Viewing code"
          end,

          -- workspace名の代わりに現在再生中の曲を表示
          workspace = async.wrap(function(opts)
            local track = opts.cache:get_or_compute("mpris:current-track", 3, function()
              local result, err = process
                .spawn({
                  cmd = "playerctl",
                  args = {
                    "--all-players",
                    "metadata",
                    "--format",
                    "{{status}}\t{{artist}}\t{{title}}\t{{xesam:url}}",
                  },
                })
                :await()

              if err or not result or result.code ~= 0 then
                return false
              end

              local output = vim.trim(result.stdout or "")

              for line in output:gmatch("[^\r\n]+") do
                local status, artist, title, url = line:match("^(.-)\t(.-)\t(.-)\t(.*)$")

                if status == "Playing" and url and url:match("^https?://music%.youtube%.com/") and title and title ~= "" then
                  if not artist or artist == "" then
                    return "🎵 " .. title
                  end

                  return "🎵 " .. artist .. " — " .. title
                end
              end

              return false
            end)

            return track or nil
          end),
        },

        hooks = {
          -- 5秒ごとにCordを更新
          -- 曲が変わった時もPresenceが追従する
          ready = function(manager)
            stop_music_timer()

            music_timer = vim.uv.new_timer()

            music_timer:start(
              0,
              5000,
              vim.schedule_wrap(function()
                manager:queue_update(true)
              end)
            )
          end,

          shutdown = function()
            stop_music_timer()
          end,

          -- 今まで作ったArchアイコン
          post_activity = function(_, activity)
            activity.status_display_type = "state"

            activity.assets = activity.assets or {}

            activity.assets.small_image = "https://img.icons8.com/color/1200/arch-linux.jpg"

            activity.assets.small_text = "Arch Linux • LazyVim"
          end,
        },

        buttons = nil,
      }
    end,
  },
}
