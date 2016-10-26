#!/usr/bin/env perl

use strict;
use warnings;
use Device::Gsm;
use Config::Simple;
use v5.10;

my $action = shift;
my $device = shift;

my $config = $0 =~ s/\.pl$/\.ini/r;

my $cfg = new Config::Simple($config);

if ($action eq "CREATE") {
    
    my $gsm = Device::Gsm->new(port => '/dev/' . $device);
    
    $gsm->connect(baudrate => 9600) || die "no conecta\n";
    
    my $imei = $gsm->imei;
    
    chdir '/dev';
    
    my $name = $cfg->param($imei);
    
    system("ln -s  $device $name");
    
}


if ($action eq "DESTROY") {
    
    chdir '/dev';
    
    for (values %{$cfg->vars}) {
	system("rm $_") unless stat($device);
    }
}

