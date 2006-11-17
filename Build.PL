use Module::Build;

my $build = Module::Build->new(
    module_name        => 'Query::Punq',
    license            => 'perl',
    requires           => {
    },

    build_requires     => {
        Test::Simple => '0.17',
    },
    create_makefile_pl => 'traditional',
);
$build->create_build_script;
