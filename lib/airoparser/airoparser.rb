require 'csv'

class AccessPoint
    attr_reader :bssid, :firsttime, :lasttime, :channel, :speed, :privacy, :cipher, :auth, :power, :essid

    def initialize(ap)
        @bssid = ap[0]
        @firsttime = ap[1]
        @lasttime = ap[2]
        @channel = ap[3]
        @speed = ap[4]
        @privacy = ap[5]
        @cipher = ap[6]
        @auth = ap[7]
        @power = ap[8]
        @essid = ap[13]
    end
end

class WifiClient
    attr_reader :mac, :firstseen, :lastseen, :power, :bssid, :probedessid

    def initialize(wclient)
        @mac = wclient[0]
        @firstseen = wclient[1]
        @lastseen = wclient[2]
        @power = wclient[3]
        @bssid = wclient[5]
        @probedessid = wclient[6]
    end
end

class AiroParser
    attr_reader :aps, :clients

    def initialize(csvinput)
        @aps = []
        @clients = []
	lines = []
	csvinput.each_line do |line|
	    if not line == nil
		puts(line)
		thisline = CSV.parse_line(line.strip)
		thisline == [nil] ? next : thisline.map! {|x| x == nil ? next : x.strip}
		puts(thisline.inspect)
		if not thisline[13] == nil
		    thisline[13] == "ESSID" ? next : @aps.push(AccessPoint.new(thisline))
		else
		    thisline[5] == "BSSID" ? next : @clients.push(WifiClient.new(thisline))
		end
	    end
	end
        #CSV.parse(csvinput) do |line|
        #    line == [nil] ? next : line.map! {|x| x == nil ? next : x.strip}
        #    if not line[13] == nil 
        #        #this is an access point
        #        line[13] == "ESSID" ? next : @aps.push(AccessPoint.new(line))
        #    else
        #        #this is a client
        #        line[5] == "BSSID" ? next : @clients.push(WifiClient.new(line))
        #    end
        #end
    end
end

