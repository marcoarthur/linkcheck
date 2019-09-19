package Mojolicious::Command::check;

use Mojo::Base 'Mojolicious::Command';
use experimental qw(signatures);
use feature qw(say);

has description => 'append to the named "check_links" queue a job';
has usage => "Usage: APPLICATION check <URLs>";


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
		say "checking $_";
		$self->app->minion->enqueue( check_links => [$_]);
	}
}

1;
