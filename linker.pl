#!/usr/bin/env perl

use strict;
use warnings;
use Device::Gsm;
use feature qw/say switch/;

my $action = shift;
my $device = shift;

my %table = (352224043125855 => 'digitel0',
	     352214041729642 => 'movilnet0');

given($action) {
    
    when("CREATE") {
    
	my $gsm = Device::Gsm->new(port => '/dev/' . $device);
	
	$gsm->connect(baudrate => 9600) || die "no conecta\n";
	
	my $imei = $gsm->imei;
	
	chdir '/dev';
	
	system("ln -s $device $table{$imei}");
	
    }

    when ("DESTROY") {
	
	chdir '/dev';
	
	for (values %table) {
	    system("rm $_") unless stat($device);
	}
    }
}

