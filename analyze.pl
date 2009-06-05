#!/usr/bin/perl -w

use warnings;
use strict;
use Carp;
use Data::Dumper;
use lib ".";
use TreeObject;

my $slurp = do { local $/; <> };

$slurp =~ s/^\s+//g;

my $xml = XML::Parser->new(Style => 'Tree')->parse($slurp);
#my $slurp = do { local $/; <> };

my $t = TreeObject->new($xml);

my %av = ();

for my $item ($t->elements("saml:Attribute")) {
	my $name = defined($item->attributes->{FriendlyName})? $item->attributes->{FriendlyName} : $item->attributes->{AttributeName};
	$name =~ s/^urn:mace:dir:attribute-def://;
	$name =~ s/^urn:oid://;
	for my $value ($item->elements("saml:AttributeValue")) {
		$av{$name} = $value->string;
		$av{$name} =~ s/^\s+//;
		$av{$name} =~ s/\s+$//;
	}
}


for (sort keys %av) {
	print "\t$_ = $av{$_} \n";
}

