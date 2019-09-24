proc compare {a b} {
    #lsort -command compare {{15 15 2} {2.6 2.6 1} {2.6 2.6 3}} # => {{2.6 2.6 1} {2.6 2.6 3} {15 15 2}}
    set a0 [lindex $a 0]
    set b0 [lindex $b 0]
    if {$a0 < $b0} {
        return -1
    } elseif {$a0 > $b0} {
        return 1
    }
    if {[llength $a] > 0} {
        return [compare [lrange $a 1 end] [lrange $b 1 end]]
    }
    return [string compare [lindex $a 1] [lindex $b 1]]
}

proc compare_round {a b} {
    #lsort -command compare_round {{15 15 2} {2.6 2.7 1} {2.6 2.6 3}} # => {{2.6 2.7 1} {2.6 2.6 3} {15 15 2}}
    set precision 0
    proc round {value {decimalplaces 0}} {
        return [expr {round(10.0**$decimalplaces*$value)/10.0**$decimalplaces}]
    }
    set a0 [round [lindex $a 0] $precision]
    set b0 [round [lindex $b 0] $precision]
    if {$a0 < $b0} {
        return -1
    } elseif {$a0 > $b0} {
        return 1
    }
    if {[llength $a] > 0} {
        return [compare [lrange $a 1 end] [lrange $b 1 end]]
    }
    return [string compare [lindex $a 1] [lindex $b 1]]
}
