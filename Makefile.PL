use strict;
use warnings;
use inc::Module::Install;

name 'WWW-Snooze';

perl_version '5.010';

version_from 'lib/WWW/Snooze.pm';
version_from 'lib/WWW/Snooze.pm';
author 'Anthony Johnson <aj@ohess.org>';

requires 'URI';
requires 'LWP::UserAgent';
requires 'JSON';
requires 'HTTP::Request';
requires 'LWP::Protocol::https';

WriteAll;
