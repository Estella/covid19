#######################################################################################################
## ccovid19.tcl 1.1  (23/03/2020)          Copyright 2008 - 2020 @ WwW.TCLScripts.NET                ##
##                        _   _   _   _   _   _   _   _   _   _   _   _   _   _                      ##
##                       / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \                     ##
##                      ( T | C | L | S | C | R | I | P | T | S | . | N | E | T )                    ##
##                       \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/                     ##
##                                                                                                   ##
##                                      ® BLaCkShaDoW Production ®                                   ##
##                                                                                                   ##
##                                              PRESENTS                                             ##
##                                                                                                   ##
############################################  ccovid-19 TCL   #########################################
##                                                                                                   ## 
##  DESCRIPTION:                                                                                     ##
## Shows realtime stats about the COVID-19 CORONAVIRUS OUTBREAK. These are taken from the site       ##
##                                                                                                   ## 
## https://www.canada.ca/en/public-health/services/diseases/2019-novel-coronavirus-infection.html    ##
## by command and also auto if something changes from                                                ##
##                                                                                                   ## 
## the last information given. (RSS type)                                                            ##
##                                                                                                   ## 
##  Tested on Eggdrop v1.8.3 (Debian Linux 3.16.0-4-amd64) Tcl version: 8.6.10                       ##
##                                                                                                   ## 
#######################################################################################################
##                                                                                                   ## 
##                                 /===============================\                                 ##
##                                 |      This Space For Rent      |                                 ##
##                                 \===============================/                                 ##
##                                                                                                   ## 
#######################################################################################################
##                                                                                                   ## 
##  INSTALLATION:                                                                                    ##
##     ++ http package is REQUIRED for this script to work.                                          ##
##     ++ tls package is REQUIRED for this script to work. (1.7.18-2 or later)                       ##
##  latest tls https://ubuntu.pkgs.org/19.10/ubuntu-universe-amd64/tcl-tls_1.7.18-2_amd64.deb.html   ##
##     ++ Edit the Covid19.tcl script and place it into your /scripts directory,                     ##
##     ++ add "source scripts/ccovid19.tcl" to your eggdrop config and rehash the bot.               ##
##                                                                                                   ## 
#######################################################################################################
#######################################################################################################
##                                                                                                   ## 
##  OFFICIAL LINKS:                                                                                  ##
##   E-mail      : BLaCkShaDoW[at]tclscripts.net                                                     ##
##   Bugs report : http://www.tclscripts.net                                                         ##
##   GitHub page : https://github.com/tclscripts/                                                    ##
##   Online help : irc://irc.undernet.org/tcl-help                                                   ##
##                 #TCL-HELP / UnderNet                                                              ##
##                 You can ask in english or romanian                                                ##
##                                                                                                   ## 
##     paypal.me/DanielVoipan = Please consider a donation. Thanks!                                  ##
##                                                                                                   ## 
#######################################################################################################
##                                                                                                   ## 
##                           You want a customised TCL Script for your eggdrop?                      ##
##                                Easy-peasy, just tell me what you need!                            ##
##                I can create almost anything in TCL based on your ideas and donations.             ##
##                  Email blackshadow@tclscripts.net or info@tclscripts.net with your                ##
##                    request informations and I'll contact you as soon as possible.                 ##
##                                                                                                   ## 
#######################################################################################################
##                                                                                                   ##
##  Version 1.1 -- If location isnt specificed it will show the total statistics                     ##
##                                                                                                   ## 
##  Commmands: !ccovid [location] - if not specified it will show the total statistics               ##
##                                                                                                   ## 
##                                                                                                   ##
##  Settings: .chanset/.set #chan +ccovid - enable the !ccovid <location> command                    ##
##                                                                                                   ## 
##                                                                                                   ##
##            .chanset/.set #chan +autoccovid - enable the auto message on timer if the              ##
##             information changes (like RSS feed)                                                   ##
##                                                                                                   ## 
##            .chanset/.set #chan ccovid-location [your location] - setup the default location       ##
##            for the Covid19 RSS (auto show information)                                            ##
##                                                                                                   ## 
##                                                                                                   ##
#######################################################################################################
#######################################################################################################
##                                                                                                   ##
##  LICENSE:                                                                                         ##
##   This code comes with ABSOLUTELY NO WARRANTY.                                                    ##
##                                                                                                   ##
##   This program is free software; you can redistribute it and/or modify it under the terms of      ##
##   the GNU General Public License version 3 as published by the Free Software Foundation.          ##
##                                                                                                   ##
##   This program is distributed WITHOUT ANY WARRANTY; without even the implied warranty of          ##
##   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                                            ##
##   USE AT YOUR OWN RISK.                                                                           ##
##                                                                                                   ##
##   See the GNU General Public License for more details.                                            ##
##        (http://www.gnu.org/copyleft/library.txt)                                                  ##
##                                                                                                   ##
##                  Copyright 2008 - 2018 @ WwW.TCLScripts.NET                                       ##
##                                                                                                   ##
#######################################################################################################
#######################################################################################################
##                                   CONFIGURATION FOR ccovid19.TCL                                  ##
#######################################################################################################


###
#Default location for corona virus checking uppon command or timer
#
set cacorona(location) "Alberta"

###
#Set script language (Ro/EN)
#
set cacorona(language) "en"


###
#Flags required to use !covid [location] command
#
set cacorona(flags) "nm|M"


###
# FLOOD PROTECTION
#Set the number of minute(s) to ignore flooders
###
set cacorona(ignore_prot) "1"

###
# FLOOD PROTECTION
#Set the number of requests within specifide number of seconds to trigger flood protection.
# By default, 4:10, which allows for upto 3 queries in 10 seconds. 4 or more quries in 10 seconds would cuase
# the forth and later queries to be ignored for the amount of time specifide above.
###
set cacorona(flood_prot) "5:10"

###
#COVID RSS (minutes)
#Set here the time for the script to check if the info changed 
#If the info changed it will be shown on chan
#only when the option is enabled with +autocovid
###
set cacorona(time_check) "60"

########################################################################################################

#Country list

set cacorona(location_list) {
"British Columbia"
"Alberta"
"Saskatchewan"
"Manitoba"
"Ontario"
"Quebec"
"New Brunswick"
"Nova Scotia"
"Prince Edward Island"
"Newfoundland and Labrador"
"Yukon"
"Northwest Territories"
"Nunavut"
"Repatriated travellers"
}

###############################################################################################################
#
#     Try to edit only the language :-)
#
###############################################################################################################

package require tls
package require http

bind pub $cacorona(flags) !ccovid cacorona:pub

setudef flag ccovid
setudef flag autoccovid

setudef str ccovid-location
setudef str ccovid-lang


###
if {![info exists cacorona(timer_start)]} {
  timer $cacorona(time_check) cacorona:auto_timer
  set cacorona(timer_start) 1
}

###
proc cacorona:auto_timer {} {
  global cacorona
  set channels ""
foreach chan [channels] {
  if {[channel get $chan autoccovid] && [validchan $chan]} {
  lappend channels $chan
    }
  }
if {$channels != ""} {
  set data [cacorona:getdata]
  cacorona:auto_check $data $channels 0
  } else {
  timer $cacorona(time_check) cacorona:auto_timer
  }
}

###
proc cacorona:auto_check {data channels num} {
  global cacorona
  set chan [lindex $channels $num]
  set location [join [channel get $chan ccovid-location]]
if {$location == ""} { set location $cacorona(location) }
  set extract [cacorona:extract $data $location 0]
  set total_cases [lindex $extract 0]
  set new_cases [lindex $extract 1]
  set total_deaths [lindex $extract 2]

if {[info exists cacorona($chan:autocovid:entry)]} {
if {$cacorona($chan:autocovid:entry) != $extract} {
  set cacorona($chan:autocovid:entry) $extract
  cacorona:say "" $chan [list $location $total_cases $new_cases $total_deaths $new_deaths $total_recovered $active_cases $serious_critical $totalcases_per_milion] 4
  }
} else {
  set cacorona($chan:autocovid:entry) $extract
  cacorona:say "" $chan [list $location $total_cases $new_cases $total_deaths $new_deaths $total_recovered $active_cases $serious_critical $totalcases_per_milion] 4
  }
  set next_num [expr $num + 1]
if {[lindex $channels $next_num] != ""} {
  utimer 5 [list cacorona:auto_check $data $channels $next_num]
  } else {
  timer $cacorona(time_check) cacorona:auto_timer
  }
}


proc random_int limit {
    expr {int(rand() * $limit +1)}
}
###
proc cacorona:getdata {} {
  set rnd [random_int 9999999]
  set link "https://estel.la/ccovid.php?rnd=$rnd"
  http::register https 443 [list ::tls::socket -request 1 -require 0 -autoservername 1 -tls1.2 1]
  set ipq [http::config -useragent "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.3) Gecko/20100401 Firefox/3.6.3"]
  set ipq [::http::geturl "$link"] 
  set data [http::data $ipq]
  ::http::cleanup $ipq
  return $data
}

###
proc cacorona:pub {nick host hand chan arg} {
  global cacorona
if {![channel get $chan covid]} {
  return
}
  set total 0
  set flood_protect [cacorona:flood:prot $chan $host]
if {$flood_protect == "1"} {
  set get_seconds [cacorona:get:flood_time $host $chan]
  cacorona:say $nick "NOTC" [list $get_seconds] 2
  return
}
  set location [join [lrange [split $arg] 0 end]]
if {$location == ""} {
  set total 1
  set location "Total"
} else {
  set find_location [lsearch -nocase $cacorona(location_list) $location]
if {$find_location < 0} {
  cacorona:say $nick $chan "" 1
  return
} else {
  set location [lindex $cacorona(location_list) $find_location]
  }
}
  set data [cacorona:getdata]
  set extract [cacorona:extract $data $location $total]
  set total_cases [lindex $extract 0]
  set new_cases [lindex $extract 1]
  set total_deaths [lindex $extract 2]
  cacorona:say $nick $chan [list $location $total_cases $new_cases $total_deaths ] 3
}


###
proc cacorona:extract {data location total} {
  global cacorona
  set var "${location}_START(.*)${location}_END"
  regexp -nocase $var $data text
  set split_text [split $text ","]
  set total_cases [lindex $split_text 1]
  set new_cases [lindex $split_text 2]
  set total_deaths [lindex $split_text 3]
  return [list $total_cases $new_cases $total_deaths]
}

###
proc cacorona:flood:prot {chan host} {
  global cacorona
  set number [scan $cacorona(flood_prot) %\[^:\]]
  set timer [scan $cacorona(flood_prot) %*\[^:\]:%s]
if {[info exists cacorona(flood:$host:$chan:act)]} {
  return 1
}
foreach tmr [utimers] {
if {[string match "*cacorona:remove:flood $host $chan*" [join [lindex $tmr 1]]]} {
  killutimer [lindex $tmr 2]
  }
}
if {![info exists cacorona(flood:$host:$chan)]} { 
  set cacorona(flood:$host:$chan) 0 
}
  incr cacorona(flood:$host:$chan)
  utimer $timer [list cacorona:remove:flood $host $chan]  
if {$cacorona(flood:$host:$chan) > $number} {
  set cacorona(flood:$host:$chan:act) 1
  utimer 60 [list cacorona:expire:flood $host $chan]
  return 1
  } else {
  return 0
  }
}

###
proc cacorona:expire:flood {host chan} {
  global cacorona
if {[info exists cacorona(flood:$host:$chan:act)]} {
  unset cacorona(flood:$host:$chan:act)
  }
}

###
proc cacorona:remove:flood {host chan} {
  global cacorona
if {[info exists cacorona(flood:$host:$chan)]} {
  unset cacorona(flood:$host:$chan)
  }
}

###
proc cacorona:get:flood_time {host chan} {
  global cacorona
    foreach tmr [utimers] {
if {[string match "*cacorona:expire:flood $host $chan*" [join [lindex $tmr 1]]]} {
  return [lindex $tmr 0]
    }
  }
}

###
proc cacorona:say {nick chan arg num} {
  global cacorona
  set inc 0
  set get_lang [string tolower [channel get $chan ccovid-lang]]
if {$get_lang == ""} {
  set lang [string tolower $cacorona(language)]
} else {
if {[info exists cacorona($get_lang.lang.1)]} {
  set lang $get_lang
  } else {
  set lang [string tolower $cacorona(language)]
  }
}
foreach s $arg {
  set inc [expr $inc + 1]
  set replace(%msg.$inc%) $s
}
  set reply [string map [array get replace] $cacorona($lang.lang.$num)]
if {$chan == "NOTC"} {
  putserv "NOTICE $nick :$reply"
} else {
  putserv "PRIVMSG $chan :$reply"
  }
}


set cacorona(name) "ccovid-19"
set cacorona(owner) "BLaCkShaDoW"
set cacorona(site) "WwW.TclScripts.Net"
set cacorona(version) "1.1"

####
#Language
#
###

set cacorona(en.lang.1) "Invalid location specified"
set cacorona(en.lang.2) "You exceded the number of commands. Please wait %msg.1% seconds."
set cacorona(en.lang.3) "\002COVID-19\002 stats for -- %msg.1% -- Number of confirmed cases: \00307\002%msg.2%\002\003 ; Number of probable cases: \00308\002%msg.3%\002\003 ; Number of deaths: \00304\002%msg.4%\002\003"
set cacorona(en.lang.4) "\002COVID-19 (Update)\002 stats for -- %msg.1% -- Number of confirmed cases: \00307\002%msg.2%\002\003 ; Number of probable cases: \00308\002%msg.3%\002\003 ; Number of deaths: \00304\002%msg.4%\002\003"

putlog "$cacorona(name) $cacorona(version) TCL by $cacorona(owner) loaded. For more tcls visit -- $cacorona(site) --"
