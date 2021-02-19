webnet = {}

function webnet:new(name,strict)
	local w = setmetatable({},{__index=webnet})
    if type(name) == 'string' then 
        local t,e = w:load(name,strict)
        if t == nil then w = nil; return nil,e end
    end
    return w
end

function webnet:load(name,strict)
	local last = -1
    local ib,ie,ia,_,co,cou,coun
    local ibn, ien
    local iptab,cotab = {},{}
    local f = io.open(name,"rt")
    
    --is the file actually there?
    if f == nil then return nil,"file not found" end
    
    --iterate through the file
    for str in f:lines() do
        --try to split the line into fields
        ib,ie,ia,_,co,cou,coun = 
                str:match('"(%d+),""(%d+)"",""(%l+)"",""(%d+)"",""(%u%u)"",""(%u%u%u?)"",""(.*)"""')
        --check that it was a well-formed line
        if ib == nil or ie == nil or co == nil then
            --unparseable lines are ignored unless they start with '"'
            --this prevents new-format lines getting ignored for ever
            --note we must skip lines where co=nil lest we return it
            if str:sub(1,1) == '"' then return nil,"bad line in file",str end
        else
            --parseable lines belong in the table
            ibn, ien = tonumber(ib), tonumber(ie)
            if ibn <= last or ien < ibn then
                --don't accept this record if it's out-of-order
                --(see comments above about repeated ranges in real data)
                if strict then return nil,"ip data out of order" end
            else
                --if this record doesn't follow on from the last, fill the 'gap'
                if ibn ~= last+1 then
                    iptab[#iptab+1] = last+1
                    cotab[#cotab+1] = "-- UNALLOCATED"
                end
                --and add this record to the (sorted) lists 
                --note: lua internalises strings so the regular repetition
                --of common country names doesn't waste memory
                iptab[#iptab+1] = ibn
                cotab[#cotab+1] = co..' '..coun
                last = ien
            end
        end
    end    
    
    --add a catchall record (doesn't matter if out of 32-bit range)
    iptab[#iptab+1] = last+1
    cotab[#cotab+1] = "-- UNALLOCATED"
    
    self.iptab, self.cotab = iptab, cotab
    return self
end

function webnet:lookup(ip)
	 --validate and convert the ip parameter
    if type(ip) == 'number' then 
       if ip<0 or ip>=2^32 then return nil,"bad ip number" end
    elseif type(ip) == 'string' then
       local a,b,c,d = ip:match('(%d+).(%d+).(%d+).(%d+)')
       if a==nil or b==nil or c==nil or d==nil then return nil, "bad ip string" end
       a,b,c,d = a+0,b+0,c+0,d+0
       if a<0 or b<0 or c<0 or d<0 then return nil,"bad ip string" end
       if a>255 or b>255 or c>255 or d>255 then return nil,"bad ip string" end
       ip = a*2^24 + b*2^16 + c*2^8 + d
    else
       return nil, "bad ip parameter"
    end
    
    --check that ip number is inside our table's coverage
    local bot,top = 1,#self.iptab
    if ip <  self.iptab[bot] then return "--","UNALLOCATED" end
    if ip >= self.iptab[top] then return "--","UNALLOCATED" end
    
    --now binary chop the table until we find the country
    --this should never take more than log-base-2(tablesize) chops
    --lap and lim are there just in case, to ensure no infinite loops
    local lap,lim = 0,(math.log(#self.iptab)/math.log(2))*1.5
    repeat
        lap = lap+1
        local mid = bot + math.floor((top-bot)/2)
        --see if we've found the answer
        if ip >= self.iptab[mid] and ip < self.iptab[mid+1] then
            return self.cotab[mid]:match('(%C%C) (.*)')
        end
        --if not, chop off the half it can't be in
        if ip < self.iptab[mid] then top = mid else bot = mid+1 end
    until bot >= top or lap > lim
    
    --this isn't supposed to happen unless the table is corrupt
    return nil,"lookup error"
end