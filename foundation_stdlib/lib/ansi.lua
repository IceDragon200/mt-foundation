-- Reference: https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797

local ANSI_CODE = {
  bold = "1",
  dim = "2",
  italic = "3",
  underline = "4",
  blinking = "5",
  reverse = "7",
  hidden = "8",
  strikethrough = "9",

  fg = {
    black = "30",
    red = "31",
    green = "32",
    yellow = "33",
    blue = "34",
    magenta = "35",
    cyan = "36",
    white = "37",
    default = "39",

    bright_black = "90",
    bright_red = "91",
    bright_green = "92",
    bright_yellow = "93",
    bright_blue = "94",
    bright_magenta = "95",
    bright_cyan = "96",
    bright_white = "97",
  },

  bg = {
    black = "40",
    red = "41",
    green = "42",
    yellow = "43",
    blue = "44",
    magenta = "45",
    cyan = "46",
    white = "47",
    default = "49",

    bright_black = "100",
    bright_red = "101",
    bright_green = "102",
    bright_yellow = "103",
    bright_blue = "104",
    bright_magenta = "105",
    bright_cyan = "106",
    bright_white = "107",
  },
}

local RESET_ANSI_CODE = {
  bold = "21",
  dim = "22",
  italic = "23",
  underline = "24",
  blinking = "25",
  reverse = "27",
  hidden = "28",
  strikethrough = "29",
}

function foundation.com.ansi_start(options)
  local codes = {}
  local code
  local sub

  for name, value in pairs(options) do
    if value == true then
      code = ANSI_CODE[name]
      if code then
        table.insert(codes, code)
      else
        error("unexpected key=" .. name)
      end
    elseif value == false then
      code = RESET_ANSI_CODE[name]
      if code then
        table.insert(codes, code)
      else
        error("unexpected key=" .. name)
      end
    else
      sub = ANSI_CODE[name]
      if type(sub == "table") then
        code = sub[value]
        if type(code) == "string" then
          table.insert(codes, code)
        else
          error("unexpected subkey=" .. value)
        end
      else
        error("unexpected key=" .. name)
      end
    end
  end

  return "\x1B[" .. table.concat(codes, ";") .. "m"
end

function foundation.com.ansi_end()
  return "\x1B[0m"
end

local ansi_start = foundation.com.ansi_start
local ansi_end = foundation.com.ansi_end

--- @spec #ansi_format(inner: String, options: Table): String
function foundation.com.ansi_format(inner, options)
  return ansi_start(options) .. inner .. ansi_end()
end
