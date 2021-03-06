#!perl
use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('PONAPI::Builder::Document');
    use_ok('PONAPI::Builder::Errors');
}

subtest '... testing constructor' => sub {

    my $builder = PONAPI::Builder::Errors->new;
    isa_ok( $builder, 'PONAPI::Builder::Errors');
    does_ok($builder, 'PONAPI::Builder');

    can_ok( $builder, $_ ) foreach qw[
        add_error
        has_errors

        build
    ];

};

subtest '... document->build' => sub {
    my $builder = PONAPI::Builder::Document->new(version => 999);
    local $@;
    eval {
        $builder->build;
    };
    my $e = "$@";
    like(
        $e,
        qr/\Q[PANIC] OH NOES, THIS SHOULD NEVER HAPPEN!!!!!\E/,
        "... got a panic when building a document with nothing in it"
    );
};

done_testing;
