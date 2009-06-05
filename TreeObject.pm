package TreeObject;

use FileHandle;
use warnings;
use strict;
use Carp;
require XML::Parser;


sub new {
	defined ( my $class = shift(@_) ) or croak "incorrect call";
	defined ( my $xml = shift(@_) ) or croak "incorrect call";
	return bless { xml => $xml },$class;
}

sub xml {
	return $_[0]->{xml};
}

sub name {
	return $_[0]->xml->[0];
}

sub content {
	return $_[0]->xml->[1];
}

sub attributes {
	return $_[0]->content->[0];
}
	

sub elements {
	defined ( my $self = shift(@_) ) or croak "incorrect call";
	defined ( my $element = shift(@_) ) or croak "incorrect call";	

	my @temp = @{$self->content};

	my @bag;

	shift(@temp); #discard the first element which is the attributes hash
	while ( defined ( my $name  = shift(@temp) ) ) {
		my $rest = shift(@temp);	
		#print STDERR "DEBUG: name=$name \n";
		if ($name eq $element) {
			push @bag,(TreeObject->new([$name,$rest]));
		}
	}

	return @bag;
	
}

sub string {
	defined ( my $self = shift(@_) ) or croak "incorrect call";
	return join '',(map { $_->content } $self->elements("0"));
}

sub element {
	my @result = elements(@_);
	carp "Warning: more than one $_[1] items" unless(@result == 1);
	return $result[0];
}

1;
