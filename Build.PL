use 5.008;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name => 'WWW::Snooze',
    license => 'mit',
    dist_author => q{Anthony Johnson <aj@ohess.org>},
    dist_version_from => 'lib/WWW/Snooze.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'perl' => 5.008,
        'URI' => 0,
        'LWP::UserAgent' => 0,
        'JSON' => 0,
        'HTTP::Request' => 0,
        'LWP::Protocol::https' => 0
    },
    add_to_cleanup => [ 'WWW-Snooze-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
