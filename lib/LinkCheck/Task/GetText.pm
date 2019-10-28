package LinkCheck::Task::GetText;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app ) = @_;
    $app->minion->add_task( get_texts => \&_get_text );
}

sub _get_text {
    my ( $job, $url ) = @_;

    my @results;
    my $ua  = $job->app->ua;
    my $res = $ua->get($url)->result;
    push @results, [ $url, $res->code ];

	$job->app->log->debug("Getting text from $url");

    # get and save text to database
    my $text = $res->dom->find('p')->map('text')->join("\n")->trim->to_string;
    my $row  = {
        site => $url,
        text => $text,
    };
    $job->app->db->insert( 'texts', $row );

    $job->finish( \@results );
}

1;
