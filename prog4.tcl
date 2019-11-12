set ns [new Simulator]
set fin [open pg4.tr w]
$ns trace-all $fin
set nfin [open pg4.nam w]
$ns namtrace-all $nfin

set s [$ns node]
set c [$ns node]
$s label "server"
$c label "client"
$ns duplex-link $s $c 10Mb 22ms DropTail 

#create TCP agent
set tcp0 [new Agent/TCP]
$ns attach-agent $s $tcp0
$tcp0 set packetSize_ 1500
#create TCPSink
set tcp1 [new Agent/TCPSink]
$ns attach-agent $c $tcp1
$ns connect $tcp0 $tcp1
#ftp object and connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp0

#schedule
$ns at 0.1 "$ftp start"
$ns at 2.1 "$ftp stop"
proc finish {} {
global ns fin nfin
$ns flush-trace 
close $nfin
close $fin
exec nam pg4.nam &
exec awk -f pg4_1.awk pg4.tr &
exec awk -f pg4_1.awk pg4.tr > pg4_1.tr
exec xgraph pg4_1.tr &
exit 0
}
$ns at 2.2 "finish"
$ns run

