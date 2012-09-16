use Test::More;
use Test::Exception;
use WWW::Snooze::Request;

plan tests => 7;

my $r = WWW::Snooze::Request->new(
    'http://example.com/api',
    parts => ['foo', 'bar', '123'],
);

is(
    $r->_build_url(),
    'http://example.com/api/foo/bar/123.json',
    'Build URL explicitly'
);

is(
    $r->foos->_build_url(),
    'http://example.com/api/foo/bar/123/foos.json',
    'Build URL with inherited object'
);

is(
    $r->foos(456)->_build_url(),
    'http://example.com/api/foo/bar/123/foos/456.json',
    'Build URL with inherited object id'
);

is(
    $r->_build_url(),
    'http://example.com/api/foo/bar/123.json',
    'Build URL explicitly again'
);

is(
    $r->_add_element('poorly named')->_build_url(),
    'http://example.com/api/foo/bar/123/poorly%20named.json',
    'Build URL with poorly named element'
);

is(
    $r->_add_element('foo', undef, foo => 'bar')->_build_url(),
    'http://example.com/api/foo/bar/123/foo.json?foo=bar',
    'Build URL with direct call to private method, with query'
);

dies_ok(
    sub { $r->_request('FOO') },
    'Expect fail on bad method'
);

1;
