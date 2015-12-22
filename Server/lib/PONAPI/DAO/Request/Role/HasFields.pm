# ABSTRACT: DAO request role - `fields`
package PONAPI::DAO::Request::Role::HasFields;

use Moose::Role;

has fields => (
    traits   => [ 'Hash' ],
    is       => 'ro',
    isa      => 'HashRef',
    default  => sub { +{} },
    handles  => {
        "has_fields" => 'count',
    },
);

sub _validate_fields {
    my $self = shift;
    return unless $self->has_fields;

    my $fields = $self->fields;
    my $repo   = $self->repository;

    foreach my $fields_type ( keys %$fields ) {
        if ( !$repo->has_type( $fields_type ) ) {
            $self->_bad_request( "Type `$fields_type` doesn't exist.", 404 );
        }
        else {
            my $fields_array = $fields->{$fields_type};
            my @fields = @$fields_array;

            my $ok = $repo->type_has_fields( $fields_type, \@fields );
            next if $ok;

            # Sigh... let's test for this:
            # fields => { articles => [qw/ title authors /] }
            # where authors is a *relationship*
            # There can't be clashes, so yes, this is fine. Somehow.
            # http://jsonapi.org/format/#document-resource-object-fields
            my (@real_fields, @relationships);
            foreach my $maybe_rel ( @fields ) {
                if ( $repo->has_relationship($fields_type, $maybe_rel) ) {
                    push @relationships, $maybe_rel;
                }
                else {
                    push @real_fields, $maybe_rel;
                }
            }

            $ok = @real_fields
                    ? $repo->type_has_fields($fields_type, \@real_fields)
                    : 1;

            if (!$ok) {
                $self->_bad_request(
                    "Type `$fields_type` does not have at least one of the requested fields"
                );
            }
        }
    }
}

no Moose::Role; 1;

__END__
