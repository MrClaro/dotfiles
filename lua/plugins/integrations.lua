return {
  {
    "rest-nvim/rest.nvim",
    dependencies = { { "nvim-lua/plenary.nvim" } },
    config = function()
      require("rest-nvim").setup({
        -- Whether to open the result in a horizontal split (false for vertical)
        result_split_horizontal = false,
        
        -- Keep the HTTP file buffer in place (false will move to the results window)
        result_split_in_place = false,
        
        -- Keep focus in the current window or switch to the results window after sending the request
        stay_in_current_window_after_split = false,
        
        -- Skip SSL verification for requests, useful for self-signed or unknown certificates
        skip_ssl_verification = false,
        
        -- Encode URLs before making the request (to ensure they are correctly formatted)
        encode_url = true,
        
        -- Highlight the request text in the file when running it
        highlight = {
          enabled = true,
          timeout = 150,  -- Time in milliseconds for the highlight to disappear
        },
        
        result = {
          -- Toggle showing URL, HTTP information, and headers in the result window
          show_url = true,
          -- Option to show the generated curl command (can be verbose)
          show_curl_command = false,
          -- Show HTTP response info like status code and headers
          show_http_info = true,
          -- Show headers in the result window
          show_headers = true,
          -- Table of curl `--write-out` variables or false to disable
          show_statistics = false,
          -- Format response bodies with external tools if specified
          formatters = {
            json = "jq",  -- Use jq to format JSON responses
            html = function(body) 
              -- Use 'tidy' to format HTML response bodies
              return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
            end,
          },
        },
        
        -- Whether to jump to the request line in the HTTP file after running the request
        jump_to_request = false,
        
        -- Specify an environment file for storing environment variables
        env_file = ".env",
        
        -- Custom dynamic variables to be used in requests (if any)
        custom_dynamic_variables = {},
        
        -- Enable dry run for yanking requests without executing them
        yank_dry_run = true,
        
        -- Enable searching backward in the file for requests
        search_back = true,
      })
    end,
    keys = {
      {
        "\\r",  -- Keybinding to trigger the REST request
        "<Plug>RestNvim",  -- Command to test the current file
        desc = "Test the current HTTP request",  -- Description for the keybinding
      },
    },
  },
}
