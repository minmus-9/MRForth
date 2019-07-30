########################################################################
### demo.tcl -- mrforth tcl embedding demo
###

load mrforthtcl.dll Mrforth

########################################################################
### create gui
set ff {Courier 12}
set cc 80
set rr 25
set ww [expr [font measure $ff M] * $cc]
set hh [expr [font metrics $ff -linespace] * $rr]
canvas .c -width $ww -height $hh -bd 0 -highlightthickness 0 -bg black
pack .c
bind .c <Enter> {focus .c}
update
focus .c

set txtid [.c create text 0 0 -fill green -anchor nw -justify left -font $ff]

proc gettext {} {
    global txtid
    return [.c itemcget $txtid -text]
}

proc settext s {
    global txtid
    .c itemconfigure $txtid -text $s
}

########################################################################
### mrforth kbd queue
set mrf_key_queue {}
set mrf_yield 0

proc mrf_forth_key {} {
    global mrf_key_queue
    if {![string length $mrf_key_queue]} {
	return ""
    }
    set ret [string index $mrf_key_queue 0]
    set mrf_key_queue [string range $mrf_key_queue 1 end]
    return $ret
}

proc mrf_queue_key {c} {
    global mrf_key_queue
    global mrf_yield

    if {![string length $c]} {
        return
    }
    if {[string length $mrf_key_queue] > 32} {
        return
    }
    append mrf_key_queue $c
    if {$mrf_yield} { periodic }
}

bind .c <KeyPress> { mrf_queue_key %A }

### redefine (key) to read from the tcl queue
mrforth eval {
: tclkey
  begin
    [ '(key) @ , ]
    dup 0 = while
      drop yield
  repeat
  dup emit
;

' tclkey '(key) !
}

########################################################################
### mrforth output

set fb {}

proc ufb {} {
    global fb
    settext [join $fb "\n"]
}

proc emit c {
    global cc rr fb

    if {![string compare $c "\n"]} {
	lappend fb {}
    } elseif {![string compare $c "\x08"]} {
	set l [lindex $fb end]
	set fb [lreplace $fb end end [string range $l 0 end-1]]
    } else {
	set l [lindex $fb end]
	if {[string length $l] == $cc} {
	    lappend fb $c
	} else {
	    append l $c
	    set fb [lreplace $fb end end $l]
	}
    }
    if {[llength $fb] > $rr} {
	set fb [lreplace $fb 0 0]
    }
    ufb
}

proc mrf_forth_emit c {
    emit [binary format c $c]
}

proc xmrf_forth_emit c {
    global ascii
    puts -nonewline [binary format c $c]
}

########################################################################
### run forth periodically

proc forth {} { return [mrforth run 65535] }

set mrf_update 1
set mrf_quit 0

proc periodic {} {
    global mrf_update
    global mrf_quit
    global mrf_yield

    set mrf_yield 0
    if {[set rc [forth]]} {
	if {$rc == 32768} {
	    set mrf_yield 1
	    return
	}
	puts stderr "FORTH error $rc"
	set mrf_quit 1
    }
    if {!$mrf_quit} {
	after $mrf_update periodic
    } else {
	set mrf_quit 0
	console show
	puts "stopping mrforth -- type \"restart\" to restart mrforth"
    }
}

proc restart {} {
    mrforth init
    periodic
}

restart
#console show

### EOF

