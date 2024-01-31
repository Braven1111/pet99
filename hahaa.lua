local HttpService = game:GetService("HttpService")

local Request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

-- Lấy player và giá trị của Diamonds
local plr = game.Players.LocalPlayer
local leaderstats = plr:FindFirstChild("leaderstats")
local diamondsStat = leaderstats and leaderstats:FindFirstChild("\240\159\146\142 Diamonds")
local diamondsValue = diamondsStat and diamondsStat.Value

-- Lấy tên người chơi Roblox
local robloxUserName = plr and plr.Name

-- Lấy giá trị của thuộc tính "Coin" từ dữ liệu của người chơi
local coinValue = 0
local success, error = pcall(function()
    coinValue = plr.Data.Coin.Value
end)

-- Lấy webhookUrl từ biến getgenv().Set.webhook
local webhookUrl = getgenv().Set.webhook

-- Kiểm tra xem có giá trị Diamonds, Coin, tên người chơi và webhookUrl hay không
if diamondsValue and coinValue and robloxUserName and webhookUrl then
    -- Chuẩn bị nội dung thông điệp
    local message = {
        content = "Player: " .. robloxUserName .. "\nGiá trị của Diamonds là: " .. diamondsValue .. "\nGiá trị của Coin là: " .. coinValue
    }

    -- Chuyển đổi thông điệp thành JSON
    local jsonMessage = HttpService:JSONEncode(message)

    -- Gửi thông điệp đến webhook Discord
    local success, response = pcall(function()
        return Request({
            Url = webhookUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonMessage
        })
    end)

    -- Kiểm tra xem gửi thành công hay không
    if success then
        print("Thông điệp đã được gửi thành công.")
    else
        warn("Không thể gửi thông điệp đến webhook Discord:", response)
    end

    -- Tạo GUI (User Interface) để hiển thị giá trị Diamonds và Coin
    local gui = Instance.new("ScreenGui")
    gui.Parent = game.Players.LocalPlayer.PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 80) -- Tăng chiều cao để chứa thông tin Coin
    frame.Position = UDim2.new(0.5, -100, 0, 50)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.new(1, 1, 1)
    frame.Parent = gui

    local label1 = Instance.new("TextLabel")
    label1.Size = UDim2.new(1, 0, 0.5, 0) -- Chiều cao giảm để chứa thông tin Coin
    label1.Text = "Player: " .. robloxUserName
    label1.TextColor3 = Color3.new(1, 1, 1)
    label1.BackgroundTransparency = 1
    label1.Parent = frame

    local label2 = Instance.new("TextLabel")
    label2.Size = UDim2.new(1, 0, 0.5, 0)
    label2.Position = UDim2.new(0, 0, 0.5, 0) -- Dịch chuyển xuống để chứa thông tin Coin
    label2.Text = "Coin: " .. coinValue
    label2.TextColor3 = Color3.new(1, 1, 1)
    label2.BackgroundTransparency = 1
    label2.Parent = frame

    local label3 = Instance.new("TextLabel")
    label3.Size = UDim2.new(1, 0, 0.5, 0)
    label3.Position = UDim2.new(0, 0, 1, 0) -- Dịch chuyển xuống để chứa thông tin Diamonds
    label3.Text = "Diamonds: " .. tostring(diamondsValue)
    label3.TextColor3 = Color3.new(1, 1, 1)
    label3.BackgroundTransparency = 1
    label3.Parent = frame
else
    warn("Không tìm thấy giá trị Diamonds, Coin, tên người chơi, hoặc webhookUrl.")
end