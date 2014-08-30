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

get '/panel_1' => 'panel_1';
get '/panel_2';
get '/panel_3';
get '/panel_4';
get '/panel_5';
get '/formgroup_textfield_1';
get '/formgroup_textfield_2';
get '/formgroup_textfield_3';
get '/formgroup_textfield_4';
get '/formgroup_textfield_5';
get '/formgroup_textfield_6';
get '/formgroup_textfield_7';
get '/formgroup_textfield_8';
get '/buttons';


my $panel_1 = qq{[
            ]<div class="panel panel-default">
                <div class="panel-body">
                </div>
            </div>[
]};
$test->get_ok('/panel_1')->status_is(200)->content_is(trimmed($panel_1));

my $panel_2 = qq{[
            ]<div class="panel panel-default">
                <div class="panel-body">
                    <p>In the panel.</p>
                </div>
            </div>};
$test->get_ok('/panel_2')->status_is(200)->content_is(trimmed($panel_2));

my $panel_3 = qq{[
            ]<div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Test</h3>
                </div>
                <div class="panel-body">
                </div>
            </div>[
]};
$test->get_ok('/panel_3')->status_is(200)->content_is(trimmed($panel_3));

my $panel_4 = qq{[
            ]<div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">The Header</h3>
                </div>
                <div class="panel-body">
                    <p>A short text.</p>
                </div>
            </div>};
$test->get_ok('/panel_4')->status_is(200)->content_is(trimmed($panel_4));

my $panel_5 = qq{[
            ]<div class="panel panel-success">
                <div class="panel-heading">
                    <h3 class="panel-title">Panel 5</h3>
                </div>
                <div class="panel-body">
                    <p>A short text.</p>
                </div>
            </div>};
$test->get_ok('/panel_5')->status_is(200)->content_is(trimmed($panel_5));

my $formgroup_textfield_1 = q{[
            ]<div class="form-group">
                <label class="control-label" for="test_text">Text test 1</label>
                <input class="form-control" id="test_text" name="test_text" type="text" />
            </div>[
]};
$test->get_ok('/formgroup_textfield_1')->status_is(200)->content_is(trimmed($formgroup_textfield_1));

my $formgroup_textfield_2 = q{[
            <div class="form-group">
                <label class="control-label" for="test_text">Text test 2</label>
                <input class="form-control" id="test_text" name="test_text" size="30" type="text" />
            </div>[
]};
$test->get_ok('/formgroup_textfield_2')->status_is(200)->content_is(trimmed($formgroup_textfield_2));

my $formgroup_textfield_3 = q{[
            ]<div class="form-group">
                <label class="control-label" for="test_text">Text test 3</label>
                <div class="input-group">
                    <span class="input-group-addon">@</span>
                    <input class="form-control" id="test_text" name="test_text" type="text" />
                </div>
            </div>[
]};
$test->get_ok('/formgroup_textfield_3')->status_is(200)->content_is(trimmed($formgroup_textfield_3));

my $formgroup_textfield_4 = q{[
            <div class="form-group">
                <label class="control-label" for="test_text">Text test 4</label>
                <div class="input-group">
                    <input class="form-control input-lg" id="test_text" name="test_text" type="text" />
                    <span class="input-group-addon">.00</span>
                </div>
            </div>[
]};
$test->get_ok('/formgroup_textfield_4')->status_is(200)->content_is(trimmed($formgroup_textfield_4));

my $formgroup_textfield_5 = q{[
            <div class="form-group">
                <label class="control-label" for="test_text">Text test 5</label>
                <div class="input-group">
                    <span class="input-group-addon">$</span>
                    <input class="form-control" id="test_text" name="test_text" type="text" value="200" />
                    <span class="input-group-addon">.00</span>
                </div>
            </div>[
]};
$test->get_ok('/formgroup_textfield_5')->status_is(200)->content_is(trimmed($formgroup_textfield_5));

my $formgroup_textfield_6 = q{[
            ]<div class="form-group form-group-lg">
                <label class="control-label" for="test_text">Text test 6</label>
                <input class="form-control" id="test_text" name="test_text" type="text" />
            </div>[
]};
$test->get_ok('/formgroup_textfield_6')->status_is(200)->content_is(trimmed($formgroup_textfield_6));

my $formgroup_textfield_7 = q{[
            <div class="form-group">
                <label class="control-label" for="test_text">[
    ]Text test 7[
]</label>
                <input class="form-control input-xs" id="test_text" name="test_text" type="text" />
            </div>};
$test->get_ok('/formgroup_textfield_7')->status_is(200)->content_is(trimmed($formgroup_textfield_7));

my $formgroup_textfield_8 = q{[
            ]<div class="form-group">
                <label class="control-label col-md-2 col-sm-4" for="test_text">Text test 8</label>
                <div class="col-md-10 col-sm-8">
                    <input class="form-control" id="test_text" name="test_text" type="text" />
                </div>
            </div>[
]};
$test->get_ok('/formgroup_textfield_8')->status_is(200)->content_is(trimmed($formgroup_textfield_8));

my $buttons = q{
            <a class="btn btn-lg" href="http://www.example.com/">The example 1</a>[
]<a class="btn" href="/buttons">The example 2</a>[
]<a class="btn" href="/panel_1">The example 3</a>[
]<button class="btn">The example 4</button>[
]<button class="btn btn-lg btn-warning">The example 5</button>[
]<a class="btn" href="/buttons">[
   ]The Example 6[
]</a>
<button class="btn" type="submit">Save 1</button>[
]<button class="btn btn-primary" type="submit">Save 2</button>[
]};
$test->get_ok('/buttons')->status_is(200)->content_is(trimmed($buttons));


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
@@ panel_1.html.ep
%= bs_panel

@@ panel_2.html.ep
%= bs_panel undef ,=> begin
    <p>In the panel.</p>
%  end

@@ panel_3.html.ep
%= bs_panel 'Test'

@@ panel_4.html.ep
%= bs_panel 'The Header' => begin
    <p>A short text.</p>
%  end

@@ panel_5.html.ep
%= bs_panel 'Panel 5', success => 1 => begin
    <p>A short text.</p>
%  end


@@ formgroup_textfield_1.html.ep
%= bs_formgroup 'Text test 1', text_field => ['test_text']

@@ formgroup_textfield_2.html.ep
%= bs_formgroup 'Text test 2', text_field => ['test_text', size => 30]

@@ formgroup_textfield_3.html.ep
%= bs_formgroup 'Text test 3', text_field => ['test_text', prepend => '@']

@@ formgroup_textfield_4.html.ep
%= bs_formgroup 'Text test 4', text_field => ['test_text', append => '.00', large => 1]

@@ formgroup_textfield_5.html.ep
%= bs_formgroup 'Text test 5', text_field => ['test_text', '200', prepend => '$', append => '.00']

@@ formgroup_textfield_6.html.ep
%= bs_formgroup 'Text test 6', text_field => ['test_text'], large => 1

@@ formgroup_textfield_7.html.ep
%= bs_formgroup text_field => ['test_text', xsmall => 1] => begin
    Text test 7
%  end

@@ formgroup_textfield_8.html.ep
%= bs_formgroup 'Text test 8', text_field => ['test_text'], cols => { medium => [2, 10], small => [4, 8] }


@@ buttons.html.ep
%= bs_button 'The example 1' => ['http://www.example.com/'], lg => 1
%= bs_button 'The example 2' => [url_for]
%= bs_button 'The example 3' => ['panel_1']
%= bs_button 'The example 4'
%= bs_button 'The example 5' => large => 1, warning => 1
%= bs_button [url_for] => begin
   The Example 6
%  end
%= bs_submit 'Save 1'
%= bs_submit 'Save 2', primary => 1
