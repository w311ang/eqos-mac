local ipc = require "luci.ip"

local m = Map("eqos", translate("Quality of Service"))

local s = m:section(TypedSection, "eqos", "")
s.anonymous = true

local e = s:option(Flag, "enabled", translate("Enable"))
e.rmempty = false

local dl = s:option(Value, "download", translate("Download speed (Mbit/s)"), translate("Total bandwidth"))
dl.datatype = "and(uinteger,min(1))"

local ul = s:option(Value, "upload", translate("Upload speed (Mbit/s)"), translate("Total bandwidth"))
ul.datatype = "and(uinteger,min(1))"

s = m:section(TypedSection, "device", translate("Speed limit based on MAC address"))
s.template = "cbi/tblsection"
s.anonymous = true
s.addremove = true
s.sortable  = true

local mac = s:option(Value, "mac", translate("MAC address"))

ipc.neighbors({family = 4, dev = "br-lan"}, function(n)
	if n.mac and n.dest then
		mac:value(n.mac, "%s (%s)" %{ n.mac, n.dest:string() })
	end
end)

dl = s:option(Value, "download", translate("Download speed (Mbit/s)"))
dl.datatype = "and(uinteger,min(1))"

ul = s:option(Value, "upload", translate("Upload speed (Mbit/s)"))
ul.datatype = "and(uinteger,min(1))"

comment = s:option(Value, "comment", translate("Comment"))

return m
