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
=head1 NAME

WWW::Snooze::Serialize - Base object for building serializers

=head1 METHODS


=head2 new(%args)

=over 4

=item C<extension>

Set filename extension

=item C<content_type>

Set MIME type on request

=back


=head2 C<encode()>

=head2 C<decode()>

Functions for overriding encoding and decoding of request/response data


=head2 C<extension()>

Return the extension, prepended with '.'


=head1 AUTHOR

Anthony Johnson E<lt>aj@ohess.orgE<gt>

=cut
