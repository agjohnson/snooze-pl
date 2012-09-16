package WWW::Snooze::Request;

use strict;
use warnings;
use 5.010;

use WWW::Snooze::Serialize::JSON;

use URI;
use LWP::UserAgent;
use JSON;

our $AUTOLOAD;

sub new {
    my $class = shift;
    my $uri = shift;
    my %args = @_;

    bless {
        base => $uri,
        parts => [],
        args => {},
        headers => undef,
        serializer => WWW::Snooze::Serialize::JSON->new(),
        %args
    }, $class;
}

sub AUTOLOAD {
    my $self = shift;
    my $name = $AUTOLOAD;
    $name =~ s/WWW::Snooze::Request:://;
    return $self->_add_element($name, @_);
}

sub DESTROY {}

sub _add_element {
    my $self = shift;
    my $name = shift;

    # TODO parse for multiple prototypes
    my $parts;
    push(@{$parts}, $name);
    my $arg = shift;
    push(@{$parts}, $arg) if ($arg);

    # TODO Combine argument hashes? It doesn't make sense to do:
    # $api->stories(100, owner => 'foo')->tasks(52, sort_by => 1)
    my %args = @_;

    return WWW::Snooze::Request->new(
        $self->{base},
        parts => [@{$self->{parts}}, @{$parts}],
        headers => $self->_headers,
        args => \%args,
        serializer => $self->_serializer
    );
}

# Private-ish functions to avoid namespace collisions
sub _serializer { shift->{serializer}; }
sub _headers { shift->{headers}; }
sub _args { shift->{args}; }

sub _build_url {
    my $self = shift;
    my $uri = URI->new($self->{base});

    my @parts = $uri->path_segments();
    push(@parts, @{$self->{parts}});

    # Add extension to last element
    if (my $ext = $self->_serializer->extension()) {
        my $last = pop @parts;
        $last .= $ext;
        push @parts, $last;
    }

    # Rebuild parts and query string
    $uri->path_segments(@parts);
    $uri->query_form($self->_args);

    return $uri->as_string();
}

sub _request {
    my $self = shift;
    my $method = shift;
    my $data = shift;

    die 'Bad HTTP request method'
      unless (grep($_ eq $method, (qw/GET POST PUT DELETE/)));

    my $h = LWP::UserAgent->new();
    $h->agent(
        sprintf(
            'Snooze/%s',
            $WWW::Snooze::VERSION
        )
    );

    my $req = HTTP::Request->new(
        $method,
        $self->_build_url,
        $self->_headers
    );
    $req->content_type($self->_serializer->content_type());

    # Set content if available
    if (ref $data eq 'HASH') {
        $req->content(
            $self->_serializer->encode($data)
        );
    }
    return $h->request($req);
}

sub get {
    my $self = shift;
    my $res = $self->_request('GET', @_);
    given ($res->code) {
        when (200) {
            return $self->_serializer->decode(
                $res->content()
            );
        }
        when ($_ > 200 and $_ < 300) {
            return $res->content();
        }
        default { return undef; }
    }
}

sub post {
    my $self = shift;
    # TODO post to url with query string?
    my $res = $self->_request('POST', @_);
    given ($res->code) {
        when (201) {
            return $self->_serializer->decode(
                $res->content()
            );
        }
        when ($_ >= 200 and $_ < 300) {
            return $res->content();
        }
        default { return undef; }
    }
}

sub put {
    my $self = shift;
    # TODO post to url with query string?
    my $res = $self->_request('PUT', @_);
    given ($res->code) {
        when (204) {
            return 1;
        }
        when ($_ >= 200 and $_ < 300) {
            return 1;
        }
        default { return 0; }
    }
}

sub delete {
    my $self = shift;
    # TODO post to url with query string?
    my $res = $self->_request('DELETE', @_);
    given ($res->code) {
        when (204) {
            return 1;
        }
        when ($_ >= 200 and $_ < 300) {
            return 1;
        }
        default { return 0; }
    }
}

1;
=head1 NAME

WWW::Snooze::Request - Main request object featuring autoloading

=head1 METHODS


=head2 new(%args)

=over 4

=item headers

Override headers with an instance of L<HTTP::Headers>

=item serializer

Override serializer with and instance of L<WWW::Snooze::Serialize>

=back

=head2 get([\%data])

=head2 delete([\%data])

=head2 post([\%data])

=head2 put([\%data])

Perform HTTP operation on URL, %data is encoded using the serializer.


=head1 AUTOMATIC METHODS

The request object uses autoloading method names to build the request. Calling a
method on the request object will add that method name on to the URL stack and
return a new request object with the new stack.

=head2 [$element]($id, %query_string)

Automatic methods can be called with an C<id> argument, or C<undef> if there is
no id, and named parameters which are encoded to a query string

    my $r = WWW::Snooze::Request->new('http://example.com');
    
    $r->foo();
    # Request URL would be http://example.com/foo.json
    
    $r->foo(42)->bar;
    # http://example.com/foo/42/bar.json
    
    $r->foo(undef, foo => 'bar');
    # http://example.com/foo?foo=bar

=head2 _add_element($name, $id, %query_string)

Automatic methods are built using this private function, however you can also
revert to calling this directly in the case of a namespace collision with an
element or a poorly named element.

    $r->_add_element('poorly named');
    # http://example.com/poorly%20named
    
    $r->_add_element('foo', 42, foo => bar);
    # http://example.com/foo/42.json?foo=bar

=head1 ATTRIBUTES

Privately scoped to avoid namespace collision

=head2 _args()

Return query string arguments added

=head2 _serializer()

Return the serializer

=head2 _headers()

Return the HTTP::Headers object


=head1 AUTHOR

Anthony Johnson E<lt>aj@ohess.orgE<gt>
