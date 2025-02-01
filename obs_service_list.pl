#!/usr/bin/perl
use strict;
use warnings;
use XML::LibXML;
# Usage example:

# Define the _service file path
my $service_file = '_service';

if (-f $service_file){

# Create an XML::LibXML object
my $parser = XML::LibXML->new();

# Parse the _service file
my $doc = $parser->parse_file($service_file);

# Extract information from the _service file
my $services_node = $doc->documentElement();

# Iterate over service elements
foreach my $service_node ($services_node->findnodes('//service')) {
    my $service_name = $service_node->getAttribute('name');
    my $service_mode = $service_node->getAttribute('mode') || 'default';
    $service_mode = lc($service_mode);
    # Simulate the actions performed by OBS services based on the mode and parameters
    if ($service_mode eq 'default') {
        # Implement the logic for the 'Default' mode
        print("$service_name\n");
    } elsif ($service_mode eq 'trylocal') {
        # Implement the logic for the 'trylocal' mode
        print("$service_name\n");
    } elsif ($service_mode eq 'localonly') {
        # Implement the logic for the 'localonly' mode
        print("$service_name\n");
    } elsif ($service_mode eq 'serveronly') {
        # Implement the logic for the 'serveronly' mode
        print("$service_name\n");
    } elsif ($service_mode eq 'buildtime') {
        # Implement the logic for the 'buildtime' mode
        print("$service_name\n");
    } elsif ($service_mode eq 'manual') {
        # Implement the logic for the 'manual' mode
    #    print("$service_name\n");
    #} elsif ($service_mode eq 'disabled') {
        # Implement the logic for the 'disabled' mode
        print("$service_name\n");
    }
}

}
