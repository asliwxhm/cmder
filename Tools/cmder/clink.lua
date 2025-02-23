-- 
--[[
> hostname
DESKTOP-5NVTL9O

> echo %CMDER_CONFIG_DIR%
C:\Tools\cmder\config

c:\Tools\cmder\vendor\clink\clink.lua
c:\Tools\cmder\vendor\clink\clink.lua

> net use x: \\W10X64-LT-01\CDrive /persistent:ye
Y:\toolsbeta\cmder\vendor\clink\clink.lua
]]
-- This file is intentionally blank.
--



-- cmder_prompt.lua
-- Revision: 1.0
-- Date: Sat_Feb_15_2025_0835AM
-- C:\Tools\cmder\config


-- Function to get current date and time in EST
function get_est_datetime()
    local handle = io.popen("TZ=America/New_York date +\"%a_%b_%d_%Y_%I%M%p\"")
    local result = handle:read("*a")
    handle:close()
    return result:gsub("\n", "")  -- Remove trailing newline
end



-- ANSI Color Codes for Lua
local black        = "\x1b[30m"
local red          = "\x1b[31m"
local green        = "\x1b[32m"
local yellow       = "\x1b[33m"
local blue         = "\x1b[34m"
local magenta      = "\x1b[35m"
local cyan         = "\x1b[36m"
local white        = "\x1b[37m"
local gray         = "\x1b[90m"  -- Gray color (same as bright black)

-- Bright Colors
local bright_black   = "\x1b[90m"  -- Alias for gray
local bright_red     = "\x1b[91m"
local bright_green   = "\x1b[92m"
local bright_yellow  = "\x1b[93m"
local bright_blue    = "\x1b[94m"
local bright_magenta = "\x1b[95m"
local bright_cyan    = "\x1b[96m"
local bright_white   = "\x1b[97m"

-- Reset / Normal Colors
local reset       = "\x1b[0m"
local bold        = "\x1b[1m"
local underline   = "\x1b[4m"
local normal      = "\x1b[m"

-- Example Usage:
-- print(gray .. "This is gray text" .. reset)
-- print(green .. "This is green text" .. reset)
-- print(bright_yellow .. "This is bright yellow text" .. reset)
-- print(underline .. "This is underlined text" .. reset)


-- A prompt filter that discards any prompt so far and sets the
-- prompt to the current working directory.  An ANSI escape code
-- colors it yellow.
-- local cwd_prompt = clink.promptfilter(30)
-- function cwd_prompt:filter(prompt)
-- return green..os.getcwd()..normal
-- end

local cwd_prompt = clink.promptfilter(30)
function cwd_prompt:filter(prompt)
--    print(prompt .. "yy") 
    prompt = prompt:gsub("\n", "")  -- Trim leading spaces from the original prompt
        -- Build the formatted prompt string
    local formatted_prompt = green .. os.getcwd() .. normal.."> "
--    formatted_prompt = formatted_prompt:gsub("^%s+", "")  -- Trim leading spaces from the original prompt
    --print(formatted_prompt .. "xx")
    return formatted_prompt
    -- return green..os.getcwd()..normal
end

-- A prompt filter that inserts the date at the beginning of the
-- the prompt.  An ANSI escape code colors the date green.
-- https://www.lua.org/pil/22.1.html#:~:text=For%20other%20format%20strings%2C%20os,%2D%2D%3E%2009/16/1998
-- %a	abbreviated weekday name (e.g., Wed)
-- %A	full weekday name (e.g., Wednesday)
-- %b	abbreviated month name (e.g., Sep)
-- %B	full month name (e.g., September)
-- %c	date and time (e.g., 09/16/98 23:48:10)
-- %d	day of the month (16) [01-31]
-- %H	hour, using a 24-hour clock (23) [00-23]
-- %I	hour, using a 12-hour clock (11) [01-12]
-- %M	minute (48) [00-59]
-- %m	month (09) [01-12]
-- %p	either "am" or "pm" (pm)
-- %S	second (10) [00-61]
-- %w	weekday (3) [0-6 = Sunday-Saturday]
-- %x	date (e.g., 09/16/98)
-- %X	time (e.g., 23:48:10)
-- %Y	full year (1998)
-- %y	two-digit year (98) [00-99]
-- %%	the character `%´

-- C:\Tools\cmder\config

local date_prompt = clink.promptfilter(40)
function date_prompt:filter(prompt)
    return normal..""..prompt..bright_black.."["..os.date("%a_%b_%d_%Y__%I%M%p_%S").."] "
end

-- A prompt filter that may stop further prompt filtering.
-- This is a silly example, but on Wednesdays, it stops the
-- filtering, which in this example prevents git branch
-- detection and the line feed and angle bracket.
local wednesday_silliness = clink.promptfilter(60)
function wednesday_silliness:filter(prompt)
    if os.date("%a") == "Wed" then
        -- The ,false stops any further filtering.
        return prompt.." HAPPY HUMP DAY! ", false
    end
end

-- A prompt filter that appends the current git branch.
local git_branch_prompt = clink.promptfilter(65)
function git_branch_prompt:filter(prompt)
    local line = io.popen("git branch --show-current 2>nul"):read("*a")
    local branch = line:match("(.+)\n")
    if branch then
        return prompt.." "..cyan.."["..branch.."]"..normal
    end
end

-- prompt filter that adds a line feed and angle bracket.
local bracket_prompt = clink.promptfilter(150)
function bracket_prompt:filter(prompt)
return prompt.."\nλ "
end

