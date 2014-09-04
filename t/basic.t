use Mojo::Base -strict;

BEGIN {
    $ENV{'MOJO_NO_IPV6'} = 1;
    $ENV{'MOJO_REACTOR'} = 'Mojo::Reactor::Poll';
}

use Test::More;
use Mojolicious::Lite;
use Test::Mojo::Trim;

plugin 'BootstrapHelpers', {
    icons => { 
        class => 'glyphicon',
        formatter => 'glyphicon-%s',
    },
};

my $test = Test::Mojo::Trim->new;

my @bootstraps = (
    q{
        <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
    },
    q{
        <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css">
    },
    q{
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
    },
    q{
        <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
    },
    q{
        <script src="//code.jquery.com/jquery-2.1.1.min.js"></script>
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
    },
    q{
        <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css">
        <script src="//code.jquery.com/jquery-2.1.1.min.js"></script>
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
    },
);

test($test, 'bootstrap', @bootstraps);


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
    q{
        <div class="form-group">
            <input class="form-control" id="test-text-9" name="test_text_9" type="text" />
        </div>
    },
);
test($test, 'formgroup', @formgroups);


my @buttons = (
    q{<a class="btn btn-default btn-sm" href="http://www.example.com/">The example 1</a>},
    q{<a class="btn btn-default" href="/button_2">The example 2</a>},
    q{<a class="btn btn-default" href="/panel_1">The example 3</a>},
    q{<button class="btn btn-default">The example 4</button>},
    q{<button class="btn btn-lg btn-warning">The example 5</button>},
    q{<a class="btn btn-default" href="/button_6"> The Example 6 </a>},
    q{<button class="btn btn-default" type="submit">Save 1</button>},
    q{<button class="btn btn-primary" type="submit">Save 2</button>},
);

test($test, 'button', @buttons);


my @tables = (
    q{
        <table class="table">
            <tr><td>Table 1</td></tr>
        </table>
    },
    q{
        <table class="table table-condensed table-hover table-striped">
            <tr><td>Table 2</td></tr>
        </table>
    },
    q{
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Heading Table 3</h3>
            </div>
            <table class="table table-condensed table-hover table-striped">
                <tr><td>Table 3</td></tr>
            </table>
        </div>
    },
    q{
        <div class="panel panel-success">
            <div class="panel-heading">
                <h3 class="panel-title">Heading Table 4</h3>
            </div>
            <table class="table table-condensed" id="the-table">
                <tr><td>Table 4</td></tr>
            </table>
        </div>
    },
);

test($test, 'table', @tables);



my @badges = (
    q{
        <span class="badge">Badge 1</span></a>
    },
    q{
        <span class="badge pull-right">Badge 2</span>
    },
    q{

    },
    q{
        <span class="badge pull-right" data-custom="yes">Badge 4</span>
    },
);

test($test, 'badge', @badges);

my @icons = (
    q{<span class="glyphicon glyphicon-copyright-mark"></span>},
    q{<span class="glyphicon glyphicon-sort-by-attributes-alt"></span>},
);

test($test, 'icon', @icons);


my @dropdowns = (
    q{
        <div class="dropdown">
            <button class="btn btn-default dropdown-toggle" type="button" id="a_custom_id" data-toggle="dropdown">Dropdown 1<span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                <li><a class="menuitem" href="item1" tabindex="-1">Item 1</a></li>
                <li><a class="menuitem" href="item2" tabindex="-1">Item 2</a></li>
                <li class="divider"></li>
                <li><a class="menuitem" href="item3" tabindex="-1">Item 3</a></li>
            </ul>
        </div>
    },
    q{
        <div class="dropdown">
            <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">Dropdown 1<span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                <li><a class="menuitem" href="item1" tabindex="-1" data-attr="2">Item 1</a></li>
                <li><a class="menuitem" href="item2" tabindex="-1" data-attr="4">Item 2</a></li>
                <li class="divider"></li>
                <li><a class="menuitem" href="item3" tabindex="-1" data-attr="7">Item 3</a></li>
            </ul>
        </div>
    },
);

test($test, 'dropdown', @dropdowns);

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
@@ bootstrap_1.html.ep
%= bootstrap

@@ bootstrap_2.html.ep
%= bootstrap 'css'

@@ bootstrap_3.html.ep
%= bootstrap 'js'

@@ bootstrap_4.html.ep
%= bootstrap 'all'

@@ bootstrap_5.html.ep
%= bootstrap 'jsq'

@@ bootstrap_6.html.ep
%= bootstrap 'allq'


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

@@ formgroup_9.html.ep
%= formgroup text_field => ['test-text-9']


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

@@ button_group_1.html.ep
<%= button_group justified,
    contents => [
        button => ['Button Group 1', ['#'], medium],
        button => ['Button Group 1 button 2', dropdown],

    ],
      
%>


@@ table_1.html.ep
<%= table begin %>
    <tr><td>Table 1</td></tr>
<% end %>

@@ table_2.html.ep
%= table hover, striped, condensed, begin
    <tr><td>Table 2</td></tr>
%  end

@@ table_3.html.ep
%= table 'Heading Table 3', hover, striped, condensed, begin
    <tr><td>Table 3</td></tr>
%  end

@@ table_4.html.ep
%= table 'Heading Table 4', panel => { success }, condensed, id => 'the-table', begin
    <tr><td>Table 4</td></tr>
%  end


@@ badge_1.html.ep 
%= badge 'Badge 1'

@@ badge_2.html.ep
%= badge 'Badge 2', right

@@ badge_3.html.ep
% my $empty_badge = '';
%= badge $empty_badge

@@ badge_4.html.ep
<%= badge 'Badge 4', data => { custom => 'yes' }, right %>


@@ icon_1.html.ep
<%= icon 'copyright-mark' %>

@@ icon_2.html.ep
%= icon 'sort-by-attributes-alt'


@@ dropdown_1.html.ep
<%= dropdown 'Dropdown 1', caret,
             button => [id => 'a_custom_id'],
             items => [
                ['Item 1', ['item1'] ],
                ['Item 2', ['item2'] ],
                divider,
                ['Item 3', ['item3'] ]
             ] %>

@@ dropdown_2.html.ep
<%= dropdown 'Dropdown 1', caret,
             items => [
                ['Item 1', ['item1'], data => { attr => 2 } ],
                ['Item 2', ['item2'], data => { attr => 4 } ],
                divider,
                ['Item 3', ['item3'], data => { attr => 7 } ]
             ] %>