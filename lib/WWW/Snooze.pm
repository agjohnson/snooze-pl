package WWW::Snooze;

use strict;
use warnings;

our $VERSION = '0.01_01';

use WWW::Snooze::Request;

sub request {
    WWW::Snooze::Request->new(@_);
}

1;
=head1 NAME

WWW::Snooze - Simple RESTful API

=head1 SYNOPSIS

Using HTTP::Headers to override pieces of the request, REST operations can be
performed like so:

    use WWW::Snooze;
    use WWW::Snooze::Serialize::JSON;
    use HTTP::Headers;
    use Data::Dumper;

    my $api = WWW::Snooze::request(
        'https://agilezen.com/api/v1',
        headers => HTTP::Headers->new(
            'X-Zen-ApiKey' => 'key'
        ),
        serializer => WWW::Snooze::Serialize::JSON->new(
            extension => ''
        )
    );

    my $tasks = $api->projects(40075)->stories;
    print Dumper($tasks->get());

    my $hdr = HTTP::Headers->new();
    $hdr->authorization_basic('key', '');
    my $chili = WWW::Snooze::request(
        'http://chili.example.com',
        headers => $hdr,
    );
    print Dumper($chili->issues(undef, limit => 1)->get());

=head1 METHODS

=head2 request

Returns an instance of L<WWW::Snooze::Request>

=back

=head1 AUTHOR

Anthony Johnson E<lt>aj@ohess.orgE<gt>

=cut
