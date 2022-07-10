-- Read VMD To Lua Table

local struct = require "struct"

VERSION_1_HEAD_BYTES_HEX = {
    0x56, 0x6F, 0x63, 0x61, 0x6C, 0x6F, 0x69, 0x64,                     -- Vocaloid
    0x20, 0x4D, 0x6F, 0x74, 0x69, 0x6F, 0x6E, 0x20,                     -- <space>Motion<space>
    0x44, 0x61, 0x74, 0x61, 0x20, 0x66, 0x69, 0x6C,                     -- Data<space>fil
    0x65, 0x00, 0x00, 0x00, 0x00, 0x00                                  -- e<null><null><null><null><null>
}

VERSION_2_HEAD_BYTES_HEX = {
    0x56, 0x6F, 0x63, 0x61, 0x6C, 0x6F, 0x69, 0x64,                     -- Vocaloid
    0x20, 0x4D, 0x6F, 0x74, 0x69, 0x6F, 0x6E, 0x20,                     -- <space>Motion<space>
    0x44, 0x61, 0x74, 0x61, 0x20, 0x30, 0x30, 0x30,                     -- Data<space>000
    0x32, 0x00, 0x00, 0x00, 0x00, 0x00                                  -- 2<null><null><null><null><null>
}

local function readVMD(filePath)
    local file = io.open(filePath, "rb")
    if not file then
        return nil
    end

    local result = {
        basicInfo = {
            version = 1
        }
    }

    local version = file:read(30)

    for i = 1, #VERSION_1_HEAD_BYTES_HEX do
        if version:byte(i) ~= VERSION_1_HEAD_BYTES_HEX[i] then
            result["basicInfo"]["version"] = 2
        end
    end

    local modelName = nil

    if result["basicInfo"]["version"] == 1 then
        modelName = file:read(10)
    else
        modelName = file:read(20)
    end

    result["basicInfo"]["modelName"] = modelName

    result["boneKeys"] = {}

    result["boneKeys"]["count"] = struct.unpack("<I", file:read(4))

    result["boneKeys"]["keys"] = {}

    for i = 1, result["boneKeys"]["count"] do
        result["boneKeys"]["keys"][i] = {}

        result["boneKeys"]["keys"][i]["name"] = file:read(15)
        result["boneKeys"]["keys"][i]["time"] = struct.unpack("<I", file:read(4))

        result["boneKeys"]["keys"][i]["position"] = {}
        result["boneKeys"]["keys"][i]["position"]["x"] = struct.unpack("<f", file:read(4))
        result["boneKeys"]["keys"][i]["position"]["y"] = struct.unpack("<f", file:read(4))
        result["boneKeys"]["keys"][i]["position"]["z"] = struct.unpack("<f", file:read(4))

        result["boneKeys"]["keys"][i]["rotation"] = {}
        result["boneKeys"]["keys"][i]["rotation"]["x"] = struct.unpack("<f", file:read(4))
        result["boneKeys"]["keys"][i]["rotation"]["y"] = struct.unpack("<f", file:read(4))
        result["boneKeys"]["keys"][i]["rotation"]["z"] = struct.unpack("<f", file:read(4))
        result["boneKeys"]["keys"][i]["rotation"]["w"] = struct.unpack("<f", file:read(4))

        result["boneKeys"]["keys"][i]["curve"] = {}

        result["boneKeys"]["keys"][i]["curve"]["x"] = {}
        result["boneKeys"]["keys"][i]["curve"]["y"] = {}
        result["boneKeys"]["keys"][i]["curve"]["z"] = {}
        result["boneKeys"]["keys"][i]["curve"]["rotation"] = {}

        for j = 1, 4 do
            result["boneKeys"]["keys"][i]["curve"]["x"][j] = file:read(1)
            file:read(3)
        end

        for j = 1, 4 do
            result["boneKeys"]["keys"][i]["curve"]["y"][j] = file:read(1)
            file:read(3)
        end

        for j = 1, 4 do
            result["boneKeys"]["keys"][i]["curve"]["z"][j] = file:read(1)
            file:read(3)
        end

        for j = 1, 4 do
            result["boneKeys"]["keys"][i]["curve"]["rotation"][j] = file:read(1)
            file:read(3)
        end
    end

    result["morphKeys"] = {}

    result["morphKeys"]["count"] = struct.unpack("<I", file:read(4))

    result["morphKeys"]["keys"] = {}

    for i = 1, result["morphKeys"]["count"] do
        result["morphKeys"]["keys"][i] = {}

        result["morphKeys"]["keys"][i]["name"] = file:read(15)
        result["morphKeys"]["keys"][i]["time"] = struct.unpack("<I", file:read(4))
        result["morphKeys"]["keys"][i]["weight"] = struct.unpack("<f", file:read(4))
    end

    result["cameraKeys"] = {}

    result["cameraKeys"]["count"] = struct.unpack("<I", file:read(4))

    result["cameraKeys"]["keys"] = {}

    for i = 1, result["cameraKeys"]["count"] do
        result["cameraKeys"]["keys"][i] = {}

        result["cameraKeys"]["keys"][i]["time"] = struct.unpack("<I", file:read(4))
        result["cameraKeys"]["keys"][i]["distance"] = struct.unpack("<f", file:read(4))

        result["cameraKeys"]["keys"][i]["position"] = {}
        result["cameraKeys"]["keys"][i]["position"]["x"] = struct.unpack("<f", file:read(4))
        result["cameraKeys"]["keys"][i]["position"]["y"] = struct.unpack("<f", file:read(4))
        result["cameraKeys"]["keys"][i]["position"]["z"] = struct.unpack("<f", file:read(4))

        result["cameraKeys"]["keys"][i]["rotationAngle"] = {}
        result["cameraKeys"]["keys"][i]["rotationAngle"]["x"] = struct.unpack("<f", file:read(4))
        result["cameraKeys"]["keys"][i]["rotationAngle"]["y"] = struct.unpack("<f", file:read(4))
        result["cameraKeys"]["keys"][i]["rotationAngle"]["z"] = struct.unpack("<f", file:read(4))

        result["cameraKeys"]["keys"][i]["curve"] = {}

        for j = 1, 4 do
            result["cameraKeys"]["keys"][i]["curve"][j] = file:read(1)
        end

        file:read(20)

        result["cameraKeys"]["keys"][i]["viewAngle"] = struct.unpack("<f", file:read(4))
        result["cameraKeys"]["keys"][i]["orthographic"] = file:read(1)
    end

    result["lightKeys"] = {}

    result["lightKeys"]["count"] = struct.unpack("<I", file:read(4))

    result["lightKeys"]["keys"] = {}

    for i = 1, result["lightKeys"]["count"] do
        result["lightKeys"]["keys"][i] = {}

        result["lightKeys"]["keys"][i]["time"] = struct.unpack("<I", file:read(4))

        result["lightKeys"]["keys"][i]["color"] = {}
        result["lightKeys"]["keys"][i]["color"]["r"] = struct.unpack("<f", file:read(4))
        result["lightKeys"]["keys"][i]["color"]["g"] = struct.unpack("<f", file:read(4))
        result["lightKeys"]["keys"][i]["color"]["b"] = struct.unpack("<f", file:read(4))

        result["lightKeys"]["keys"][i]["direction"] = {}
        result["lightKeys"]["keys"][i]["direction"]["x"] = struct.unpack("<f", file:read(4))
        result["lightKeys"]["keys"][i]["direction"]["y"] = struct.unpack("<f", file:read(4))
        result["lightKeys"]["keys"][i]["direction"]["z"] = struct.unpack("<f", file:read(4))
    end

    file:close()

    return result
end

return readVMD
