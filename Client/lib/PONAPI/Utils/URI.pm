# ABSTRACT: PONAPI - Perl implementation of {JSON:API} (http://jsonapi.org/) v1.0
package PONAPI::Utils::URI;

use strict;
use warnings;

use URI;
use URI::QueryParam;
use URI::Escape qw( uri_escape_utf8 );

use parent qw< Exporter >;
our @EXPORT_OK = qw< to_uri >;

sub to_uri {
    my ( $data ) = @_;
    die "[__PACKAGE__] to_uri: input must be a hash"
        unless ref $data eq 'HASH';

    my $u = URI->new("", "http");

    for my $d_k ( sort keys %{ $data } ) {
        my $d_v = $data->{$d_k};
        defined($d_v) or next;

        if ( ref $d_v ne 'HASH' ) {
            $u->query_param( $d_k =>
                             join ',' => map { uri_escape_utf8($_) } ( ref $d_v eq 'ARRAY' ? @{$d_v} : $d_v ) );
            next;
        }

        # HASH
        for my $k ( sort keys %{$d_v} ) {
            my $v = $d_v->{$k};

            die "[__PACKAGE__] to_uri: nested value can be scalar/arrayref only"
                unless !ref $v or ref $v eq 'ARRAY';

            $u->query_param( $d_k . '[' . $k . ']' =>
                             join ',' => map { uri_escape_utf8($_) } ( ref $v eq 'ARRAY' ? @{$v} : $v ) );
        }
    }

    return $u->query;
}

1;

__END__
