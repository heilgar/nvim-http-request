local M = {}

local ui = require('http_client.ui')

function M.display_dry_run(http_client)
    local request = http_client.parser.get_request_under_cursor()
    if not request then
        print('No valid HTTP request found under cursor')
        return
    end

    local env = http_client.environment.get_current_env()
    request = http_client.parser.replace_placeholders(request, env)

    local env_file = http_client.environment.get_current_env_file() or "Not set"
    local env_info = vim.inspect(env or {})
    local current_request = vim.inspect(http_client.http_client.get_current_request() or {})

    local content = string.format([[
Dry Run Information:
--------------------
Method: %s
URL: %s

Headers:
%s

Body:
%s

Environment Information:
------------------------
Current env file: %s

Current env:
%s

Current request:
%s
]],
        request.method,
        request.url,
        ui.format_headers(request.headers),
        request.body or "No body",
        env_file,
        env_info,
        current_request
    )

    ui.display_in_buffer(content, "HTTP Request Dry Run")
end


return M

