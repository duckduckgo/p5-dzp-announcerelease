package Dist::Zilla::Plugin::AnnounceRelease;
#ABSTRACT: Announce the successful release of a distribution

use Moose;
use namespace::autoclean;
with 'Dist::Zilla::Role::AfterRelease';

use Archive::Tar;
use YAML::XS 'Load';

use strict;

has changelog => (
	is => 'ro',
	default => 'ia_changelog.yml'
);

has channel => (
	is => 'ro',
	default => 'DuckDuckHack'
);

sub after_release {
	my ($self, $dist) = @_;

	eval 'require DDG::Util::Chat';

	unless($dist =~ /(DDG-(.+?)Bundle-OpenSourceDuckDuckGo-(.+?))\.tar\.gz/){
		$self->log_fatal(["Failed to parse distribution name $dist"]);
	}
	my ($dir, $type, $ver) = ($1, $2, $3);

	my $msg = "$type v$ver was successfully released and contains the following changes:<br />";

	my $tgz = Archive::Tar->new($dist);
	my $yaml = $tgz->get_content("$dir/" . $self->changelog);

	my $cl = Load($yaml);
	while(my ($id, $status) = each %$cl){
		$msg .= qq{<br />- <a href="https://duck.co/ia/view/$id">$id</a> was $status};
	}

	DDG::Util::Chat::send_chat_message($self->channel, $msg, 'dzil');
}

__PACKAGE__->meta->make_immutable;

1;

