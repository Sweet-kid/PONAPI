# ABSTRACT: mock repository - table - Comments
package Test::PONAPI::Repository::MockDB::Table::Comments;

use Moose;
extends 'Test::PONAPI::Repository::MockDB::Table';

use Test::PONAPI::Repository::MockDB::Table::Relationships;

sub BUILDARGS {
    my $class = shift;
    my %args = @_ == 1 ? %{ $_[0] } : @_;

    my $to_articles =
        Test::PONAPI::Repository::MockDB::Table::Relationships->new(
            TYPE          => 'articles',
            TABLE         => 'rel_articles_comments',
            ID_COLUMN     => 'id_comments',
            REL_ID_COLUMN => 'id_articles',
            COLUMNS       => [qw/ id_articles id_comments /],
            ONE_TO_ONE    => 1,
        );

    %args = (
        TYPE      => 'comments',
        TABLE     => 'comments',
        ID_COLUMN => 'id',
        COLUMNS   => [qw/ id body /],
        RELATIONS => { articles => $to_articles, },
        %args,
    );

    return \%args;
}

__PACKAGE__->meta->make_immutable;
no Moose; 1;

__END__
