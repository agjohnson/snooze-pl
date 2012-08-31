package WWW::Snooze;

use strict;
use warnings;

our $VERSION = '0.01_01';

use WWW::Snooze::Request;
use Data::Dumper;

sub request {
    WWW::Snooze::Request->new(@_);
}

1;
