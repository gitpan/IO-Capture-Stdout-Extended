use ExtUtils::MakeMaker;
WriteMakefile(
    NAME         => 'IO::Capture::Stdout::Extended',
    VERSION_FROM => 'lib/IO/Capture/Stdout/Extended.pm',
    AUTHOR       => 'James E Keenan (jkeenan@cpan.org)',
    ABSTRACT     => 'Extend functionality of IO::Capture::Stdout',
    PREREQ_PM    => {
                     'Test::Simple' => 0.44,
                     'IO::Capture'  => 0.03,
                    },
);
