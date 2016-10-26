#!/usr/bin/env perl

use strict;
use warnings;
use Device::Gsm;
use Config::Simple;
use feature qw/say switch/;

my $action = shift;
my $device = shift;

my $cfg = new Config::Simple('linker.ini');

my %table = $cfg->vars;

given ($action) {
    
    when ("CREATE") {
    
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

