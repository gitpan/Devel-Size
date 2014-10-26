#!/usr/bin/perl -w

use strict;
use Test::More tests => 2;
use Devel::Size ':all';
use Config;

use constant PVBM => 'galumphing';
my $dummy = index 'galumphing', PVBM;

if($Config{useithreads}) {
    cmp_ok(total_size(PVBM), '>', 0, "PVBMs don't cause SEGVs");
    # Really a core bug:
    local $TODO = 'Under ithreads, pad constants are no longer PVBMs';
    cmp_ok(total_size(PVBM), '>', total_size(PVBM . '') + 256,
	   "PVBMs use 256 bytes for a lookup table");
} else {
    cmp_ok(total_size(PVBM), '>', total_size(PVBM . ''),
	   "PVBMs don't cause SEGVs");
    local $TODO = 'PVBMs not yet handled properly in 5.10.0 and later'
	if $] >= 5.010;
    cmp_ok(total_size(PVBM), '>', total_size(PVBM . '') + 256,
	   "PVBMs use 256 bytes for a lookup table");
}
