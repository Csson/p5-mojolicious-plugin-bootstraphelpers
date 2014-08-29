use Mojo::Base -strict;
BEGIN {
    $ENV{'MOJO_NO_IPV6'} = 1;
    $ENV{'MOJO_REACTOR'} = 'Mojo::Reactor::Poll';
}

use Test::More;
use Mojolicious::Lite;
use Test::Mojo;

plugin 'BootstrapHelpers';

my $test = Test::Mojo->new;

get '/panel';

get '/formgroup_textfield';

{
    my $panel = qq{
            <div class="panel panel-default">
                <div class="panel-body">
                </div>
            </div>[

            ]<div class="panel panel-default">
                <div class="panel-body">
                </div>
            </div>[
            ]<div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Test</h3>
                </div>
                <div class="panel-body">
                </div>
            </div>[

            ]<div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Test</h3>
                </div>
                <div class="panel-body">
                    <p>A short text.</p>
                </div>
            </div>
        };
    $test->get_ok('/panel')->status_is(200)->content_is(trimmed($panel));
}
{
    my $group = q{
            <div class="form-group">
                <label for="test_text">Text test</label>
                <input class="form-control" id="test_text" name="test_text" type="text" />
            </div>[

            ]<div class="form-group">
                <label for="test_text">Text test</label>
                <input class="form-control" id="test_text" name="test_text" size="30" type="text" />
            </div>[

            ]<div class="form-group">
                <label for="test_text">Text test</label>
                <div class="input-group">
                    <span class="input-group-addon">@</span>
                    <input class="form-control" id="test_text" name="test_text" type="text" />
                </div>
            </div>[

            ]<div class="form-group">
                <label for="test_text">Text test</label>
                <div class="input-group">
                    <input class="form-control" id="test_text" name="test_text" type="text" />
                    <span class="input-group-addon">.00</span>
                </div>
            </div>[

            ]<div class="form-group">
                <label for="test_text">Text test</label>
                <div class="input-group">
                    <span class="input-group-addon">$</span>
                    <input class="form-control" id="test_text" name="test_text" type="text" value="200" />
                    <span class="input-group-addon">.00</span>
                </div>
            </div>[
]};
    $test->get_ok('/formgroup_textfield')->status_is(200)->content_is(trimmed($group));
}

done_testing();


sub trimmed {
    my $tag = shift;
    
    no warnings 'uninitialized';
    # remove unwanted newlines/lines with just whitespace
    $tag =~ s{>[^[]? \n+ \s* \n? ([^]])?}{>$1}xg;
    # remove trailing whitespace
    $tag =~ s{[ \s]+$}{}g;
    # remove wanted whitespace opener
    $tag =~ s{>\[}{>}g;
    # remove wanted whitespace closer
    $tag =~ s{](<?)}{$1}g;
    
    return $tag;
}

__DATA__
@@ panel.html.ep
%= bs_panel Test => no_title => 1
%= bs_panel Test => (no_title => 1) => begin
%  end
%= bs_panel 'Test'
%= bs_panel Test => begin
    <p>A short text.</p>
%  end

@@ formgroup_textfield.html.ep
%= bs_formgroup 'Text test', text_field => ['test_text']
%= bs_formgroup 'Text test', text_field => ['test_text', size => 30]
%= bs_formgroup 'Text test', text_field => ['test_text', _prepend => '@']
%= bs_formgroup 'Text test', text_field => ['test_text', _append => '.00']
%= bs_formgroup 'Text test', text_field => ['test_text', '200', _prepend => '$', _append => '.00']