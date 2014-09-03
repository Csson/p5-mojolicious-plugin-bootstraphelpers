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

    xsmall    default     striped
    small     primary     bordered
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

    name        A specific string
    $name       Any string
    $name[]     An array reference  (ordering significant)
    %name       A hash              (ordering not significant)
    $name{}     A hash reference    (ordering not significant)
    (optional)  Anything inside parenthesis is optional

# HELPERS

## Panels

[Bootstrap documentation](http://getbootstrap.com/components/#panels)

### Syntax

    %= panel ($title, ((%strappings,) begin
        $body
    %  end))

**`$title`**

Usually mandatory, but can be omitted if there are no other arguments to the `panel`. Otherwise, if you don't want a title, set it `undef`.

**`%strappings`**

Optional. Any strapping you want applied to the `panel`.

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

    %= formgroup ($labeltext,) %arguments

    %= formgroup %arguments, begin
        $labeltext
    %  end

    # %arguments:
    (cols => $size_definitions{})
    (%group_strappings)
    $fieldtype => $field_setting[],

    # $size_definitions{}
    { $size => [ $label_columns, $input_columns ](, ...) },

    # $field_setting[]
    $name,
    ($value,)
    (%field_arguments)

    # %field_arguments
    (%html_attributes,)
    (prepend => $to_prepend,)
    (append => $to_append,)
    (%field_strappings)

**`$labeltext`**

Optional. It is either the first argument, or placed in the body. It creates a `label` element before the `input`.

**`%arguments`**

Mandatory:

> **`cols => $size_definitions{}`**
>
> Optional key-value pair. It is only used when the `form` is a `.form-horizontal`. You can define the widths for one or more or all of the sizes.
>
> > **`$size`**
> >
> > Mandatory. It is one of `xsmall`, `small`, `medium`, or `large`. 
> > `$size` takes a two item array reference:
> >
> > > **`$label_columns`**
> > >
> > > Mandatory. The number of columns that should be used by the label for that size.
> > >
> > > **`$input_columns`**
> > >
> > > Mandatory. The number of columns used for the input field for that size.
>
> **`%group_strappings`**
>
> Optional hash. One or more strappings you want applied to the `.form-group` element.
>
> **`$fieldtype`**
>
> Mandatory. Is one of `text_field`, `password_field`, `datetime_field`, `date_field`, `month_field`, `time_field`, `week_field`, 
> `number_field`, `email_field`, `url_field`, `search_field`, `tel_field`, `color_field`.
>
> There can be only one `$fieldtype` per `formgroup`. (Behavior if having more than one is not defined.)
>
> **`$field_setting[]`**
>
> Mandatory. An array reference:
>
> > **`$name`**
> >
> > Mandatory. It sets both the `id` and `name` of the input field. If the `$name` contains dashes then those are translated
> > into underscores when setting the `name`. If `$field_arguments{'id'}` exists then that is used for the `id` instead.
> >
> > **`$value`**
> >
> > Optional. It is the same as setting `$field_arguments{'value'}`. (But don't do both for the same field.)
> >
> > **`%field_arguments`**
> >
> > Optional. A hash:
> >
> > > **`%html_attributes`**
> > >
> > > Optional. All html attributes you want to set on the `input`.
> > >
> > > **`prepend => $to_prepend`**
> > >
> > > Optional key-value pair. Can be used with `append`. They are used to create [input groups](http://getbootstrap.com/components/#input-groups).
> > >
> > > > **`$to_prepend`**
> > > >
> > > > This string is placed directly in front of the `input`.
> > >
> > > **`append => $to_append`**
> > >
> > > Optional key-value pair. Can be used with `prepend`.
> > >
> > > > **`$to_append`**
> > > >
> > > > This string is placed directly after the `input`.
> > >
> > > **`%field_strappings`**
> > >
> > > Optional. All strappings you want applied to the `input`.

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

    %= button $button_text(, $url[])(, %arguments)

    # %arguments
    (%html_attributes,)
    (%strappings)

**`$button_text`**

Mandatory. The text on the button.

**`$url[]`**

Optional array reference. It is handed off to [url\_for](https://metacpan.org/pod/Mojolicious::Controller#url_for), so with it this is
basically [link\_to](https://metacpan.org/pod/Mojolicious::Plugin::TagHelpers#link_to) with Bootstrap classes.

**`%arguments`**

Optional hash:

> **`%html_attributes`**
>
> Optional hash of any html attributes you want to set on the button/link.
>
> **`%strappings`**
>
> Optional hash. Any strappings you want to set on the button/link.

### Examples

    %= button 'The example 5' => large, warning

    <button class="btn btn-lg btn-warning">The example 5</button>

An ordinary button, with applied strappings.

    %= button 'The example 1' => ['http://www.example.com/'], small

    <a class="btn btn-sm" href="http://www.example.com/">The example 1</a>

With a url the button turns into a link.

## Tables

### Syntax

    %= table ($title,) (%arguments,) begin
           $body
    %  end

    # %arguments
    (%html_attributes,)
    (%strappings,)
    (panel => $strappings{})

**`$title`**

Optional. If set the table will be wrapped in a panel. The table replaces the body.

**`$body`**

Mandatory. `thead`, `td` and so on.

**`%arguments`**

Optional hash:

> **`%html_attributes`**
>
> Optional. A hash of html attributes you want applied to the table.
>
> **`%strappings`**
>
> Optional. A hash of the strappings to apply to the table.
>
> **`panel => $strappings{}`**
>
> An optional key-value pair:
>
> > **`$strappings{}`**
> >
> > A hash reference containing any strapping you want to set on the panel.

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

    %= badge $text[, %attr[, right] ]

**`$text`**

Mandatory. If it is `undef` no output is produced.

**`%attr`**

Optional. Any html attributes to apply on the badge.

**`right`**

Optional. The only strapping available.

### Examples

    <%= badge '3' %>

    <span class="badge">3</span></a>
    

A basic badge.

    <%= badge '4', data => { custom => 'yes' }, right %>
    
    <span class="badge pull-right" data-custom="yes">4</span>

A right aligned badge with a data attribute.

# OPTIONS

Some options are available:

    $app->plugin('BootstrapHelpers', {
        tag_prefix => 'bs',
        short_strappings_prefix => 'set',
        init_short_strappings => 1,
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

# AUTHOR

Erik Carlsson <csson@cpan.org>

# COPYRIGHT

Copyright 2014- Erik Carlsson

Bootstrap itself is (c) Twitter. See [their license information](http://getbootstrap.com/getting-started/#license-faqs).

[Mojolicious::Plugin::BootstrapHelpers](https://metacpan.org/pod/Mojolicious::Plugin::BootstrapHelpers) is third party software, and is not endorsed by Twitter.

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
