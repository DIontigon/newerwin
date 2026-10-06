local USER = "Diontigon"
local REPO = "neverwin"
local FILE = "neverwin.lua"

local URLS = {
    "https://raw.githubusercontent.com/" .. USER .. "/" .. REPO .. "/main/" .. FILE,
    "https://cdn.jsdelivr.net/gh/" .. USER .. "/" .. REPO .. "@main/" .. FILE,
    "https://raw.githack.com/" .. USER .. "/" .. REPO .. "/main/" .. FILE,
}

local function isCode(s)
    return type(s) == "string" and #s > 500 and not s:find("^404")
end

local function tryFetch(url)
    print("[NW] Trying:", url)
    -- HttpGet первым (у Madium работает)
    if game.HttpGet then
        local ok, res = pcall(game.HttpGet, game, url)
        if ok and isCode(res) then return res end
    end
    if game.HttpGetAsync then
        local ok, res = pcall(game.HttpGetAsync, game, url)
        if ok and isCode(res) then return res end
    end
    if request then
        local ok, res = pcall(request, {Url=url, Method="GET"})
        if ok and res and isCode(res.Body) then return res.Body end
    end
    if http_request then
        local ok, res = pcall(http_request, {Url=url, Method="GET"})
        if ok and res and isCode(res.Body) then return res.Body end
    end
    if syn and syn.request then
        local ok, res = pcall(syn.request, {Url=url, Method="GET"})
        if ok and res and isCode(res.Body) then return res.Body end
    end
    return nil
end

local code
for _, url in ipairs(URLS) do
    code = tryFetch(url)
    if code then
        print("[NW] Got code:", #code, "bytes")
        break
    end
end

if not code then
    warn("[NW] All mirrors failed. Check URL / internet.")
    return
end

local fn, err = loadstring(code)
if not fn then
    warn("[NW] Syntax error:", err)
    return
end

if getgenv then getgenv().NW_LOADED = true end
print("[NW] Executing Neverwin...")
fn()
