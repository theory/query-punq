use Module::Build;

my $build = Module::Build->new(
    module_name        => 'Query::Punq',
    license            => 'perl',
    create_makefile_pl => 'traditional',
    configure_requires => { 'Module::Build' => '0.2701' },
    build_requires     => { 'Test::More'    => '0.17'   },
    recommends         => { 'Test::Pod'     => '1.20'   },
);
$build->create_build_script;
