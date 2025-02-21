repeat
	task.wait();
until game:IsLoaded() and (not IonicInit);
(getgenv()).IonicInit = true;
local function a(b, c, d)
	local e = {
		black = {
			0,
			0,
			0
		},
		red = {
			255,
			0,
			0
		},
		green = {
			0,
			255,
			0
		},
		yellow = {
			255,
			255,
			0
		},
		blue = {
			0,
			0,
			255
		},
		magenta = {
			255,
			0,
			255
		},
		cyan = {
			0,
			255,
			255
		},
		white = {
			255,
			255,
			255
		},
		light_gray = {
			211,
			211,
			211
		},
		dark_gray = {
			169,
			169,
			169
		},
		light_red = {
			255,
			102,
			102
		},
		light_green = {
			102,
			255,
			102
		},
		light_blue = {
			102,
			102,
			255
		},
		light_magenta = {
			255,
			102,
			255
		},
		light_cyan = {
			102,
			255,
			255
		},
		orange = {
			255,
			165,
			0
		},
		pink = {
			255,
			192,
			203
		},
		purple = {
			128,
			0,
			128
		},
		brown = {
			165,
			42,
			42
		},
		light_yellow = {
			255,
			255,
			224
		}
	};
	local f = "white";
	local g = math.huge;
	for h, i in pairs(e) do
		local j = math.sqrt((b - i[1]) ^ 2 + (c - i[2]) ^ 2 + (d - i[3]) ^ 2);
		if j < g then
			g = j;
			f = h;
		end;
	end;
	local k = {
		black = "\027[0;30m",
		red = "\027[0;31m",
		green = "\027[0;32m",
		yellow = "\027[0;33m",
		blue = "\027[0;34m",
		magenta = "\027[0;35m",
		cyan = "\027[0;36m",
		white = "\027[0;37m",
		light_gray = "\027[0;37m",
		dark_gray = "\027[1;30m",
		light_red = "\027[1;31m",
		light_green = "\027[1;32m",
		light_blue = "\027[1;34m",
		light_magenta = "\027[1;35m",
		light_cyan = "\027[1;36m",
		orange = "\027[0;33m",
		pink = "\027[1;35m",
		purple = "\027[0;35m",
		brown = "\027[0;33m",
		light_yellow = "\027[1;33m"
	};
	return k[f];
end;
local l = cloneref(game:GetService("HttpService"));
local function m(n)
	if not isfolder("Ionic") then
		makefolder("Ionic");
	end;
	xpcall(function()
		request({
			Url = "http://127.0.0.1:3002",
			Method = "POST",
			Body = l:JSONEncode(n)
		});
		return true;
	end, function()
		error("[ Ionic Connection Module ] - An error occurred sending data.");
		return false;
	end);
end;
(getgenv()).rconsoleprint = newcclosure(function(o)
	assert(o ~= nil, "missing argument #1 to 'rconsoleprint' (string expected)");
	assert(type(o) == "string", "invalid argument #1 to 'rconsoleprint' (string expected, got " .. type(o) .. ")");
	task.spawn(m, {
		name = "rconsoleinfo",
		message = o
	});
end);
(getgenv()).rconsolewarn = newcclosure(function(o)
	assert(o ~= nil, "missing argument #1 to 'rconsolewarn' (string expected)");
	assert(type(o) == "string", "invalid argument #1 to 'rconsolewarn' (string expected, got " .. type(o) .. ")");
	task.spawn(m, {
		name = "rconsoleinfo",
		message = o
	});
end);
(getgenv()).rconsoleerror = newcclosure(function(o)
	assert(o ~= nil, "missing argument #1 to 'rconsoleerror' (string expected)");
	assert(type(o) == "string", "invalid argument #1 to 'rconsoleerror' (string expected, got " .. type(o) .. ")");
	task.spawn(m, {
		name = "rconsoleinfo",
		message = o
	});
end);
(getgenv()).rconsoleinfo = newcclosure(function(o)
	assert(o ~= nil, "missing argument #1 to 'rconsoleinfo' (string expected)");
	assert(type(o) == "string", "invalid argument #1 to 'rconsoleinfo' (string expected, got " .. type(o) .. ")");
	task.spawn(m, {
		name = "rconsoleinfo",
		message = o
	});
end);
(getgenv()).rconsoleinput = newcclosure(function(p)
	if isfile("Ionic/rconsoleinput.lua") then
		delfile("Ionic/rconsoleinput.lua");
	end;
	task.spawn(m, {
		name = "rconsoleinput",
		message = p or ""
	});
	repeat
		task.wait();
	until isfile("Ionic/rconsoleinput.lua");
	return readfile("Ionic/rconsoleinput.lua");
end);
(getgenv()).rconsoleinputasync = rconsoleinput;
(getgenv()).rconsoleerr = rconsoleerror;
(getgenv()).rconsoleclear = newcclosure(function()
	task.spawn(m, {
		name = "rconsoleclear",
		message = "norb"
	});
end);
(getgenv()).printconsole = newcclosure(function(q, r)
	assert(q ~= nil, "missing argument #1 to 'printrconsole' (string expected)");
	assert(type(q) == "string", "invalid argument #1 to 'printrconsole' (string expected, got " .. type(q) .. ")");
	assert(r ~= nil, "missing argument #2 to 'printrconsole' (Color3 expected)");
	assert(typeof(r) == "Color3", "invalid argument #2 to 'printrconsole' (Color3 expected)");
	local s = a(r.R, r.G, r.B);
	task.spawn(m, {
		name = "printrconsole",
		message = q .. ":" .. s
	});
end);
(getgenv()).printrconsole = printconsole;
(getgenv()).rconsoledestroy = rconsoleclear;
(getgenv()).rconsolereset = rconsoleclear;
(cloneref(game:GetService("LogService"))).MessageOut:Connect(function(p, t)
	if t == Enum.MessageType.MessageOutput then
		rconsoleprint(p);
	elseif t == Enum.MessageType.MessageInfo then
		rconsoleinfo(p);
	elseif t == Enum.MessageType.MessageWarning then
		rconsolewarn(p);
	elseif t == Enum.MessageType.MessageError then
		rconsoleerror(p);
	end;
end);
