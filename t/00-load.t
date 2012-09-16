#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'WWW::Snooze' ) || print "Bail out!\n";
}

diag( "Testing WWW::Snooze $WWW::Snooze::VERSION, Perl $], $^X" );
