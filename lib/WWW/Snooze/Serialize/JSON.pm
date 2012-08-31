package WWW::Snooze::Serialize::JSON;

use base 'WWW::Snooze::Serialize';

use strict;
use warnings;

sub new {
    my $class = shift;
    my %args = @_;

    bless {
        extension => 'json',
        mime => 'application/json',
        %args
    }, $class;
}

sub encode {
    my ($self, $input) = @_;
    my $output = JSON->new->allow_nonref->encode($input);
    return $output;
}

sub decode {
    my ($self, $input) = @_;
    my $output = JSON->new->allow_nonref->decode($input);
    return $output;
}

1;
