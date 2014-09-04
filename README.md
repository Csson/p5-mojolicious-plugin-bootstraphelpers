# NAME

Mojolicious::Plugin::BootstrapHelpers - Type less bootstrap

# SYNOPSIS

    # Mojolicious
    $self->plugin('BootstrapHelpers');

    # ::Lite
    plugin 'BootstrapHelpers';

    # Meanwhile, somewhere in a template...
    %= formgroup 'Email' => text_field => ['email-address', prepend => '@'], large

    # ...that renders into
    <div class="form-group form-group-lg">
        <label class="control-label" for="email-address">Email</label>
        <div class="input-group">
            <span class="input-group-addon">@</span>
            <input class="form-control" id="email-address" name="email_address" type="text" />
        </div>
    </div>

# STATUS

This is an unstable work in progress. Backwards compatibility is currently not to be expected between releases.

Currently supported Bootstrap version: 3.2.0.

Currently only Perl 5.20+ is supported (thanks to postderef).

# DESCRIPTION

Mojolicious::Plugin::BootstrapHelpers is a convenience plugin that reduces some bootstrap complexity by introducing several tag helpers specifically for [Bootstrap 3](http://www.getbootstrap.com/).

The goal is not to have tag helpers for everything, but for common use cases.

All examples below (and more, see tests) is expected to work.

## How to use Bootstrap

If you don't know what Bootstrap is, see [http://www.getbootstrap.com/](http://www.getbootstrap.com/) for possible usages.

You might want to use [Mojolicious::Plugin::Bootstrap3](https://metacpan.org/pod/Mojolicious::Plugin::Bootstrap3) in your templates.

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

It is also possible to automatically include jQuery (2.\*)

    %= bootstrap 'jsq'
    
    <script src="//code.jquery.com/jquery-2.1.1.min.js"></script>
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

    %= bootstrap 'allq'
    
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css">
    <script src="//code.jquery.com/jquery-2.1.1.min.js"></script>
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

## Strappings

There are several shortcuts ("strappings") for applying context and size classes that automatically expands to the correct class depending 
on which tag it is applied to. For instance, if you apply the `info` strapping to a panel, it becomes `panel-info`, but when applied to a button it becomes `btn-info`.

You can use them in two different ways, but internally they are the same. These to lines are exactly identical:

    %= button 'Push me', primary

    %= button 'Push me', __primary => 1

For sizes, you can only use the longform (`xsmall`, `small`, `medium` and `large`) no matter if you use the short strapping form or not.
They are shortened to the Bootstrap type classes.

The following strappings are available:

    xsmall    default     striped       caret     right
    small     primary     bordered      divider
    medium    success     hover
    large     info        condensed
              warning     responsive
              danger

Add two leading underscores if you don't want to use the short form.

See below for usage. **Important:** You can't follow a short form strapping with a fat comma (`=>`). The fat comma auto-quotes the strapping, and then it breaks.

If there is no corresponding class for the element you add the strapping to it is silently not applied.

<div>
    <p>The short form is recommended for readability, but it does setup several helpers in your templates. 
    You can turn off the short forms, see <a href="#init_short_strappings">init_short_strappings</a>.</p>
</div>

## Syntax convention

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

**About `%has`**

The following applies to all `%has` hashes below:

- They refer to any html attributes and/or strappings to apply to the current element.
- When helpers are nested, all occurrencies are change to tag-specific names, such as `%panel_has`.
- This hash is always optional. It is not marked so in the definitions below in order to reduce clutter.
- Depending on context either the leading or following comma is optional together with the hash. It is usually obvious.
- Sometimes on nested helpers (such as tables in panels just below), `%has` is the only thing that can be applied to 
        the other element. In this case `panel => { %panel_har }`. It follows from above that in those cases this entire
        expression is _also_ optional. Such cases are also not marked as optional in syntax definitions and are not mentioned 
        in syntax description, unless they need further comment.

From this definition:

    %= table ($title,) %table_har, panel => { %panel_har }, begin
           $body
    %  end

Both of these are legal:

    # since both panel => { %panel_har } and %table_har are hashes, their ordering is not significant.
    %= table 'Heading Table', panel => { success }, condensed, id => 'the-table', begin
         <tr><td>A Table Cell</td></tr>
    %  end
    

    %= table begin
         <tr><td>A Table Cell</td></tr>
    %  end
        

# HELPERS

## Panels

[Bootstrap documentation](http://getbootstrap.com/components/#panels)

### Syntax

    %= panel ($title, %has, begin
        $body
    %  end)

**`$title`**

Usually mandatory, but can be omitted if there are no other arguments to the `panel`. Otherwise, if you don't want a title, set it `undef`.

**`$body`**

Optional (but panels are not much use without it). The html inside the `panel`.

### Examples

**No body, no title**

    %= panel

    <div class="panel panel-default">
        <div class="panel-body">
        </div>
    </div>

The class is set to `panel-default`, by default.

**Body, no title**

    %= panel undef ,=> begin
        <p>A short text.</p>
    %  end

    <div class="panel panel-default">
        <div class="panel-body">
            <p>A short text.</p>
        </div>
    </div>

If you want a panel without title, set the title to `undef`. Note that you can't use a regular fat comma since that would turn undef into a string. A normal comma is of course also ok.

**Body and title**

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

**Body and title, with context**

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

Here, the `success` strapping applies `.panel-success` to the panel.

## Form groups

[Bootstrap documentation](http://getbootstrap.com/css/#forms)

### Syntax

    <%= formgroup ($labeltext,)
                   %formgroup_has,
                   $fieldtype => [
                       $input_name,
                      ($input_value,)
                       %input_has,
                  ]

    %>
    
    # The $labeltext can also be given in the body
    %= formgroup %arguments_as_above, begin
        $labeltext
    %  end

**`$labeltext`**

Optional. It is either the first argument, or placed in the body. It creates a `label` element before the `input`.

**`$fieldtype`**

Mandatory. Is one of `text_field`, `password_field`, `datetime_field`, `date_field`, `month_field`, `time_field`, `week_field`, 
`number_field`, `email_field`, `url_field`, `search_field`, `tel_field`, `color_field`.

There can be only one `$fieldtype` per `formgroup`.

> **`$name`**
>
> Mandatory. It sets both the `id` and `name` of the input field. If the `$name` contains dashes then those are translated
> into underscores when setting the `name`. If `id` exists in `%input_has` then that is used for the `id` instead.
>
> **`$value`**
>
> Optional. If you prefer you can set `value` in `%input_has` instead. (But don't do both for the same field.)

### Examples

**Basic form group**

    %= formgroup 'Text test 1', text_field => ['test_text']

    <div class="form-group">
        <label class="control-label" for="test_text">Text test 1</label>
        <input class="form-control" id="test_text" name="test_text" type="text" />
    </div>

The first item in the array ref is used for both `id` and `name`. Except...

**Input group (before), and large input field**

    %= formgroup 'Text test 4', text_field => ['test-text', append => '.00', large]

    <div class="form-group">
        <label class="control-label" for="test_text">Text test 4</label>
        <div class="input-group">
            <input class="form-control input-lg" id="test-text" name="test_text" type="text" />
            <span class="input-group-addon">.00</span>
        </div>
    </div>

Strappings can also be used in this context. Here `large` applies `.input-lg`.

If the input name (the first item in the text\_field array ref) contains dashes, those are replaced (in the `name`) to underscores.

**Input group (before and after), and with value**

    %= formgroup 'Text test 5', text_field => ['test_text', '200', prepend => '$', append => '.00']

    <div class="form-group">
        <label class="control-label" for="test_text">Text test 5</label>
        <div class="input-group">
            <span class="input-group-addon">$</span>
            <input class="form-control" id="test_text" name="test_text" type="text" value="200" />
            <span class="input-group-addon">.00</span>
        </div>
    </div>

Here, the second item in the `text_field` array reference is a value that populates the `input`.

**Large input group**

    %= formgroup 'Text test 6', text_field => ['test_text'], large

    <div class="form-group form-group-lg">
        <label class="control-label" for="test_text">Text test 6</label>
        <input class="form-control" id="test_text" name="test_text" type="text" />
    </div>

Note the difference with the earlier example. Here `large` is outside the `text_field` array reference, and therefore `.form-group-lg` is applied to the form group. 

**Horizontal form groups**

    %= formgroup 'Text test 8', text_field => ['test_text'], cols => { medium => [2, 10], small => [4, 8] }

    <div class="form-group">
        <label class="control-label col-md-2 col-sm-4" for="test_text">Text test 8</label>
        <div class="col-md-10 col-sm-8">
            <input class="form-control" id="test_text" name="test_text" type="text" />
        </div>
    </div>

If the `form` is `.form-horizontal`, you can set the column widths with the `cols` attribute. The first item in each array ref is for the label, and the second for the input.

(Note that in this context, `medium` and `large` are not short form strappings. Those don't take arguments.)

## Buttons

[Bootstrap documentation](http://getbootstrap.com/css/#buttons)

### Syntax

    %= button $button_text(, [$url]), %has

    %= submit_button $text, %has

**`$button_text`**

Mandatory. The text on the button.

**`[$url]`**

Optional array reference. It is handed off to [url\_for](https://metacpan.org/pod/Mojolicious::Controller#url_for), so with it this is
basically [link\_to](https://metacpan.org/pod/Mojolicious::Plugin::TagHelpers#link_to) with Bootstrap classes.

Not available for `submit_button`.

### Examples

    %= button 'The example 5' => large, warning

    <button class="btn btn-lg btn-warning">The example 5</button>

An ordinary button, with applied strappings.

    %= button 'The example 1' => ['http://www.example.com/'], small

    <a class="btn btn-sm" href="http://www.example.com/">The example 1</a>

With a url the button turns into a link.

    %= submit_button 'Save', __primary

    <button class="btn btn-primary" type="submit">Save 2</button>

A submit button for use in forms. It overrides the build-in submit\_button helper.

## Tables

### Syntax

    %= table ($title,) %table_har, panel => { %panel_har }, begin
           $body
    %  end
    

**`$title`**

Optional. If set the table will be wrapped in a panel, and the table replaces the body in the panel.

**`$body`**

Mandatory. `thead`, `td` and so on.

**`panel => { %panel_har }`**

Optional if the table has a `$title`, otherwise without use.

### Examples

[Bootstrap documentation](http://getbootstrap.com/css/#tables)

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

A `condensed` table with an `id` wrapped in a `success` panel.

## Badges

### Syntax

    %= badge $text, %has

**`$text`**

Mandatory. If it is `undef` no output is produced.

### Examples

    <%= badge '3' %>

    <span class="badge">3</span></a>
    

A basic badge.

    <%= badge '4', data => { custom => 'yes' }, right %>
    
    <span class="badge pull-right" data-custom="yes">4</span>

A right aligned badge with a data attribute.

## Icons

This helper needs to be activated separately, see options below.

### Syntax

    %= icon $icon_name

**`$icon_name`**

Mandatory. The specific icon you wish to create. Possible values depends on your icon pack.

### Examples

    <%= icon 'copyright-mark' %>
    %= icon 'sort-by-attributes-alt'

    <span class="glyphicon glyphicon-copyright-mark"></span>
    <span class="glyphicon glyphicon-sort-by-attributes-alt"></span>

## Dropdowns

### Syntax

    <%= dropdown  $button_text,
                 (caret,)
                  %has,
                 (button => [ %button_has ],)
                  items  => [ 
                      [ $itemtext, [ $url ], %item_has ],
                     (divider,)
                  ]

**`$button_text`**

Mandatory. The text that appears on the menu opening button.

**`caret`**

It is a strapping. If it is used a caret (downward facing arrow) will be placed on the button.

**`items`**

Mandatory array reference. Here are the items that make up the menu. It takes two different types of value (both can occur any number of times:

> **`[ $itemtext, [ $url ], %item_has ]`**
>
> This creates a linked menu item.
>
> > **`$itemtext`**
> >
> > Mandatory. The text on the link.
> >
> > **`$url`**
> >
> > Mandatory. It sets the `href` on the link. [url\_for](https://metacpan.org/pod/Mojolicious::Controller#url_for) is used to create the link.

**`divider`**

Creates a horizontal separator in the menu.

# OPTIONS

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

## tag\_prefix

Default: `undef`

If you want to you change the name of the tag helpers, by applying a prefix. These are not aliases; 
by setting a prefix the original names are no longer available. The following rules are used:

- If the option is missing, or is `undef`, there is no prefix.
- If the option is set to the empty string, the prefix is `_`. That is, `panel` is now used as `_panel`.
- If the option is set to any other string, the prefix is that string followed by `_`. If you set `tag_prefix => 'bs'`, then `panel` is now used as `bs_panel`.

## short\_strappings\_prefix

Default: `undef`

This is similar to `tag_prefix`, but is instead applied to the short form strappings. The same rules applies.

## init\_short\_strappings

Default: `1`

If you don't want the short form of strappings setup at all, set this option to a defined but false value.

All functionality is available, but instead of `warning` you must now use `<__warning =` 1>>.

With short form turned off, sizes are still only supported in long form: `__xsmall`, `__small`, `__medium` and `__large`. The Bootstrap abbreviations (`xs` - `lg`) are not used.

## icons

Default: not set

By setting these keys you activate the `icon` helper. You can pick any icon pack that sets one main class and one subclass to create an icon.

> **`class`**
>
> This is the main icon class. If you use the glyphicon pack, this should be set to 'glyphicon'.
>
> **`formatter`**
>
> This creates the specific icon class. If you use the glyphicon pack, this should be set to 'glyphicon-%s', where the '%s' will be replaced by the icon name you give the `icon` helper.

# AUTHOR

Erik Carlsson <csson@cpan.org>

# COPYRIGHT

Copyright 2014- Erik Carlsson

Bootstrap itself is (c) Twitter. See [their license information](http://getbootstrap.com/getting-started/#license-faqs).

[Mojolicious::Plugin::BootstrapHelpers](https://metacpan.org/pod/Mojolicious::Plugin::BootstrapHelpers) is third party software, and is not endorsed by Twitter.

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# POD ERRORS

Hey! **The above document had some coding errors, which are explained below:**

- Around line 661:

    You forgot a '=back' before '=head1'
