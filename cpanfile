requires 'perl', '5.020000';

# requires 'Some::Module', 'VERSION';
requires 'Mojolicious', '5.00';
requires 'List::AllUtils', '0.07';
requires 'Syntax::Collection::Basic', '0.02';
requires 'Scalar::Util', '1.29';
requires 'String::Trim', '0.004';
requires 'experimental', '0.008';

on test => sub {
    requires 'Test::More', '0.96';
};
