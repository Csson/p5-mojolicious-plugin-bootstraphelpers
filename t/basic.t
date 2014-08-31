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

my @panels = (
    qq{
        <div class="panel panel-default">
            <div class="panel-body">
            </div>
        </div>
    },
    qq{
        <div class="panel panel-default">
            <div class="panel-body">
                <p>In the panel.</p>
            </div>
        </div>
    },
    qq{
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Test</h3>
            </div>
            <div class="panel-body">
            </div>
        </div>
    },
    qq{
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">The Header</h3>
            </div>
            <div class="panel-body">
                <p>A short text.</p>
            </div>
        </div>
    },
    qq{
        <div class="panel panel-success">
            <div class="panel-heading">
                <h3 class="panel-title">Panel 5</h3>
            </div>
            <div class="panel-body">
                <p>A short text.</p>
            </div>
        </div>
    },
);

test($test, 'panel', @panels);



my @formgroups = (
    q{
        <div class="form-group">
            <label class="control-label" for="test-text">Text test 1</label>
            <input class="form-control" id="test-text" name="test_text" type="text" />
        </div>
    },
    q{
        <div class="form-group">
            <label class="control-label" for="test_text">Text test 2</label>
            <input class="form-control" id="test_text" name="test_text" size="30" type="text" />
        </div>
    },
    q{
        <div class="form-group">
            <label class="control-label" for="test_text">Text test 3</label>
            <div class="input-group">
                <span class="input-group-addon">@</span>
                <input class="form-control" id="test_text" name="test_text" type="text" />
            </div>
        </div>
    },
    q{
        <div class="form-group">
            <label class="control-label" for="test_text">Text test 4</label>
            <div class="input-group">
                <input class="form-control input-lg" id="test_text" name="test_text" type="text" />
                <span class="input-group-addon">.00</span>
            </div>
        </div>
    },
    q{
        <div class="form-group">
            <label class="control-label" for="test_text">Text test 5</label>
            <div class="input-group">
                <span class="input-group-addon">$</span>
                <input class="form-control" id="test_text" name="test_text" type="text" value="200" />
                <span class="input-group-addon">.00</span>
            </div>
        </div>
    },
    q{
        <div class="form-group form-group-lg">
            <label class="control-label" for="test_text">Text test 6</label>
            <input class="form-control" id="test_text" name="test_text" type="text" />
        </div>
    },
    q{
        <div class="form-group">
            <label class="control-label" for="test_text"> Text test 7 </label>
            <input class="form-control input-xs" id="test_text" name="test_text" type="text" />
        </div>
    },
    q{
        <div class="form-group">
            <label class="control-label col-md-2 col-sm-4" for="test_text">Text test 8</label>
            <div class="col-md-10 col-sm-8">
                <input class="form-control" id="test_text" name="test_text" type="text" />
            </div>
        </div>
    },
);
test($test, 'formgroup', @formgroups);


my @buttons = (
    q{<a class="btn btn-sm" href="http://www.example.com/">The example 1</a>},
    q{<a class="btn" href="/button_2">The example 2</a>},
    q{<a class="btn" href="/panel_1">The example 3</a>},
    q{<button class="btn">The example 4</button>},
    q{<button class="btn btn-lg btn-warning">The example 5</button>},
    q{<a class="btn" href="/button_6"> The Example 6 </a>},
    q{<button class="btn" type="submit">Save 1</button>},
    q{<button class="btn btn-primary" type="submit">Save 2</button>},
);

test($test, 'button', @buttons);



done_testing();

sub test {
    my $test = shift;
    my $url_base = shift;
    my @tests = @_;

    for (1..scalar @tests) {
        my $named = "${url_base}_$_";
        my $url = "/$named";
        get $url => $named;
        $test->get_ok($url)->status_is(200)->trimmed_content_is($tests[$_ - 1]);
    }
}

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


@@ formgroup_1.html.ep
%= formgroup 'Text test 1', text_field => ['test-text']

@@ formgroup_2.html.ep
%= formgroup 'Text test 2', text_field => ['test_text', size => 30]

@@ formgroup_3.html.ep
%= formgroup 'Text test 3', text_field => ['test_text', prepend => '@']

@@ formgroup_4.html.ep
%= formgroup 'Text test 4', text_field => ['test_text', append => '.00', large]

@@ formgroup_5.html.ep
%= formgroup 'Text test 5', text_field => ['test_text', '200', prepend => '$', append => '.00']

@@ formgroup_6.html.ep
%= formgroup 'Text test 6', large, text_field => ['test_text']

@@ formgroup_7.html.ep
%= formgroup text_field => ['test_text', xsmall] => begin
    Text test 7
%  end

@@ formgroup_8.html.ep
%= formgroup 'Text test 8', text_field => ['test_text'], cols => { medium => [2, 10], small => [4, 8] }


@@ button_1.html.ep
%= button 'The example 1' => ['http://www.example.com/'], small

@@ button_2.html.ep
%= button 'The example 2' => [url_for]

@@ button_3.html.ep
%= button 'The example 3' => ['panel_1']

@@ button_4.html.ep
%= button 'The example 4'

@@ button_5.html.ep
%= button 'The example 5' => large, warning

@@ button_6.html.ep
%= button [url_for] => begin
   The Example 6
%  end

@@ button_7.html.ep
%= submit_button 'Save 1'

@@ button_8.html.ep
%= submit_button 'Save 2', primary
