WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
if _G.KorsHubRunning then
WindUI:Notify({
    Title = "A Kor's Hub instance is already running!",
    Content = "Go to the User Menu > click Destroy Window in order to shut down the current instance",
    Duration = 30,
    Icon = "circle-slash",
})
else
loadstring(game:HttpGet("https://raw.githubusercontent.com/korbloxin/korshub/refs/heads/main/main.lua"))()
end