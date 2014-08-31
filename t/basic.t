use Mojo::Base -strict;

BEGIN {
    $ENV{'MOJO_NO_IPV6'} = 1;
    $ENV{'MOJO_REACTOR'} = 'Mojo::Reactor::Poll';
}

use Test::More;
use Mojolicious::Lite;
use Test::Mojo::Trim;

plugin 'BootstrapHelpers';

my $test = Test::Mojo::Trim->new;

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
get '/button_1';
get '/button_2';
get '/button_3';
get '/button_4';
get '/button_5';
get '/button_6';
get '/button_7';
get '/button_8';


my $panel_1 = qq{
            <div class="panel panel-default">
                <div class="panel-body">
                </div>
            </div>
};
$test->get_ok('/panel_1')->status_is(200)->trimmed_content_is($panel_1);

my $panel_2 = qq{
            <div class="panel panel-default">
                <div class="panel-body">
                    <p>In the panel.</p>
                </div>
            </div>
};
$test->get_ok('/panel_2')->status_is(200)->trimmed_content_is($panel_2);

my $panel_3 = qq{
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Test</h3>
                </div>
                <div class="panel-body">
                </div>
            </div>
};
$test->get_ok('/panel_3')->status_is(200)->trimmed_content_is($panel_3);

my $panel_4 = qq{
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">The Header</h3>
                </div>
                <div class="panel-body">
                    <p>A short text.</p>
                </div>
            </div>
};
$test->get_ok('/panel_4')->status_is(200)->trimmed_content_is($panel_4);

my $panel_5 = qq{
            <div class="panel panel-success">
                <div class="panel-heading">
                    <h3 class="panel-title">Panel 5</h3>
                </div>
                <div class="panel-body">
                    <p>A short text.</p>
                </div>
            </div>
};
$test->get_ok('/panel_5')->status_is(200)->trimmed_content_is($panel_5);

my $formgroup_textfield_1 = q{
            <div class="form-group">
                <label class="control-label" for="test_text">Text test 1</label>
                <input class="form-control" id="test_text" name="test_text" type="text" />
            </div>
};
$test->get_ok('/formgroup_textfield_1')->status_is(200)->trimmed_content_is($formgroup_textfield_1);

my $formgroup_textfield_2 = q{
            <div class="form-group">
                <label class="control-label" for="test_text">Text test 2</label>
                <input class="form-control" id="test_text" name="test_text" size="30" type="text" />
            </div>
};
$test->get_ok('/formgroup_textfield_2')->status_is(200)->trimmed_content_is($formgroup_textfield_2);

my $formgroup_textfield_3 = q{
            <div class="form-group">
                <label class="control-label" for="test_text">Text test 3</label>
                <div class="input-group">
                    <span class="input-group-addon">@</span>
                    <input class="form-control" id="test_text" name="test_text" type="text" />
                </div>
            </div>
};
$test->get_ok('/formgroup_textfield_3')->status_is(200)->trimmed_content_is($formgroup_textfield_3);

my $formgroup_textfield_4 = q{
            <div class="form-group">
                <label class="control-label" for="test_text">Text test 4</label>
                <div class="input-group">
                    <input class="form-control input-lg" id="test_text" name="test_text" type="text" />
                    <span class="input-group-addon">.00</span>
                </div>
            </div>
};
$test->get_ok('/formgroup_textfield_4')->status_is(200)->trimmed_content_is($formgroup_textfield_4);

my $formgroup_textfield_5 = q{
            <div class="form-group">
                <label class="control-label" for="test_text">Text test 5</label>
                <div class="input-group">
                    <span class="input-group-addon">$</span>
                    <input class="form-control" id="test_text" name="test_text" type="text" value="200" />
                    <span class="input-group-addon">.00</span>
                </div>
            </div>
};
$test->get_ok('/formgroup_textfield_5')->status_is(200)->trimmed_content_is($formgroup_textfield_5);

my $formgroup_textfield_6 = q{
            <div class="form-group form-group-lg">
                <label class="control-label" for="test_text">Text test 6</label>
                <input class="form-control" id="test_text" name="test_text" type="text" />
            </div>
};
$test->get_ok('/formgroup_textfield_6')->status_is(200)->trimmed_content_is($formgroup_textfield_6);

my $formgroup_textfield_7 = q{
            <div class="form-group">
                <label class="control-label" for="test_text"> Text test 7 </label>
                <input class="form-control input-xs" id="test_text" name="test_text" type="text" />
            </div>
};
$test->get_ok('/formgroup_textfield_7')->status_is(200)->trimmed_content_is($formgroup_textfield_7);

my $formgroup_textfield_8 = q{
            <div class="form-group">
                <label class="control-label col-md-2 col-sm-4" for="test_text">Text test 8</label>
                <div class="col-md-10 col-sm-8">
                    <input class="form-control" id="test_text" name="test_text" type="text" />
                </div>
            </div>
};
$test->get_ok('/formgroup_textfield_8')->status_is(200)->trimmed_content_is($formgroup_textfield_8);

my @buttons = (
    q{<a class="btn btn-lg" href="http://www.example.com/">The example 1</a>},
    q{<a class="btn" href="/button_2">The example 2</a>},
    q{<a class="btn" href="/panel_1">The example 3</a>},
    q{<button class="btn">The example 4</button>},
    q{<button class="btn btn-lg btn-warning">The example 5</button>},
    q{<a class="btn" href="/button_6"> The Example 6 </a>},
    q{<button class="btn" type="submit">Save 1</button>},
    q{<button class="btn btn-primary" type="submit">Save 2</button>},
);

for (1..scalar @buttons) {
    $test->get_ok("/button_$_")->status_is(200)->trimmed_content_is($buttons[$_-1]);
}


done_testing();

__DATA__
@@ panel_1.html.ep
%= panel

@@ panel_2.html.ep
%= panel undef ,=> begin
    <p>In the panel.</p>
%  end

@@ panel_3.html.ep
%= panel 'Test'

@@ panel_4.html.ep
%= panel 'The Header' => begin
    <p>A short text.</p>
%  end

@@ panel_5.html.ep
%= panel 'Panel 5', success, begin
    <p>A short text.</p>
%  end


@@ formgroup_textfield_1.html.ep
%= formgroup 'Text test 1', text_field => ['test_text']

@@ formgroup_textfield_2.html.ep
%= formgroup 'Text test 2', text_field => ['test_text', size => 30]

@@ formgroup_textfield_3.html.ep
%= formgroup 'Text test 3', text_field => ['test_text', prepend => '@']

@@ formgroup_textfield_4.html.ep
%= formgroup 'Text test 4', text_field => ['test_text', append => '.00', large]

@@ formgroup_textfield_5.html.ep
%= formgroup 'Text test 5', text_field => ['test_text', '200', prepend => '$', append => '.00']

@@ formgroup_textfield_6.html.ep
%= formgroup 'Text test 6', large, text_field => ['test_text']

@@ formgroup_textfield_7.html.ep
%= formgroup text_field => ['test_text', xsmall => 1] => begin
    Text test 7
%  end

@@ formgroup_textfield_8.html.ep
%= formgroup 'Text test 8', text_field => ['test_text'], cols => { medium => [2, 10], small => [4, 8] }


@@ button_1.html.ep
%= button 'The example 1' => ['http://www.example.com/'], lg => 1

@@ button_2.html.ep
%= button 'The example 2' => [url_for]

@@ button_3.html.ep
%= button 'The example 3' => ['panel_1']

@@ button_4.html.ep
%= button 'The example 4'

@@ button_5.html.ep
%= button 'The example 5' => large => 1, warning => 1

@@ button_6.html.ep
%= button [url_for] => begin
   The Example 6
%  end

@@ button_7.html.ep
%= submit_button 'Save 1'

@@ button_8.html.ep
%= submit_button 'Save 2', primary => 1
