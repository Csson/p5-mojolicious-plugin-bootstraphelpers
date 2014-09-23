requires 'perl', '5.020000';

# requires 'Some::Module', 'VERSION';
requires 'Mojolicious', '5.00';
requires 'List::AllUtils', '0.07';
requires 'Scalar::Util', '1.29';
requires 'String::Trim', '0.004';
requires 'String::Random';
requires 'experimental', '0.008';
requires 'true', '0.18';

on test => sub {
    requires 'Test::More', '0.96';
    requires 'Test::Mojo::Trim', '0.03';
};

on build => sub {
    requires 'Dist::Zilla::Plugin::Test::CreateFromMojoTemplates', '0.05';
    requires 'Dist::Zilla::Plugin::InsertExample::FromMojoTemplates', '0.02.00';
    requires 'Dist::Zilla::Plugin::PkgVersion::Block', '0.0101';
    requires 'Test::EOL', '1.5',
    requires 'Test::Pod', '1.45',
};
