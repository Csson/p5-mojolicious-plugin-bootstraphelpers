# NAME

Mojolicious::Plugin::BootstrapHelpers - Type less bootstrap

# SYNOPSIS

    # Mojolicious
    $self->plugin('BootstrapHelpers');

    # ::Lite
    plugin 'BootstrapHelpers';

# STATUS

This is an unstable work in progress. Backwards compatibility is currently not to be expected between releases.

Currently supported Bootstrap version: 3.2.0.

Only Perl 5.20+ is supported (thanks to postderef). This might change.

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

    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">

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

## Shortcuts

There are several shortcuts for context and size classes, that automatically expands to the correct class depending on which tag it is applied to.
They can be seen as a hash key and value merged into one.

For instance, if you apply the `info` shortcut to a panel, it becomes `panel-info`, but when applied to a button it becomes `btn-info`.

For sizes, you can only use the longform (`xsmall`, `small`, `medium` and `large`), they are shortened to the Bootstrap type classes.

The following shortcuts are available:

    xsmall    default     striped
    small     primary     bordered
    medium    success     hover
    large     info        condensed
              warning     responsive
              danger

See below for usage. **Important:** You can't follow a shortcut with a fat comma (`=>`). The fat comma auto-quotes the shortcut, and then the shortcut is not a shortcut anymore.

If there is no corresponding class for the element you add the shortcut to it is silently not applied.

<div>
    You can turn off shortcuts, see <a href="#init_shortcuts">init_shortcuts</a>.
</div>

## Panels

[Bootstrap documentation](http://getbootstrap.com/components/#panels)

#### Syntax

    %= panel

    %= panel $title, %arguments, begin
    %  end

- `$title` can only be omitted, when there are no other arguments to `panel`. If you don't want a title, set it `undef`.
- `%arguments` is a hash, ordering is not important. 
        You can also use shortcuts.
        They contain both a key and a value.
        No html attributes can (currently) be added to panels.

### Examples

#### No body, no title

    %= panel

    <div class="panel panel-default">
        <div class="panel-body">
        </div>
    </div>

The class is set to `panel-default`, by default.

#### Body, no title

    %= panel undef ,=> begin
        <p>A short text.</p>
    %  end

    <div class="panel panel-default">
        <div class="panel-body">
            <p>A short text.</p>
        </div>
    </div>

If you want a panel without title, set the title to `undef`. Note that you can't use a regular fat comma since that would turn undef into a string. A normal comma is of course also ok.

#### Body and title

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

#### Body and title, with context

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

The first shortcut, `success`. This applies `.panel-success`.

## Form groups

[Bootstrap documentation](http://getbootstrap.com/css/#forms)

### Syntax

    %= formgroup $labeltext, %arguments

    %= formgroup %arguments, begin
        $labeltext
    %  end

    # %arguments:
    text_field     => [ $name, $value, %field_arguments ]
    password_field => I<(same)>
    datetime_field => I<(same)>
    date_field     => I<(same)>
    month_field    => I<(same)>
    time_field     => I<(same)>
    week_field     => I<(same)>
    number_field   => I<(same)>
    email_field    => I<(same)>
    url_field      => I<(same)>
    search_field   => I<(same)>
    tel_field      => I<(same)>
    color_field    => I<(same)>

    cols => { $size => [ $label_columns, $input_columns ], ... }

    @shortcuts

**`$labeltext`**

Mandatory. It is either the first argument, or placed in the body.

**`%arguments`**

A hash.

- `cols` takes a hash reference. It is only used when the `form` is a `.form-horizontal`. 
        `$size` is one of `xsmall`, `small`, `medium`, or `large`. They each
        take a two item array reference: `$label_columns` is the number of columns that should be used by the label for 
        that size, and `$input_columns` is the number of columns used for the input field for that size. You can defined the widths
        for one or more or all of the sizes.
- `@shortcuts` is one or more shortcuts that you want applied to the `.form-group` element.
- Only **one** of the many `_field` arguments is permitted per `formgroup`. Behavior if having more than one is not defined.
        They each take an array reference:
    - `$name` is mandatory. It sets both the `id` and `name` of the input field. If the `$name` contains dashes, those are translated
            into underscores. If `$field_arguments{'id'}` exists then that is used for the `id` instead.
    - `$value` is optional. It is the same as setting `$field_arguments{'value'}`. (But don't do both for the same field.)
    - `%field_arguments` is a hash. It takes all shortcuts and html attributes you want applied to the `input`.

#### Basic form group

    %= formgroup 'Text test 1', text_field => ['test_text']

    <div class="form-group">
        <label class="control-label" for="test_text">Text test 1</label>
        <input class="form-control" id="test_text" name="test_text" type="text" />
    </div>

The first item in the array ref is used for both `id` and `name`. Except...

#### Input group (before), and large input field

    %= formgroup 'Text test 4', text_field => ['test-text', append => '.00', large]

    <div class="form-group">
        <label class="control-label" for="test_text">Text test 4</label>
        <div class="input-group">
            <input class="form-control input-lg" id="test-text" name="test_text" type="text" />
            <span class="input-group-addon">.00</span>
        </div>
    </div>

Shortcuts can also be used in this context. Here `large` applies `.input-lg`.

If the input name (the first item in the text\_field array ref) contains dashes, those are replaced (in the `name`) to underscores.

#### Input group (before and after), and with value

    %= formgroup 'Text test 5', text_field => ['test_text', '200', prepend => '$', append => '.00']

    <div class="form-group">
        <label class="control-label" for="test_text">Text test 5</label>
        <div class="input-group">
            <span class="input-group-addon">$</span>
            <input class="form-control" id="test_text" name="test_text" type="text" value="200" />
            <span class="input-group-addon">.00</span>
        </div>
    </div>

The (optional) second item in the array ref is the value, if any, that should populate the input tag.

#### Large input group

    %= formgroup 'Text test 6', text_field => ['test_text'], large

    <div class="form-group form-group-lg">
        <label class="control-label" for="test_text">Text test 6</label>
        <input class="form-control" id="test_text" name="test_text" type="text" />
    </div>

Note the difference with the earlier example. Here `large` is outside the `text_field` array ref, and therefore `.form-group-lg` is applied to the form group. 

#### Horizontal form groups

    %= formgroup 'Text test 8', text_field => ['test_text'], cols => { medium => [2, 10], small => [4, 8] }

    <div class="form-group">
        <label class="control-label col-md-2 col-sm-4" for="test_text">Text test 8</label>
        <div class="col-md-10 col-sm-8">
            <input class="form-control" id="test_text" name="test_text" type="text" />
        </div>
    </div>

If the `form` is `.form-horizontal`, you can set the column widths with the `cols` attribute. The first item in each array ref is for the label, and the second for the input.

(Note that in this context, `medium` and `large` are not shortcuts. Shortcuts don't take arguments.)

## Buttons

[Bootstrap documentation](http://getbootstrap.com/css/#buttons)

    %= button 'The example 5' => large, warning

    <button class="btn btn-lg btn-warning">The example 5</button>

An ordinary button, with applied shortcuts.

    %= button 'The example 1' => ['http://www.example.com/'], small

    <a class="btn btn-sm" href="http://www.example.com/">The example 1</a>

If the first argument after the button text is an array ref, it is used to populate `href` and turns the button into a link. 
The url is handed off [url\_for](https://metacpan.org/pod/Mojolicious::Controller#url_for), so this is basically [link\_to](https://metacpan.org/pod/Mojolicious::Plugin::TagHelpers#link_to) with Bootstrap classes.

## Tables

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

# OPTIONS

Some options are available:

    $app->plugin('BootstrapHelpers', {
        tag_prefix => 'bs',
        shortcut_prefix => 'set',
        init_shortcuts => 1,
    });

## tag\_prefix

Default: `undef`

If you want to you change the name of the tag helpers, by applying a prefix. These are not aliases; 
by setting a prefix the original names are no longer available. The following rules are used:

- If the option is missing, or is `undef`, there is no prefix.
- If the option is set to the empty string, the prefix is `_`. That is, `panel` is now used as `_panel`.
- If the option is set to any other string, the prefix is that string followed by `_`. If you set `tag_prefix => 'bs'`, then `panel` is now used as `bs_panel`.

## shortcut\_prefix

Default: `undef`

This is similar to `tag_prefix`, but is instead applied to the shortcuts. The same rules applies.

## init\_shortcuts

Default: `1`

If you don't want the shortcuts setup at all, set this option to a defined but false value.

All functionality is available, but instead of `warning` you must now use `__warning => 1`. That is why they are called shortcuts.

With shortcuts turned off, sizes are only supported in longform: `__xsmall`, `__small`, `__medium` and `__large`.

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

- Around line 257:

    &#x3d;back without =over
