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

get '/panel' => 'panel';

get '/formgroup_textfield';

get '/formgroup_textfield_2';

get '/buttons';

{
    my $panel = qq{[
            ]<div class="panel panel-default">
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
    my $formgroup_textfield = q{[
            ]<div class="form-group">
                <label class="control-label" for="test_text">Text test 1</label>
                <input class="form-control" id="test_text" name="test_text" type="text" />
            </div>[

            ]<div class="form-group">
                <label class="control-label" for="test_text">Text test 2</label>
                <input class="form-control" id="test_text" name="test_text" size="30" type="text" />
            </div>[

            ]<div class="form-group">
                <label class="control-label" for="test_text">Text test 3</label>
                <div class="input-group">
                    <span class="input-group-addon">@</span>
                    <input class="form-control" id="test_text" name="test_text" type="text" />
                </div>
            </div>[

            ]<div class="form-group">
                <label class="control-label" for="test_text">Text test 4</label>
                <div class="input-group">
                    <input class="input-lg form-control" id="test_text" name="test_text" type="text" />
                    <span class="input-group-addon">.00</span>
                </div>
            </div>[

            ]<div class="form-group">
                <label class="control-label" for="test_text">Text test 5</label>
                <div class="input-group">
                    <span class="input-group-addon">$</span>
                    <input class="form-control" id="test_text" name="test_text" type="text" value="200" />
                    <span class="input-group-addon">.00</span>
                </div>
            </div>[
]};
    $test->get_ok('/formgroup_textfield')->status_is(200)->content_is(trimmed($formgroup_textfield));
}

{   

    my $formgroup_textfield_2 = q{[
            ]<div class="form-group form-group-lg">
                <label class="control-label" for="test_text">Text test 1</label>
                <input class="form-control" id="test_text" name="test_text" type="text" />
            </div>[

            ]<div class="form-group">
                <label class="control-label" for="test_text">[
    ]Text test 2[
]</label>
                <input class="form-control input-xs" id="test_text" name="test_text" type="text" />
            </div>};
    $test->get_ok('/formgroup_textfield_2')->status_is(200)->content_is(trimmed($formgroup_textfield_2));
}

{
    my $buttons = q{
            <a class="btn btn-lg" href="http://www.example.com/">The example 1</a>[
]<a class="btn" href="/buttons">The example 2</a>[
]<a class="btn" href="/panel">The example 3</a>[
]<button class="btn">The example 4</button>[
]<button class="btn btn-lg">The example 5</button>[
]<a class="btn" href="/buttons">[
   ]The Example 6[
]</a>};
    $test->get_ok('/buttons')->status_is(200)->content_is(trimmed($buttons));
}

done_testing();


sub trimmed {
    my $tag = shift;
    
    no warnings 'uninitialized';
    # remove unwanted newlines/lines with just whitespace
    $tag =~ s{>[^[]? \n+ \s* \n? ([^]])?}{>$1}xg;
    # remove leading whitespace
    $tag =~ s{^[ \s]+}{}g;
    # remove trailing whitespace
    $tag =~ s{[ \s]+$}{}g;
    # remove wanted whitespace opener
    $tag =~ s{(>?)\[}{$1}g;
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
%= bs_formgroup 'Text test 1', text_field => ['test_text']
%= bs_formgroup 'Text test 2', text_field => ['test_text', size => 30]
%= bs_formgroup 'Text test 3', text_field => ['test_text', prepend => '@']
%= bs_formgroup 'Text test 4', text_field => ['test_text', append => '.00', class => 'input-lg']
%= bs_formgroup 'Text test 5', text_field => ['test_text', '200', prepend => '$', append => '.00']

@@ formgroup_textfield_2.html.ep
%= bs_formgroup 'Text test 1', text_field => ['test_text'], large => 1
%= bs_formgroup text_field => ['test_text', xsmall => 1] => begin
    Text test 2
%  end

@@ buttons.html.ep
%= bs_button 'The example 1' => ['http://www.example.com/'], lg => 1
%= bs_button 'The example 2' => [url_for]
%= bs_button 'The example 3' => ['panel']
%= bs_button 'The example 4'
%= bs_button 'The example 5' => large => 1
%= bs_button [url_for] => begin
   The Example 6
%  end