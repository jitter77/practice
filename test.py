import sh

test=sh.ifconfig
check=(sh.ifconfig(sh.grep('inet'))
print (check)
#for zeile in check
#       #sh.grep ('inet') 
#       print (zeile)
