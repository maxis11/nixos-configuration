# If running trom tty1 start sway
if [ (tty) = "/dev/tty1" ] 
	if [ $SWAY_DEBUG = "false" ]
		sway > ~/.config/sway/sway.log 2>&1
	else
		sway -d > ~/.config/sway/sway.log 2>&1
	end
	exit 0
end
