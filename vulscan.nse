description = [[

INTRODUCTION

Vulscan is a module which enhances nmap to a vulnerability scanner. The
nmap option -sV enables version detection per service which is used to
determine potential flaws according to the identified product. The data
is looked up in an offline version of VulDB.

INSTALLATION

Please install the files into the following folder of your Nmap
installation:

   Nmap\scripts\vulscan\*

USAGE

You have to run the following minimal command to initiate a simple
vulnerability scan:

   nmap -sV --script=vulscan/vulscan.nse www.example.com

VULNERABILITY DATABASE

There are the following pre-installed databases available at the
moment:

   scipvuldb.csv       | https://vuldb.com
   cve.csv             | https://cve.mitre.org
   securityfocus.csv   | https://www.securityfocus.com/bid/
   xforce.csv          | https://exchange.xforce.ibmcloud.com/
   expliotdb.csv       | https://www.exploit-db.com
   openvas.csv         | http://www.openvas.org
   securitytracker.csv | https://www.securitytracker.com (end-of-life)
   osvdb.csv           | http://www.osvdb.org (end-of-life)

SINGLE DATABASE MODE

You may execute vulscan with the following argument to use a single
database:

   --script-args vulscandb=your_own_database

It is also possible to create and reference your own databases. This
requires to create a database file, which has the following structure:

   <id>;<title>

Just execute vulscan like you would by refering to one of the pre-
delivered databases. Feel free to share your own database and
vulnerability connection with me, to add it to the official
repository.

UPDATE DATABASE

The vulnerability databases are updated and assembled on a regularly
basis. To support the latest disclosed vulnerabilities, keep your local
vulnerability databases up-to-date.

If you want to update your databases, go to the following web site and
download these files:

   https://www.computec.ch/mruef/software/nmap_nse_vulscan/cve.csv
   https://www.computec.ch/mruef/software/nmap_nse_vulscan/exploitdb.csv
   https://www.computec.ch/mruef/software/nmap_nse_vulscan/openvas.csv
   https://www.computec.ch/mruef/software/nmap_nse_vulscan/osvdb.csv
   https://www.computec.ch/mruef/software/nmap_nse_vulscan/scipvuldb.csv
   https://www.computec.ch/mruef/software/nmap_nse_vulscan/securityfocus.csv
   https://www.computec.ch/mruef/software/nmap_nse_vulscan/securitytracker.csv
   https://www.computec.ch/mruef/software/nmap_nse_vulscan/xforce.csv

Copy the files into your vulscan folder:

   /vulscan/

Clone the GitHub repository like this:

   git clone https://github.com/scipag/vulscan scipag_vulscan
   ln -s `pwd`/scipag_vulscan /usr/share/nmap/scripts/vulscan    

VERSION DETECTION

If the version detection was able to identify the software version and
the vulnerability database is providing such details, also this data
is matched.

Disabling this feature might introduce false-positive but might also
eliminate false-negatives and increase performance slighty. If you want
to disable additional version matching, use the following argument:

   --script-args vulscanversiondetection=0

Version detection of vulscan is only as good as Nmap version detection
and the vulnerability database entries are. Some databases do not
provide conclusive version information, which may lead to a lot of
false-positives (as can be seen for Apache servers).

MATCH PRIORITY

The script is trying to identify the best matches only. If no positive
match could been found, the best possible match (with might be a false-
positive) is put on display.

If you want to show all matches, which might introduce a lot of false-
positives but might be useful for further investigation, use the
following argument:

   --script-args vulscanshowall=1

INTERACTIVE MODE

The interactive mode helps you to override version detection results
for every port. Use the following argument to enable the interactive
mode:

   --script-args vulscaninteractive=1

REPORTING

All matching results are printed one by line. The default layout for
this is:

   [{id}] {title}\n

It is possible to use another pre-defined report structure with the
following argument:

   --script-args vulscanoutput=details
   --script-args vulscanoutput=listid
   --script-args vulscanoutput=listlink
   --script-args vulscanoutput=listtitle

You may enforce your own report structure by using the following
argument (some examples):

   --script-args vulscanoutput='{link}\n{title}\n\n'
   --script-args vulscanoutput='ID: {id} - Title: {title} ({matches})\n'
   --script-args vulscanoutput='{id} | {product} | {version}\n'

Supported are the following elements for a dynamic report template:

   {id}      ID of the vulnerability
   {title}   Title of the vulnerability
   {matches} Count of matches
   {product} Matched product string(s)
   {version} Matched version string(s)
   {link}    Link to the vulnerability database entry
   \n        Newline
   \t        Tab

Every default database comes with an url and a link, which is used
during the scanning and might be accessed as {link} within the
customized report template. To use custom database links, use the
following argument:

   --script-args "vulscandblink=http://example.org/{id}"

DISCLAIMER

Keep in mind that this kind of derivative vulnerability scanning
heavily relies on the confidence of the version detection of nmap, the
amount of documented vulnerebilities and the accuracy of pattern
matching. The existence of potential flaws is not verified with
additional scanning nor exploiting techniques.

LINKS

Download: https://www.computec.ch/mruef/?s=software&l=x

]]

--@output
-- PORT   STATE SERVICE REASON  VERSION
-- 25/tcp open  smtp    syn-ack Exim smtpd 4.69
-- | osvdb (22 findings):
-- | [2440] qmailadmin autorespond Multiple Variable Remote Overflow
-- | [3538] qmail Long SMTP Session DoS
-- | [5850] qmail RCPT TO Command Remote Overflow DoS
-- | [14176] MasqMail Piped Aliases Privilege Escalation

--@changelog
-- v2.2 | 09/20/2019 | Marc Ruef | Fixed support for Nmap 7.80 onwards
-- v2.1 | 04/17/2019 | Marc Ruef | Minor fixes
-- v2.0 | 08/14/2013 | Marc Ruef | Considering version data
-- v1.0 | 06/18/2013 | Marc Ruef | Dynamic report structures
-- v0.8 | 06/17/2013 | Marc Ruef | Multi-database support
-- v0.7 | 06/14/2013 | Marc Ruef | Complete re-write of search engine
-- v0.6 | 05/22/2010 | Marc Ruef | Added interactive mode for guided testing
-- v0.5 | 05/21/2010 | Marc Ruef | Seperate functions for search engine
-- v0.4 | 05/20/2010 | Marc Ruef | Tweaked analysis modules
-- v0.3 | 05/19/2010 | Marc Ruef | Fuzzy search for product names included
-- v0.2 | 05/18/2010 | Marc Ruef | Uniqueness of found vulnerabilities
-- v0.1 | 05/17/2010 | Marc Ruef | First alpha running basic identification

--@bugs
-- Fuzzy search is sometimes catching wrong products

--@todos
-- Create product lookup table to match nmap<->db
-- Enhance nmap/db to be CPE compliant (https://cpe.mitre.org)
-- Display of identification confidence (e.g. +full_match, -partial_match)
-- Add auto-update feature for databases (download & install)

--@thanks
-- I would like to thank a number of people which supported me in
-- developing this script: Stefan Friedli, Simon Zumstein, Sean Rütschi,
-- Pascal Schaufelberger, David Fifield, Nabil Ouchn, Doggy Dog, Matt
-- Brown, Matthew Phillips, and Sebastian Brabetzl.

author = "Marc Ruef, marc.ruef-at-computec.ch, https://www.computec.ch/mruef/"
license = "Same as Nmap--See https://nmap.org/book/man-legal.html"
categories = {"default", "safe", "vuln"}

local stdnse = require("stdnse")
local have_stringaux, stringaux = pcall(require, "stringaux")
local strsplit = (have_stringaux and stringaux or stdnse).strsplit

portrule = function(host, port)
	if port.version.product ~= nil and port.version.product ~= "" then
		return true
	else
		stdnse.print_debug(1, "vulscan: No version detection data available. Analysis not possible.")
	end
end

action = function(host, port)
	local prod = port.version.product	-- product name
	local ver = port.version.version	-- product version
	local struct = "[{id}] {title}\n"	-- default report structure
	local db = {}				-- vulnerability database
	local db_link = ""			-- custom link for vulnerability databases
	local vul = {}				-- details for the vulnerability
	local v_count = 0			-- counter for the vulnerabilities
	local s = ""				-- the output string

	stdnse.print_debug(1, "vulscan: Found service " .. prod)

	-- Go into interactive mode
	if nmap.registry.args.vulscaninteractive == "1" then
		stdnse.print_debug(1, "vulscan: Enabling interactive mode ...")
		print("The scan has determined the following product:")
		print(prod)
		print("Press Enter to accept. Define new string to override.")
		local prod_override = io.stdin:read'*l'

		if string.len(prod_override) ~= 0 then
			prod = prod_override
			stdnse.print_debug(1, "vulscan: Product overwritten as " .. prod)
		end
	end

	-- Read custom report structure
	if nmap.registry.args.vulscanoutput ~= nil then
		if nmap.registry.args.vulscanoutput == "details" then
			struct = "[{id}] {title}\nMatches: {matches}, Prod: {product}, Ver: {version}\n{link}\n\n"
		elseif nmap.registry.args.vulscanoutput == "listid" then
			struct = "{id}\n"
		elseif nmap.registry.args.vulscanoutput == "listlink" then
			struct = "{link}\n"
		elseif nmap.registry.args.vulscanoutput == "listtitle" then
			struct = "{title}\n"
		else
			struct = nmap.registry.args.vulscanoutput
		end

		stdnse.print_debug(1, "vulscan: Custom output structure defined as " .. struct)
	end

	-- Read custom database link
	if nmap.registry.args.vulscandblink ~= nil then
		db_link = nmap.registry.args.vulscandblink
		stdnse.print_debug(1, "vulscan: Custom database link defined as " .. db_link)
	end

	if nmap.registry.args.vulscandb then
		stdnse.print_debug(1, "vulscan: Using single mode db " .. nmap.registry.args.vulscandb .. " ...")
		vul = find_vulnerabilities(prod, ver, nmap.registry.args.vulscandb)
		if #vul > 0 then
			s = s .. nmap.registry.args.vulscandb
			if db_link ~= "" then s = s .. " - " .. db_link end
			s = s .. ":\n" .. prepare_result(vul, struct, db_link) .. "\n\n"
		end
	else
		-- Add your own database, if you want to include it in the multi db mode
		db[1] = {name="VulDB",			file="scipvuldb.csv",		url="https://vuldb.com",			link="https://vuldb.com/id.{id}"}
		db[2] = {name="MITRE CVE",		file="cve.csv",			url="https://cve.mitre.org",			link="https://cve.mitre.org/cgi-bin/cvename.cgi?name={id}"}
		db[3] = {name="SecurityFocus",		file="securityfocus.csv",	url="https://www.securityfocus.com/bid/",	link="https://www.securityfocus.com/bid/{id}"}
		db[4] = {name="IBM X-Force",		file="xforce.csv",		url="https://exchange.xforce.ibmcloud.com",	link="https://exchange.xforce.ibmcloud.com/vulnerabilities/{id}"}
		db[5] = {name="Exploit-DB",		file="exploitdb.csv",		url="https://www.exploit-db.com",		link="https://www.exploit-db.com/exploits/{id}"}
		db[6] = {name="OpenVAS (Nessus)",	file="openvas.csv",		url="http://www.openvas.org",			link="https://www.tenable.com/plugins/nessus/{id}"}
		db[7] = {name="SecurityTracker",	file="securitytracker.csv",	url="https://www.securitytracker.com",		link="https://www.securitytracker.com/id/{id}"}
		db[8] = {name="OSVDB",			file="osvdb.csv",		url="http://www.osvdb.org",			link="http://www.osvdb.org/{id}"}

		stdnse.print_debug(1, "vulscan: Using multi db mode (" .. #db .. " databases) ...")
		for i,v in ipairs(db) do
			vul = find_vulnerabilities(prod, ver, v.file)

			s = s .. v.name .. " - " .. v.url .. ":\n"
			if #vul > 0 then
					v_count = v_count + #vul
					s = s .. prepare_result(vul, struct, v.link) .. "\n"
			else
					s = s .. "No findings\n\n"
			end

			stdnse.print_debug(1, "vulscan: " .. #vul .. " matches in " .. v.file)
		end

		stdnse.print_debug(1, "vulscan: " .. v_count .. " matches in total")
	end

	if s then
		return s
	end
end

-- Find the product matches in the vulnerability databases
function find_vulnerabilities(prod, ver, db)
	local v = {}			-- matching vulnerabilities
	local v_id			-- id of vulnerability
	local v_title			-- title of vulnerability
	local v_title_lower		-- title of vulnerability in lowercase for speedup
	local v_found			-- if a match could be found

	-- Load database
	local v_entries = read_from_file("scripts/vulscan/" .. db)

	-- Clean useless dataparts (speeds up search and improves accuracy)
	prod = string.gsub(prod, " httpd", "")
	prod = string.gsub(prod, " smtpd", "")
	prod = string.gsub(prod, " ftpd", "")

	local prod_words = strsplit(" ", prod)

	stdnse.print_debug(1, "vulscan: Starting search of " .. prod ..
		" in " .. db ..
		" (" .. #v_entries .. " entries) ...")

	-- Iterate through the vulnerabilities in the database
	for i=1, #v_entries, 1 do
		v_id		= extract_from_table(v_entries[i], 1, ";")
		v_title		= extract_from_table(v_entries[i], 2, ";")

		if type(v_title) == "string" then
			v_title_lower = string.lower(v_title)

			-- Find the matches for the database entry
			for j=1, #prod_words, 1 do
				v_found = string.find(v_title_lower, escape(string.lower(prod_words[j])), 1)
				if type(v_found) == "number" then
					if #v == 0 then
						-- Initiate table
						v[1] = {
							id		= v_id,
							title	= v_title,
							product	= prod_words[j],
							version	= "",
							matches	= 1
						}
					elseif v[#v].id ~= v_id then
						-- Create new entry
						v[#v+1] = {
							id		= v_id,
							title	= v_title,
							product	= prod_words[j],
							version	= "",
							matches	= 1
						}
					else
						-- Add to current entry
						v[#v].product = v[#v].product .. " " .. prod_words[j]
						v[#v].matches = v[#v].matches+1
					end

					stdnse.print_debug(2, "vulscan: Match v_id " .. v_id ..
						" -> v[" .. #v .. "] " ..
						"(" .. v[#v].matches .. " match) " ..
						"(Prod: " .. prod_words[j] .. ")")
				end
			end

			-- Additional version matching
			if nmap.registry.args.vulscanversiondetection ~= "0" and ver ~= nil and ver ~= "" then
				if v[#v] ~= nil and v[#v].id == v_id then
					for k=0, string.len(ver)-1, 1 do
						v_version = string.sub(ver, 1, string.len(ver)-k)
						v_found = string.find(string.lower(v_title), string.lower(" " .. v_version), 1)

						if type(v_found) == "number" then
							v[#v].version = v[#v].version .. v_version .. " "
							v[#v].matches = v[#v].matches+1

							stdnse.print_debug(2, "vulscan: Match v_id " .. v_id ..
								" -> v[" .. #v .. "] " ..
								"(" .. v[#v].matches .. " match) " ..
								"(Version: " .. v_version .. ")")
						end
					end
				end
			end
		end
	end

	return v
end

-- Prepare the resulting matches
function prepare_result(v, struct, link)
	local grace = 0				-- grace trigger
	local match_max = 0			-- counter for maximum matches
	local match_max_title = ""	-- title of the maximum match
	local s = ""				-- the output string

	-- Search the entries with the best matches
	if #v > 0 then
		-- Find maximum matches
		for i=1, #v, 1 do
			if v[i].matches > match_max then
				match_max = v[i].matches
				match_max_title = v[i].title
			end
		end

		stdnse.print_debug(2, "vulscan: Maximum matches of a finding are " ..
			match_max .. " (" .. match_max_title .. ")")

		if match_max > 0 then
			for matchpoints=match_max, 1, -1 do
				for i=1, #v, 1 do
					if v[i].matches == matchpoints then
						stdnse.print_debug(2, "vulscan: Setting up result id " .. i)
						s = s .. report_parsing(v[i], struct, link)
					end
				end

				if nmap.registry.args.vulscanshowall ~= "1" and s ~= "" then
					-- If the next iteration shall be approached (increases matches)
					if grace == 0 then
						stdnse.print_debug(2, "vulscan: Best matches found in 1st pass. Going to use 2nd pass ...")
						grace = grace+1
					elseif nmap.registry.args.vulscanshowall ~= "1" then
						break
					end
				end
			end
		end
	end

	return s
end

-- Parse the report output structure
function report_parsing(v, struct, link)
	local s = struct

	--database data (needs to be first)
	s = string.gsub(s, "{link}", escape(link))

	--layout elements (needs to be second)
	s = string.gsub(s, "\\n", "\n")
	s = string.gsub(s, "\\t", "\t")

	--vulnerability data (needs to be third)
	s = string.gsub(s, "{id}", escape(v.id))
	s = string.gsub(s, "{title}", escape(v.title))
	s = string.gsub(s, "{matches}", escape(v.matches))
	s = string.gsub(s, "{product}", escape(v.product))	
	s = string.gsub(s, "{version}", escape(v.version))

	return s
end

-- Get the row of a CSV file
function extract_from_table(line, col, del)
	local val = strsplit(del, line)

	if type(val[col]) == "string" then
		return val[col]
	end
end

-- Read a file
function read_from_file(file)
	local filepath = nmap.fetchfile(file)

	if filepath then
		local f, err, _ = io.open(filepath, "r")
		if not f then
			stdnse.print_debug(1, "vulscan: Failed to open file" .. file)
		end

		local line, ret = nil, {}
		while true do
			line = f:read()
			if not line then break end
			ret[#ret+1] = line
		end

		f:close()

		return ret
	else
		stdnse.print_debug(1, "vulscan: File " .. file .. " not found")
		return ""
	end
end

-- We don't like unescaped things
function escape(s)
	s = string.gsub(s, "%%", "%%%%")
	return s
end
