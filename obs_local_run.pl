#!/usr/bin/perl
#!/usr/bin/perl

use strict;
use warnings;
use XML::LibXML;
use Data::Dumper;
use File::Path qw(make_path rmtree);

use Cwd;

use File::Basename;
use File::Remove 'remove';
use File::Spec::Functions qw(abs2rel catfile catdir);

use IPC::Run3;

# Define the _service file path
my $service_file = '_service';

if (-f $service_file){
# Create an XML::LibXML object
my $parser = XML::LibXML->new();

# Parse the _service file
my $doc = $parser->parse_file($service_file);

# Extract information from the _service file
my $services_node = $doc->documentElement();

our $home_directory = getcwd();

my $cwd = getcwd();

# Iterate over service elements
foreach my $service_node ($services_node->findnodes('//service')) {
    my $service_name = $service_node->getAttribute('name');
    my $service_mode = $service_node->getAttribute('mode') || 'Default';

    # Extract parameters for each service
    my @params = $service_node->findnodes('.//param');
    my @service_params = ();
    foreach my $param (@params) {
        push @service_params, $param->getAttribute('name'), $param->textContent();
    }

    # Simulate the actions performed by OBS services based on the mode and parameters
    if ($service_mode eq 'Default') {
        # Implement the logic for the 'Default' mode
        default_mode_action($service_name)->(@service_params);
    } elsif ($service_mode eq 'trylocal') {
        # Implement the logic for the 'trylocal' mode
        trylocal_mode_action($service_name)->(@service_params);
    } elsif ($service_mode eq 'localonly') {
        # Implement the logic for the 'localonly' mode
        localonly_mode_action($service_name)->(@service_params);
    } elsif ($service_mode eq 'serveronly') {
        # Implement the logic for the 'serveronly' mode
        serveronly_mode_action($service_name)->(@service_params);
    } elsif ($service_mode eq 'buildtime') {
        # Implement the logic for the 'buildtime' mode
        buildtime_mode_action($service_name)->(@service_params);
    } elsif ($service_mode eq 'manual') {
        # Implement the logic for the 'manual' mode
        manual_mode_action($service_name)->(@service_params);
    } elsif ($service_mode eq 'disabled') {
        # Implement the logic for the 'disabled' mode
        disabled_mode_action($service_name)->(@service_params);
    }
}

# Simulate the action performed in 'Default' mode
sub default_mode_action {
    return \&serveronly_mode_action;
}

# Simulate the action performed in 'trylocal' mode
sub trylocal_mode_action {
    return \&serveronly_mode_action; #manual_mode_action(shift);
}

# Simulate the action performed in 'localonly' mode
sub localonly_mode_action {
    return Run(shift);
}

# Simulate the action performed in 'serveronly' mode
sub serveronly_mode_action {
    return \&serveronly_mode_action;
}

# Simulate the action performed in 'buildtime' mode
sub buildtime_mode_action {
    return \&serveronly_mode_action;
}

# Simulate the action performed in 'manual' mode
sub manual_mode_action {
    return Run(shift);
}

# Simulate the action performed in 'disabled' mode
sub disabled_mode_action {
    return \&disabled_mode_action;
}

sub Run {
    my $service_name = $_[0];
 #   my $cwd = Cwd::realpath($cwd_rel);
 #   my $outdir = Cwd::realpath($outdir_rel);
    return sub  {
        my $pid = fork;
        if ($pid == 0){
            my $path = "/usr/lib/obs/service/$service_name";
            my @args;
            loop0:
            my $name = shift;
            my $value = shift;
            if (defined($name)){
                push @args, "--$name";
                push @args, "$value";
                goto loop0;
            }

            print "\n______RUN______\n$path --outdir . ", join(' ', @args), " ; \n";
            exec($path, '--outdir', $cwd, @args);
        } else {
            waitpid($pid, 0);
            print("\n______END______\n");
        }
    }
}
}
