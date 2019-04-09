FileConstructor = {}
function FileConstructor:new(fileName)
    -- свойства
    local this = {}
    this.fileName = fileName

    function this:fileExists()
        local file = io.open(this.fileName, "rb")
        if file then
            file:close()
        end
        return file ~= nil
    end

    function this:createFile()
        local file = io.open(this.fileName, "w")
        file:write("")
        file:close()
    end

    --    Прочитать строки из файла
    function this:readFromFile(linesOrString) -- если передать false то вернет объект из линий
        if not this.fileExists(this.fileName) then
            return false
        end

        local file = io.open(this.fileName, "rb")
        local lines = {}
        for line in io.lines(this.fileName) do
            lines[#lines + 1] = line
        end

        file:close()

        local valueFromFile = ""
        for k, v in pairs(lines) do
            valueFromFile = string.len(valueFromFile) > 0 and valueFromFile .. ", " .. v or v
        end

        return not linesOrString and valueFromFile or lines
    end

    function this:writeFile(textstring)
        local file = io.open(this.fileName, "w")
        file:write(textstring)
        file:close()
    end

    function this:apendTextToFile(textstring, addNewLine)
        local file = io.open(this.fileName, "a")
        if addNewLine then
            file:write("\r" .. textstring)
        else
            file:write(textstring)
        end
        file:close()
    end

    function this:log(textstring, addNewLine)
        this:apendTextToFile( textstring, addNewLine)
    end

    function this:read( )
         if not this.fileExists(this.fileName) then
            return false
        end

        local file = io.open(this.fileName, "rb")
        local lines = {}
        for line in io.lines(this.fileName) do
            lines[#lines + 1] = line
        end

        file:close()

        local valueFromFile = ""
        for k, v in pairs(lines) do
            valueFromFile = valueFromFile .. v
        end

        return valueFromFile
       
    end

    -- метод
    function this:getName()
        return self.fileName
    end

    --чистая магия!
    setmetatable(this, self)
    self.__index = self
    return this
end
