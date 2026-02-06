use strict;
use warnings;

use Test::More;

use Flat::Profile;

my $profiler = Flat::Profile->new();
my $iterator = $profiler->iter_rows();

ok($iterator, 'iter_rows() returned something');
ok(ref($iterator), 'iter_rows() returned a reference');
ok($iterator->can('next_row'), 'iterator has next_row()');

my $row = $iterator->next_row();
ok(!defined $row, 'next_row() returns undef in skeleton iterator');

done_testing;
