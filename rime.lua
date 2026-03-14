-- Rime Lua 脚本

-- 1. 动态日期时间翻译器
function date_translator(input, seg)
    if (input == "rq") then
        local dates = {
            {os.date("%Y-%m-%d"), "日期"},
            {os.date("%Y年%m月%d日"), "日期"},
            {os.date("%m-%d"), "短日期"},
            {os.date("%Y/%m/%d"), "日期"}
        }
        for _, v in ipairs(dates) do
            yield(Candidate("date", seg.start, seg._end, v[1], " " .. v[2]))
        end
    end
    if (input == "sj") then
        local times = {
            {os.date("%H:%M"), "时间"},
            {os.date("%H:%M:%S"), "秒"}
        }
        for _, v in ipairs(times) do
            yield(Candidate("time", seg.start, seg._end, v[1], " " .. v[2]))
        end
    end
    if (input == "xq") then
        local weakTab = {'日', '一', '二', '三', '四', '五', '六'}
        local w = "星期" .. weakTab[tonumber(os.date("%w") + 1)]
        yield(Candidate("week", seg.start, seg._end, w, " 星期"))
        yield(Candidate("week", seg.start, seg._end, "周" .. weakTab[tonumber(os.date("%w") + 1)], " 星期"))
    end
end

-- 2. 动态计算器 (输入 q + 表达式)
-- 例子：q1+2*3 候选词显示 7
function calculator_translator(input, seg)
    if string.sub(input, 1, 1) ~= "q" then return end
    local exp = string.sub(input, 2)
    if exp == "" then return end
    -- 清理输入，只允许数学符号和数字
    exp = exp:gsub("x", "*"):gsub("X", "*"):gsub(":", "/")
    local func = load("return " .. exp)
    if func then
        local res = func()
        if res then
            yield(Candidate("calculator", seg.start, seg._end, tostring(res), " 计算器"))
        end
    end
end

-- 3. 过滤器：单字在先
function single_char_first_filter(input)
    local l = {}
    for cand in input:iter() do
        if (utf8.len(cand.text) == 1) then
            yield(cand)
        else
            table.insert(l, cand)
        end
    end
    for _, cand in ipairs(l) do
        yield(cand)
    end
end

-- 4. 动态数字大写/金额转换 (输入大写 R + 数字)
-- 例子：R1234.56 候选词显示 壹仟贰佰叁拾肆元伍角陆分
function number_translator(input, seg)
    if string.sub(input, 1, 1) ~= "R" then return end
    local num_str = string.sub(input, 2)
    if not string.match(num_str, "^%d+%.?%d*$") then return end

    local function num2zh(num, is_capital)
        local digits = is_capital and {"零","壹","贰","叁","肆","伍","陆","柒","捌","玖"} or {"〇","一","二","三","四","五","六","七","八","九"}
        local positions = is_capital and {"","拾","佰","仟","万","拾","佰","仟","亿","拾","佰","仟"} or {"","十","百","千","万","十","百","千","亿","十","百","千"}
        local int_part = string.match(num, "^(%d+)")
        local dec_part = string.match(num, "%.(%d+)$")
        local res = ""
        if int_part then
            local len = string.len(int_part)
            for i = 1, len do
                local d = tonumber(string.sub(int_part, i, i))
                if d ~= 0 then
                    res = res .. digits[d+1] .. positions[len-i+1]
                else
                    if i ~= len and tonumber(string.sub(int_part, i+1, i+1)) ~= 0 then
                        res = res .. digits[1]
                    end
                end
            end
            if res == "" then res = digits[1] end
        end
        if dec_part then
            res = res .. "点"
            for i = 1, string.len(dec_part) do
                res = res .. digits[tonumber(string.sub(dec_part, i, i))+1]
            end
        end
        return res
    end
    
    local function rmb(num)
        local digits = {"零","壹","贰","叁","肆","伍","陆","柒","捌","玖"}
        local positions = {"","拾","佰","仟","万","拾","佰","仟","亿","拾","佰","仟"}
        local int_part = string.match(num, "^(%d+)")
        local dec_part = string.match(num, "%.(%d+)$")
        local res = ""
        if int_part and tonumber(int_part) > 0 then
            local len = string.len(int_part)
            for i = 1, len do
                local d = tonumber(string.sub(int_part, i, i))
                if d ~= 0 then
                    res = res .. digits[d+1] .. positions[len-i+1]
                else
                    if i ~= len and tonumber(string.sub(int_part, i+1, i+1)) ~= 0 then res = res .. digits[1] end
                end
            end
            res = res .. "元"
        end
        if dec_part then
            local jiao = tonumber(string.sub(dec_part, 1, 1)) or 0
            local fen = tonumber(string.sub(dec_part, 2, 2)) or 0
            if jiao > 0 then res = res .. digits[jiao+1] .. "角" end
            if fen > 0 then res = res .. digits[fen+1] .. "分" end
        else
            res = res .. "整"
        end
        if res == "" then res = "零元整" end
        return res
    end

    yield(Candidate("number", seg.start, seg._end, num2zh(num_str, true), " 大写"))
    yield(Candidate("number", seg.start, seg._end, rmb(num_str), " 人民币"))
    yield(Candidate("number", seg.start, seg._end, num2zh(num_str, false), " 中文"))
end
