set val(chan) Channel/WirelessChannel
set val(prop) Propagation/TwoRayGround
set val(netif) Phy/WirelessPhy
set val(mac) Mac/802_11
set val(ifq) Queue/DropTail/PriQueue
set val(ll) LL
set val(ant) Antenna/OmniAntenna
set val(ifqlen) 50
set val(nn) 2
set val(rp) DSDV
set val(x) 500
set val(y) 400
set val(stop) 20

set ns_ [new Simulator]

set tf [open sudhir6.tr w]
$ns_ trace-all $tf

set nf [open sudhir6.nam w]
$ns_ namtrace-all-wireless $nf $val(x) $val(y)

set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

set god_ [create-god $val(nn)]

$ns_ node-config -adhocRouting $val(rp) \
                -llType $val(ll) \
                -macType $val(mac) \
                -ifqType $val(ifq) \
                -ifqLen $val(ifqlen) \
                -antType $val(ant) \
                -propType $val(prop) \
                -phyType $val(netif) \
                -channelType $val(chan) \
                -topoInstance $topo \
                -agentTrace ON \
                -routerTrace ON \
                -macTrace ON
for {set i 0} {$i<$val(nn)} {incr i} {
set node_($i) [$ns_ node]
#$node_($i) random_motion 0
}

for {set i 0} {$i<$val(nn)} {incr i} {
$ns_ initial_node_pos $node_($i) 40
}

$ns_ at 10.0 "$node_(0) setdest 250.0 250.0 3.0"
$ns_ at 30.0 "$node_(1) setdest 45.0 285.0 5.0"

set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]
$ns_ attach-agent $node_(0) $tcp
$ns_ attach-agent $node_(1) $sink
$ns_ connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns_ at 1.0 "$ftp start"
$ns_ at 10.0 "$ftp stop"

for {set i 0} {$i<$val(nn)} {incr i} {
$ns_ at $val(stop) "$node_($i) reset"
}

$ns_ at $val(stop) "puts \"NS EXITING.....\"; $ns_ halt"
puts "Starting Simulation..."
$ns_ run





