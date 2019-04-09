-- подключим библиотеку json
json = require "./vendors/json"

dofile("config.lua")
dofile("file-maker.lua")

function OnInit()
    isConnect = isConnected()
    if isConnect == 1 then
        -- проверим наличие файла с данными и если файла нет
        -- создадим его, а если есть получим данные в переменную oldValueInfoObj
        fileExist, oldValueInfoObj = startfiles()
        -- если файл существует то обновим его данные
        update(oldValueInfoObj)

        if fileExist then
        else -- если файла нет создадим стартовые данные
            oldValueInfoObj = createStartData(oldValueInfoObj)
            --запишем стартовые данные в файл
            local text = json.encode(oldValueInfoObj)
            fileInfo.writeFile({}, text)
        end
    else
        message("Подключение нет!")
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
    message("Данные обновлены")
end

-- функция проверяет наличие файла и если нет создает его,
-- возращает даныне если они есть и пустой объект если их нет
function startfiles()
    fileInfo = FileConstructor:new(fileInfoName)
    if fileInfo:fileExists() then
        message("фаил с информацией найден")
        local oldValueInfo = fileInfo:read()
        return true, json.decode(oldValueInfo)
    else
        fileInfo:createFile()
        message("создаю файл")
        return false, {}
    end
end

-- функция получает все записи по тикерам и записывает их новой строкой в файл
function getDataOfAllTickers()
    local data = {}
    for i = 1, #rows do
        data[rows[i]] = getLastData(rows[i])
    end
    return data
end

-- функция получения последних данных по тикеру
function getLastData(tiker)
    return tiker and math_round(tonumber(getParamEx(class_code, tiker, indefParam).param_value), 4) or 0
end

-- функция формирует объект для стартовых данных
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

-- функция округления, первый аргумент округляемое число, второй сколько знаков в дробной части
function math_round(roundIn, roundDig)
    local mul = math.pow(10, roundDig)
    return (math.floor((roundIn * mul) + 0.5) / mul)
end
