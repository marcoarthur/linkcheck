package Mojolicious::Command::get_text;

use Mojo::Base 'Mojolicious::Command';
use experimental qw(signatures);
use feature qw(say);

has description => 'append to the named "get_texts" queue a job';
has usage => "Usage: APPLICATION get_text <URLs>\n";

sub run ( $self, @args ) {
	my @files = grep { -e $_ } @args;
	my @urls = grep { ! -e $_ } @args;
	my @urls_from_files;

	# read files
	for my $f (@files) { 
		open( my $fh, '<', $f ) or die "Can't open file $f";

		while ( <$fh> ) {
			chomp;
			push @urls_from_files, $_;
		}
	}
	
	for ( @urls_from_files, @urls ) { 
		say "getting $_";
		$self->app->minion->enqueue( get_texts => [$_]);
	}
}

1;
