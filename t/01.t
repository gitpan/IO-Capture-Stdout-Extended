use strict;
use warnings;
use Test::More tests => 
15; 
# 'no_plan';
BEGIN { 
    use_ok('IO::Capture::Stdout::Extended')
};

my ($capture, $matches, @matches, %matches, $matchesref, $regex );
my ($predicted, @predicted); 

$capture = IO::Capture::Stdout::Extended->new();
isa_ok($capture, 'IO::Capture::Stdout::Extended');
can_ok('IO::Capture::Stdout::Extended', qw|
    grep_print_statements
    statements
    matches
    matches_ref
|);

$capture->start;
print_fox();
$capture->stop;
$matches = $capture->grep_print_statements("fox");
is($capture->grep_print_statements("fox"), 2, 
    "correct no. of print statements grepped");
%matches = map { $_, 1 } $capture->grep_print_statements("fox");
is(keys %matches, 2, "correct no. of print statements grepped");
ok($matches{'The quick brown fox jumped over ...'}, 
    'print statement correctly grepped');
ok($matches{'The quick red fox jumped over ...'}, 
    'print statement correctly grepped');

$capture->start;
print_fox_long();
$capture->stop;
$matches = $capture->grep_print_statements("fox");
is($capture->grep_print_statements("fox"), 3, 
    "correct no. of print statements grepped");

$capture->start();
print_greek();
$capture->stop();
is($capture->statements, 4, 
    "number of print statements is correct");

$capture->start();
print_greek_long();
$capture->stop();
is($capture->statements, 8, 
    "number of print statements is correct");

my @week = (
    [ qw| Monday     Lundi    Lunes     | ],
    [ qw| Tuesday    Mardi    Martes    | ],
    [ qw| Wednesday  Mercredi Miercoles | ],
    [ qw| Thursday   Jeudi    Jueves    | ],
    [ qw| Friday     Vendredi Viernes   | ],
    [ qw| Saturday   Samedi   Sabado    | ],
    [ qw| Sunday     Dimanche Domingo   | ],
);

$capture->start();
print_week(\@week);
$capture->stop();
$regex = qr/English:.*?French:.*?Spanish:/s;

eval { $capture->matches() };
like($@, qr/^Not enough arguments:/,
    "detected missing regex variable as argument to matches()")
    || print STDERR "$@\n"; 

is($capture->matches($regex), 7,
    "correct number of forms printed to screen");
@matches = $capture->matches($regex);
$predicted = "English:  Monday\nFrench:   Lundi\nSpanish:";
is($matches[0], $predicted, "first form matches test portion");
$matchesref = $capture->matches_ref($regex);
is(${$matchesref}[0], $predicted, "first form matches test portion");

$regex = qr/French:\s+(.*?)\n/s;
@predicted = qw| Lundi Mardi Mercredi Jeudi 
    Vendredi Samedi Dimanche |;
ok(eq_array( [ $capture->matches($regex) ], \@predicted ), 
    "all predicted matches found");

##### subroutines containing dummy print statements #####

sub print_fox {
    print "The quick brown fox jumped over ...";
    print "garden wall";
    print "The quick red fox jumped over ...";
    print "garden wall";
}

sub print_fox_long {
    print "The quick brown fox jumped over ...";
    print "a less adept fox\n";
    print "The quick red fox jumped over ...";
    print "the garden wall\n";
}

sub print_greek {
    local $_;
    print "$_\n" for (qw| alpha beta gamma delta |);
}

sub print_greek_long {
    local $_;
    for (qw| alpha beta gamma delta |) {
        print $_;
        print "\n";
    }
}

sub print_week {
    my $weekref = shift;
    my @week = @{$weekref}; 
    for (my $day=0; $day<=$#week; $day++) {
        print "English:  $week[$day][0]\n";
        print "French:   $week[$day][1]\n";
        print "Spanish:  $week[$day][2]\n";
        print "\n";
    }
}
