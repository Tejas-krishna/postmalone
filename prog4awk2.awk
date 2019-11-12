BEGIN{
tcp_sz_r=0
time=$2
}
{
	if($5=="tcp" && $1 =="r" )
		tcp_sz_r += $6
		
		if($5=="tcp" && $1 =="r")
			time=$2
			printf ("%f %f\n",(tcp_sz_r/1000000),time)
}
END{
	printf ("%f %f",(tcp_sz_r/1000000),time)
}
