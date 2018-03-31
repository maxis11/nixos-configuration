# If running trom tty1 start sway
if [ (tty) = "/dev/tty1" ] 
	sway > ~/.config/sway/sway.log 2>&1
	exit 0
end
