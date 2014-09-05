package Mojolicious::Plugin::BootstrapHelpers {
    use strict;
    use true;
    
    use Mojo::Base 'Mojolicious::Plugin';
    
    use List::AllUtils qw/uniq first_index/;
    use Mojo::ByteStream;
    use Mojo::Util 'xml_escape';
    use Scalar::Util 'blessed';
    use String::Trim;
    use Mojolicious::Plugin::BootstrapHelpers::Helpers;

    use experimental 'postderef'; # requires 5.20

    our $VERSION = '0.012';

    sub register {
        my $self = shift;
        my $app = shift;
        my $args = shift;

        my $tp = setup_prefix($args->{'tag_prefix'});
        my $ssp = setup_prefix($args->{'short_strappings_prefix'});
        my $init_short_strappings = $args->{'init_short_strappings'} //= 1;

        $app->helper($tp.'bootstrap' => \&Mojolicious::Plugin::BootstrapHelpers::Helpers::bootstraps_bootstraps);
        $app->helper($tp.'table' => \&Mojolicious::Plugin::BootstrapHelpers::Helpers::bootstrap_table);
        $app->helper($tp.'panel' => \&Mojolicious::Plugin::BootstrapHelpers::Helpers::bootstrap_panel);
        $app->helper($tp.'formgroup' => \&Mojolicious::Plugin::BootstrapHelpers::Helpers::bootstrap_formgroup);
        $app->helper($tp.'button' => \&Mojolicious::Plugin::BootstrapHelpers::Helpers::bootstrap_button);
        $app->helper($tp.'submit_button' => \&Mojolicious::Plugin::BootstrapHelpers::Helpers::bootstrap_submit);
        $app->helper($tp.'badge' => \&Mojolicious::Plugin::BootstrapHelpers::Helpers::bootstrap_badge);
        $app->helper($tp.'dropdown' => \&Mojolicious::Plugin::BootstrapHelpers::Helpers::bootstrap_dropdown);
        
        if(exists $args->{'icons'}{'class'} && $args->{'icons'}{'formatter'}) {
            $app->config->{'Plugin::BootstrapHelpers'} = $args;
            $app->helper($tp.'icon' => \&Mojolicious::Plugin::BootstrapHelpers::Helpers::bootstrap_icon);
        }

        if($init_short_strappings) {
            my @sizes = qw/xsmall small medium large/;
            my @contexts = qw/default primary success info warning danger/;
            my @table = qw/striped bordered hover condensed responsive/;
            my @direction = qw/right/;
            my @menu = qw/caret divider/;

            foreach my $helper (@sizes, @contexts, @table, @direction, @menu) {
               $app->helper($ssp.$helper, sub { ("__$helper" => 1) });
            }
        }
    }

    sub setup_prefix {
        my $prefix = shift;

        return defined $prefix && !length $prefix   ?   '_'
             : defined $prefix && $prefix eq '_'    ?   '_'
             : defined $prefix                      ?   $prefix.'_'
             :                                          ''
             ;
    }

}
__END__

=encoding utf-8

=head1 NAME

Mojolicious::Plugin::BootstrapHelpers - Type less bootstrap

=head1 SYNOPSIS

    # Mojolicious
    $self->plugin('BootstrapHelpers');

    # ::Lite
    plugin 'BootstrapHelpers';

    # Meanwhile, somewhere in a template...
    %= formgroup 'Email' => text_field => ['email-address', cols => { medium => [3, 9] } ], large

    # ...that renders into
    <div class="form-group form-group-lg">
        <label class="control-label" for="email-address">Email</label>
        <div class="input-group">
            <span class="input-group-addon">@</span>
            <input class="form-control" id="email-address" name="email_address" type="text" />
        </div>
    </div>

=head1 STATUS

This is an unstable work in progress. Backwards compatibility is currently not to be expected between releases.

Currently supported Bootstrap version: 3.2.0.

Currently only Perl 5.20+ is supported (thanks to postderef).

=head1 DESCRIPTION

Mojolicious::Plugin::BootstrapHelpers is a convenience plugin that reduces some bootstrap complexity by introducing several tag helpers specifically for L<Bootstrap 3|http://www.getbootstrap.com/>.

The goal is not to have tag helpers for everything, but for common use cases.

All examples below (and more, see tests) is expected to work.


=head2 How to use Bootstrap

If you don't know what Bootstrap is, see L<http://www.getbootstrap.com/> for possible usages.

You might want to use L<Mojolicious::Plugin::Bootstrap3> in your templates.

To get going quickly by using the official CDN you can use the following helpers:
    
    # CSS
    %= bootstrap

    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
    
    # or (if you want to use the theme)
    %= bootstrap 'theme'

    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css">

    # And the javascript
    %= bootstrap 'js'

    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

    # Or just:
    %= bootstrap 'all'

    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css">
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

It is also possible to automatically include jQuery (2.*)
    
    %= bootstrap 'jsq'
    
    <script src="//code.jquery.com/jquery-2.1.1.min.js"></script>
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

    %= bootstrap 'allq'
    
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css">
    <script src="//code.jquery.com/jquery-2.1.1.min.js"></script>
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>


=head2 Strappings

There are several shortcuts ("strappings") for applying context and size classes that automatically expands to the correct class depending 
on which tag it is applied to. For instance, if you apply the C<info> strapping to a panel, it becomes C<panel-info>, but when applied to a button it becomes C<btn-info>.

You can use them in two different ways, but internally they are the same. These to lines are exactly identical:

    %= button 'Push me', primary

    %= button 'Push me', __primary => 1



For sizes, you can only use the longform (C<xsmall>, C<small>, C<medium> and C<large>) no matter if you use the short strapping form or not.
They are shortened to the Bootstrap type classes.

The following strappings are available:

   xsmall    default     striped       caret     right
   small     primary     bordered      divider
   medium    success     hover
   large     info        condensed
             warning     responsive
             danger

Add two leading underscores if you don't want to use the short form.

See below for usage. B<Important:> You can't follow a short form strapping with a fat comma (C<=E<gt>>). The fat comma auto-quotes the strapping, and then it breaks.

If there is no corresponding class for the element you add the strapping to it is silently not applied.

=begin html

<p>The short form is recommended for readability, but it does setup several helpers in your templates. 
You can turn off the short forms, see <a href="#init_short_strappings">init_short_strappings</a>.</p>

=end html

=head2 Syntax convention

In the syntax sections below the following conventions are used:
    
    name            A specific string
    $name           Any string
    %name           One or more key-value pairs, written as:
                      key => 'value', key2 => 'value2'
                         or, if you use short form strappings:
                      primary, large
    $key => [...]   Both of these are array references where the ordering of strings
    key  => [...]     are significant, for example:
                      key => [ $thing, $thing2, %hash ]
    $key => {...}   Both of these are hash references where the ordering of pairs are
    key  => {...}     are insignificant, for example:
                      key => { key2 => $value, key3 => 'othervalue' }
    (...)           Anything between parenthesis is optional. The parenthesis is not part of the
                      actual syntax

Ordering between two hashes that follows each other is also not significant.

B<About C<%has>>

The following applies to all C<%has> hashes below:

=over 4

=item * They refer to any html attributes and/or strappings to apply to the current element.

=item * When helpers are nested, all occurrencies are change to tag-specific names, such as C<%panel_has>.

=item * This hash is always optional. It is not marked so in the definitions below in order to reduce clutter.

=item * Depending on context either the leading or following comma is optional together with the hash. It is usually obvious.

=item * Sometimes on nested helpers (such as tables in panels just below), C<%has> is the only thing that can be applied to 
        the other element. In this case C<panel =E<gt> { %panel_has }>. It follows from above that in those cases this entire
        expression is I<also> optional. Such cases are also not marked as optional in syntax definitions and are not mentioned 
        in syntax description, unless they need further comment.

=back

From this definition:

    %= table ($title,) %table_has, panel => { %panel_has }, begin
           $body
    %  end

Both of these are legal:
    
    # since both panel => { %panel_has } and %table_has are hashes, their ordering is not significant.
    %= table 'Heading Table', panel => { success }, condensed, id => 'the-table', begin
         <tr><td>A Table Cell</td></tr>
    %  end
    

    %= table begin
         <tr><td>A Table Cell</td></tr>
    %  end
        


=head1 HELPERS

=head2 Panels

L<Bootstrap documentation|http://getbootstrap.com/components/#panels>

=head3 Syntax

    %= panel ($title, %has, begin
        $body
    %  end)

B<C<$title>>

Usually mandatory, but can be omitted if there are no other arguments to the C<panel>. Otherwise, if you don't want a title, set it C<undef>.

B<C<$body>>

Optional (but panels are not much use without it). The html inside the C<panel>.


=head3 Examples

B<No body, no title>

    %= panel

    <div class="panel panel-default">
        <div class="panel-body">
        </div>
    </div>

The class is set to C<panel-default>, by default.

B<Body, no title>

    %= panel undef ,=> begin
        <p>A short text.</p>
    %  end

    <div class="panel panel-default">
        <div class="panel-body">
            <p>A short text.</p>
        </div>
    </div>

If you want a panel without title, set the title to C<undef>. Note that you can't use a regular fat comma since that would turn undef into a string. A normal comma is of course also ok.

B<Body and title>

    %= panel 'The header' => begin
        <p>A short text.</p>
    %  end

    <div class="panel panel-default">
        <div class="panel-heading">
            <h3 class="panel-title">The Header</h3>
        </div>
        <div class="panel-body">
            <p>A short text.</p>
        </div>
    </div>

B<Body and title, with context>
    
    %= panel 'Panel 5', success, begin
        <p>A short text.</p>
    %  end
    
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">Panel 5</h3>
        </div>
        <div class="panel-body">
            <p>A short text.</p>
        </div>
    </div>

Here, the C<success> strapping applies C<.panel-success> to the panel.



=head2 Form groups

L<Bootstrap documentation|http://getbootstrap.com/css/#forms>

=head3 Syntax
    
    <%= formgroup ($labeltext,)
                   %formgroup_has,
                  (cols => { $size => [ $label_columns, $input_columns ], (...) })
                   $fieldtype => [
                       $input_name,
                      ($input_value,)
                       %input_has,
                  ]

    %>
    
    # The $labeltext can also be given in the body
    %= formgroup <as above>, begin
        $labeltext
    %  end

B<C<$labeltext>>

Optional. It is either the first argument, or placed in the body. It creates a C<label> element before the C<input>.

B<C<cols>>

Optional. It is only used when the C<form> is a C<.form-horizontal>. You can defined the widths for one or more or all of the sizes. See examples.

=over 4

B<C<$size>>

Mandatory. It is one of C<xsmall>, C<small>, C<medium> or C<large>. C<$size> takes a two item array reference.

=over 4

B<C<$label_columns>>

Mandatory. The number of columns that should be used by the label for that size of screen. Applies C<.col-$size-$label_columns> on the label.

B<C<$input_columns>>

Mandatory. The number of columns that should be used by the input for that size of screen. Applies C<.col-$size-$input_columns> around the input.

=back

=back

B<C<$fieldtype>>

Mandatory. Is one of C<text_field>, C<password_field>, C<datetime_field>, C<date_field>, C<month_field>, C<time_field>, C<week_field>, 
C<number_field>, C<email_field>, C<url_field>, C<search_field>, C<tel_field>, C<color_field>.

There can be only one C<$fieldtype> per C<formgroup>.

=over 4

B<C<$name>>

Mandatory. It sets both the C<id> and C<name> of the input field. If the C<$name> contains dashes then those are translated
into underscores when setting the C<name>. If C<id> exists in C<%input_has> then that is used for the C<id> instead.

B<C<$input_value>>

Optional. If you prefer you can set C<value> in C<%input_has> instead. (But don't do both for the same field.)

=back


=head3 Examples

B<Basic form group>
    
    %= formgroup 'Text test 1', text_field => ['test_text']

    <div class="form-group">
        <label class="control-label" for="test_text">Text test 1</label>
        <input class="form-control" id="test_text" name="test_text" type="text" />
    </div>

The first item in the array ref is used for both C<id> and C<name>. Except...


    %= formgroup 'Text test 4', text_field => ['test_text', large]

    <div class="form-group">
        <label class="control-label" for="test-text">Text test 4</label>
        <div class="input-group">
            <input class="form-control input-lg" id="test-text" name="test_text" type="text" />
            <span class="input-group-addon">.00</span>
        </div>
    </div>

...if the input name (the first item in the text_field array ref) contains dashes -- those are replaced (in the C<name>) to underscores.

Strappings can also be used in this context. Here C<large> applies C<.input-lg>.


B<Input group (before and after), and with value>

    %= formgroup 'Text test 5', text_field => ['test_text', '200' ]

    <div class="form-group">
        <label class="control-label" for="test_text">Text test 5</label>
        <input class="form-control" id="test_text" name="test_text" type="text" value="200" />
    </div>

Here, the second item in the C<text_field> array reference is a value that populates the C<input>.


B<Large input group>

    %= formgroup 'Text test 6', text_field => ['test_text'], large

    <div class="form-group form-group-lg">
        <label class="control-label" for="test_text">Text test 6</label>
        <input class="form-control" id="test_text" name="test_text" type="text" />
    </div>

Note the difference with the earlier example. Here C<large> is outside the C<text_field> array reference, and therefore C<.form-group-lg> is applied to the form group. 


B<Horizontal form groups>
    
    %= formgroup 'Text test 8', text_field => ['test_text'], cols => { medium => [2, 10], small => [4, 8] }

    <div class="form-group">
        <label class="control-label col-md-2 col-sm-4" for="test_text">Text test 8</label>
        <div class="col-md-10 col-sm-8">
            <input class="form-control" id="test_text" name="test_text" type="text" />
        </div>
    </div>

If the C<form> is C<.form-horizontal>, you can set the column widths with the C<cols> attribute. The first item in each array ref is for the label, and the second for the input.

(Note that in this context, C<medium> and C<large> are not short form strappings. Those don't take arguments.)



=head2 Buttons

L<Bootstrap documentation|http://getbootstrap.com/css/#buttons>

=head3 Syntax

    %= button $button_text(, [$url]), %has

    %= submit_button $text, %has

B<C<$button_text>>

Mandatory. The text on the button.

B<C<[$url]>>

Optional array reference. It is handed off to L<url_for|Mojolicious::Controller#url_for>, so with it this is
basically L<link_to|Mojolicious::Plugin::TagHelpers#link_to> with Bootstrap classes.

Not available for C<submit_button>.

=head3 Examples

    %= button 'The example 5' => large, warning

    <button class="btn btn-lg btn-warning">The example 5</button>

An ordinary button, with applied strappings.
    
    %= button 'The example 1' => ['http://www.example.com/'], small

    <a class="btn btn-sm" href="http://www.example.com/">The example 1</a>

With a url the button turns into a link.

    %= submit_button 'Save', __primary

    <button class="btn btn-primary" type="submit">Save 2</button>

A submit button for use in forms. It overrides the build-in submit_button helper.

=head2 Tables

=head3 Syntax
    
    %= table ($title,) %table_has, panel => { %panel_has }, begin
           $body
    %  end
    
B<C<$title>>

Optional. If set the table will be wrapped in a panel, and the table replaces the body in the panel.

B<C<$body>>

Mandatory. C<thead>, C<td> and so on.

B<C<panel =E<gt> { %panel_has }>>

Optional if the table has a C<$title>, otherwise without use.


=head3 Examples

L<Bootstrap documentation|http://getbootstrap.com/css/#tables>

    <%= table begin %>
        <tr><td>Table 1</td></tr>
    <% end %>

    <table class="table">
        <tr><td>Table 1</td></tr>
    </table>

A basic table.

    %= table hover, striped, condensed, begin
        <tr><td>Table 2</td></tr>
    %  end

    <table class="table table-condensed table-hover table-striped">
        <tr><td>Table 2</td></tr>
    </table>

Several classes applied to the table.

    %= table 'Heading Table 4', panel => { success }, condensed, id => 'the-table', begin
        <tr><td>Table 4</td></tr>
    %  end

    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">Heading Table 4</h3>
        </div>
        <table class="table table-condensed" id="the-table">
            <tr><td>Table 4</td></tr>
        </table>
    </div>

A C<condensed> table with an C<id> wrapped in a C<success> panel.


=head2 Badges

=head3 Syntax

    %= badge $text, %has

B<C<$text>>

Mandatory. If it is C<undef> no output is produced.

=head3 Examples

    <%= badge '3' %>

    <span class="badge">3</span></a>
    
A basic badge.

    <%= badge '4', data => { custom => 'yes' }, right %>
    
    <span class="badge pull-right" data-custom="yes">4</span>

A right aligned badge with a data attribute.


=head2 Icons

This helper needs to be activated separately, see options below.

=head3 Syntax

    %= icon $icon_name

B<C<$icon_name>>

Mandatory. The specific icon you wish to create. Possible values depends on your icon pack.

=head3 Examples
    
    <%= icon 'copyright-mark' %>
    %= icon 'sort-by-attributes-alt'

    <span class="glyphicon glyphicon-copyright-mark"></span>
    <span class="glyphicon glyphicon-sort-by-attributes-alt"></span>


=head2 Dropdowns

=head3 Syntax
    
    <%= dropdown  $button_text,
                 (caret,)
                  %has,
                 (button => [ %button_has ],)
                  items  => [ 
                      [ $itemtext, [ $url ], %item_has ],
                     (divider,)
                  ]

Nesting is currently not supported.

B<C<$button_text>>

Mandatory. The text that appears on the menu opening button.

B<C<caret>>

It is a strapping. If it is used a caret (downward facing arrow) will be placed on the button.

B<C<items>>

Mandatory array reference. Here are the items that make up the menu. It takes two different types of value (both can occur any number of times:

=over 4

B<C<divider>>

Creates a horizontal separator in the menu.

B<C<[ $itemtext, [ $url ], %item_has ]>>

This creates a linked menu item.

=over 4

B<C<$itemtext>>

Mandatory. The text on the link.

B<C<$url>>

Mandatory. It sets the C<href> on the link. L<url_for|Mojolicious::Controller#url_for> is used to create the link.

=back

=back

=head3 Examples

    <%= dropdown 'Dropdown 1',
                 button => [id => 'a_custom_id'],
                 items => [
                    ['Item 1', ['item1'] ],
                    ['Item 2', ['item2'] ],
                    divider,
                    ['Item 3', ['item3'] ]
                 ] %>

    <div class="dropdown">
        <button class="btn btn-default dropdown-toggle" type="button" id="a_custom_id" data-toggle="dropdown">Dropdown 1</button>
        <ul class="dropdown-menu">
            <li><a class="menuitem" href="item1" tabindex="-1">Item 1</a></li>
            <li><a class="menuitem" href="item2" tabindex="-1">Item 2</a></li>
            <li class="divider"></li>
            <li><a class="menuitem" href="item3" tabindex="-1">Item 3</a></li>
        </ul>
    </div>

By default, C<tabindex> is set to C<-1>...

    <%= dropdown 'Dropdown 2', caret,
                 items => [
                    ['Item 1', ['item1'], data => { attr => 2 } ],
                    ['Item 2', ['item2'], data => { attr => 4 } ],
                    divider,
                    ['Item 3', ['item3'], data => { attr => 7 } ],
                    divider,
                    ['Item 4', ['item4'], tabindex => 4 ],
                 ] %>

    <div class="dropdown">
        <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">
            Dropdown 2
            <span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
            <li><a class="menuitem" href="item1" tabindex="-1" data-attr="2">Item 1</a></li>
            <li><a class="menuitem" href="item2" tabindex="-1" data-attr="4">Item 2</a></li>
            <li class="divider"></li>
            <li><a class="menuitem" href="item3" tabindex="-1" data-attr="7">Item 3</a></li>
            <li class="divider"></li>
            <li><a class="menuitem" href="item4" tabindex="4">Item 4</a></li>
        </ul>
    </div>

...but it can be overridden.

=head1 OPTIONS

Some options are available:

    $app->plugin('BootstrapHelpers', {
        tag_prefix => 'bs',
        short_strappings_prefix => 'set',
        init_short_strappings => 1,
        icons => {
            class => 'glyphicon'
            formatter => 'glyphicon-%s',
        },
    });

=head2 tag_prefix

Default: C<undef>

If you want to you change the name of the tag helpers, by applying a prefix. These are not aliases; 
by setting a prefix the original names are no longer available. The following rules are used:

=over 4

=item *
If the option is missing, or is C<undef>, there is no prefix.

=item *
If the option is set to the empty string, the prefix is C<_>. That is, C<panel> is now used as C<_panel>.

=item *
If the option is set to any other string, the prefix is that string followed by C<_>. If you set C<tag_prefix =E<gt> 'bs'>, then C<panel> is now used as C<bs_panel>.

=back


=head2 short_strappings_prefix

Default: C<undef>

This is similar to C<tag_prefix>, but is instead applied to the short form strappings. The same rules applies.


=head2 init_short_strappings

Default: C<1>

If you don't want the short form of strappings setup at all, set this option to a defined but false value.

All functionality is available, but instead of C<warning> you must now use C<<__warning => 1>>.

With short form turned off, sizes are still only supported in long form: C<__xsmall>, C<__small>, C<__medium> and C<__large>. The Bootstrap abbreviations (C<xs> - C<lg>) are not used.

=head2 icons

Default: not set

By setting these keys you activate the C<icon> helper. You can pick any icon pack that sets one main class and one subclass to create an icon.

=over 4

B<C<class>>

This is the main icon class. If you use the glyphicon pack, this should be set to 'glyphicon'.

B<C<formatter>>

This creates the specific icon class. If you use the glyphicon pack, this should be set to 'glyphicon-%s', where the '%s' will be replaced by the icon name you give the C<icon> helper.

=back

=head1 AUTHOR

Erik Carlsson E<lt>csson@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2014- Erik Carlsson

Bootstrap itself is (c) Twitter. See L<their license information|http://getbootstrap.com/getting-started/#license-faqs>.

L<Mojolicious::Plugin::BootstrapHelpers> is third party software, and is not endorsed by Twitter.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
 