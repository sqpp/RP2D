
TStream = {}
TStream.data = ""
TStream.pos = 1

function ReadStream(dir)
	local f = io.open(dir, "rb")
	if f then
		local stream = CreateStream()
		stream.data = f:read("*a")
		function stream:Read(n)
			local data = string.sub(stream.data, stream.pos, stream.pos + n - 1)
			stream.pos = stream.pos + n
			return data
		end

		function stream:Close()
			return f:close()
		end
		return stream
	end
end

function WriteStream(dir)
	local f = io.open(dir, "wb")
	local stream = CreateStream()
	function stream:Write(data)
		return f:write(data)
	end

	function stream:Close()
		return f:close()
	end
	return stream
end

function ReadInt(stream)
	local n = 0
	local s = stream:Read(4)
	for i = 1, string.len(s) do
		n = n + string.byte(s,i) * (256 ^ (i-1))
	end
	return(n)
end

function WriteInt(stream, x)
	local b4 = string.char(x % 256)
	x = (x - x % 256) / 256
	local b3 = string.char(x % 256)
	x = (x -x % 256) / 256
	local b2 = string.char(x % 256)
	x = (x - x % 256) / 256
	local b1 = string.char(x % 256)
	x = (x - x % 256) / 256
	stream:Write(b4..b3..b2..b1)
end

function ReadLine(stream)
	local str = ""
	while true do
		local n = string.byte(stream:Read(1))
		if not n or n == 10 then
			break
		end
		if (n ~= 13) then
			str = str..string.char(n)
		end
	end
	return(str)
end

function WriteLine(stream,str)
	return stream:Write(str..string.char(13)..string.char(10))
end

function CloseStream(stream)
	return stream:Close()
end

function CreateStream()
	local new = {}
	for k, v in pairs(TStream) do
		if type(v) == "table" then
			new[k] = CopyTable(v)
		elseif type(v) == "function" then
			new[k] = loadstring(string.dump(v))
		else
			new[k] = v
		end
	end
	return new
end

function WriteBytes(n,cnt)
	local i = 1
	local b = {n%256}
	local p = {n}

	while b[i] and p[i] ~= 0 do
		i = i + 1
		p[i] = (p[i-1] - b[i-1])/256
		b[i] = p[i]%256
	end

	local str = ""
	for i = 1, cnt do
		if i <= #b - 1 then
			str = str .. string.char(b[i])
		else
			str = str .. string.char(0)
		end
	end
	return str
end

function TStream:WriteBytes(n,count)
	if (n > ByteMax(count)) then
		return(false)
	end
	return self:Write(WriteBytes(n, count))
end

function WriteByte(stream,n)
	return stream:WriteBytes(n, 1)
end

function ReadByte(stream)
	return stream:ReadBytes(1)
end

function ReadBytes(s)
	local b = 0
	local n = 0
	for i = 1, string.len(s) do
		n = n + string.byte(s,i) * (256 ^ (i-1))
	end
	return(n)
end
function TStream:ReadBytes(count)
	local s = self:Read(count)
	if s and string.len(s) <= count then return ReadBytes(s) end
end

function ReadShort(stream)
	return stream:ReadBytes(2)
end

function WriteShort(stream,n)
	return stream:WriteBytes(n, 2)
end
function ByteMax(count)
	return (256^count) - 1
end



