#!/usr/bin/perl

use strict;
use warnings;
use XML::LibXML;

# File path
my $file_path = '_repolist';

if (-f $file_path){

# Create a new XML parser
my $parser = XML::LibXML->new();

# Parse the XML file
my $doc = $parser->parse_file($file_path);

# Find all <url> elements
my @urls = $doc->findnodes('//url');

# Print the URLs
foreach my $url (@urls) {
    print $url->textContent(), "\n";
}

}
