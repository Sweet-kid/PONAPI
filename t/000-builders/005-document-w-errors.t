#!perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;

BEGIN {
    use_ok('PONAPI::Builder::Document');
}

my $ERROR = {
    message => "an error has occured",
    status  => 555,
};

subtest '... creating a document with errors' => sub {

    my $doc = PONAPI::Builder::Document->new;
    isa_ok( $doc, 'PONAPI::Builder::Document');

    $doc->raise_error( $ERROR );

    my $GOT = $doc->build->{errors}[0];

    is_deeply(
        $GOT,
        $ERROR,
        "... the document now has errors",
    );
};


done_testing;