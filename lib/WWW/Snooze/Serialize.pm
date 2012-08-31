package WWW::Snooze::Serialize;

use strict;
use warnings;

sub new {
    my $class = shift;
    my %args = @_;

    bless {
        extension => '',
        content_type => '',
        %args
    }, $class;
}

sub encode { return {}; }
sub decode { return {}; }

sub content_type { shift->{content_type}; }

sub extension {
    my $ext = shift->{extension};
    $ext =~ s/^(\w+)$/.$1/;
    return $ext;
}

1;
