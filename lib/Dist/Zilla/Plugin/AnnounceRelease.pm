package Dist::Zilla::Plugin::AnnounceRelease;
#ABSTRACT: Announce the successful release of a distribution

use Moose;
use namespace::autoclean;
with 'Dist::Zilla::Role::AfterRelease';

use Archive::Tar;
use YAML::XS 'Load';
use Class::Load 'try_load_class';

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

    unless(try_load_class('DDG::Util::Chat')){
        $self->log_fatal(['Failed to load DDG::Util::Chat']);
    }

    unless($dist =~ /(DDG-(.+?)Bundle-OpenSourceDuckDuckGo-(.+?))\.tar\.gz/){
        $self->log_fatal(["Failed to parse distribution name $dist"]);
    }
    my ($dir, $type, $ver) = ($1, $2, $3);

    my $msg = "$type v$ver was successfully released";

    my $tgz = Archive::Tar->new($dist);
    my $yaml = $tgz->get_content("$dir/" . $self->changelog);

    my $cl = Load($yaml);
    my %changes;
    while(my ($id, $status) = each %$cl){
        push @{$changes{ucfirst $status}}, qq{- <a href="https://duck.co/ia/view/$id">$id</a>};
    }
    if(%changes){
        $msg .= ' and contains the following changes:';
        for my $status (qw(Added Modified Deleted)){
            if(exists $changes{$status}){
                $msg .= "<br /><br />$status<br /><br />" . join('<br />', sort @{$changes{$status}});
            }
        }
    }

    DDG::Util::Chat::send_chat_message($self->channel, $msg, 'dzil');
}

__PACKAGE__->meta->make_immutable;

1;
