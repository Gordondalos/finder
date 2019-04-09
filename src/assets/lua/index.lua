-- ��������� ���������� json
json = require "./vendors/json"

dofile("config.lua")
dofile("file-maker.lua")

function OnInit()
    isConnect = isConnected()
    if isConnect == 1 then
        -- �������� ������� ����� � ������� � ���� ����� ���
        -- �������� ���, � ���� ���� ������� ������ � ���������� oldValueInfoObj
        fileExist, oldValueInfoObj = startfiles()
        -- ���� ���� ���������� �� ������� ��� ������
        update(oldValueInfoObj)

        if fileExist then
        else -- ���� ����� ��� �������� ��������� ������
            oldValueInfoObj = createStartData(oldValueInfoObj)
            --������� ��������� ������ � ����
            local text = json.encode(oldValueInfoObj)
            fileInfo.writeFile({}, text)
        end
    else
        message("����������� ���!")
    end
end

function OnStop()
    do_main = false
end

function main()
    do_main = true
    while do_main do
        fileExist, oldValueInfoObj = startfiles()
        update(oldValueInfoObj)
        sleep(sleep_time)
    end
end

-----------------------------------------------------------------------------------------------------------------------

function update(oldValueInfoObj)
    local newObj = addNewValue(oldValueInfoObj)
    local text = json.encode(newObj)
    fileInfo.writeFile({}, text)
    message("������ ���������")
end

-- ������� ��������� ������� ����� � ���� ��� ������� ���,
-- ��������� ������ ���� ��� ���� � ������ ������ ���� �� ���
function startfiles()
    fileInfo = FileConstructor:new(fileInfoName)
    if fileInfo:fileExists() then
        message("���� � ����������� ������")
        local oldValueInfo = fileInfo:read()
        return true, json.decode(oldValueInfo)
    else
        fileInfo:createFile()
        message("������ ����")
        return false, {}
    end
end

-- ������� �������� ��� ������ �� ������� � ���������� �� ����� ������� � ����
function getDataOfAllTickers()
    local data = {}
    for i = 1, #rows do
        data[rows[i]] = getLastData(rows[i])
    end
    return data
end

-- ������� ��������� ��������� ������ �� ������
function getLastData(tiker)
    return tiker and math_round(tonumber(getParamEx(class_code, tiker, indefParam).param_value), 4) or 0
end

-- ������� ��������� ������ ��� ��������� ������
function createStartData(myObj)
    myObj.init = {}
    myObj.init.date = getMyDate()
    myObj.init.value = getDataOfAllTickers()
    return myObj
end

function getMyDate()
    seconds = os.time(datetime)
    -- return tostring(os.date("%d-%m-%Y:%X", seconds))
    return tostring(os.date("%d-%m-%Y", seconds))
end

function addNewValue(myObj)
    myObj.finish = {}
    myObj.finish.date = getMyDate()
    myObj.finish.value = getDataOfAllTickers()
    return myObj
end

-- ������� ����������, ������ �������� ����������� �����, ������ ������� ������ � ������� �����
function math_round(roundIn, roundDig)
    local mul = math.pow(10, roundDig)
    return (math.floor((roundIn * mul) + 0.5) / mul)
end
