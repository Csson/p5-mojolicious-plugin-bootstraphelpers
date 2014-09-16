# NAME

Mojolicious::Plugin::BootstrapHelpers - Type less bootstrap

<div>
    <p><a style="float: left;" href="https://travis-ci.org/Csson/p5-mojolicious-plugin-bootstraphelpers"><img src="https://travis-ci.org/Csson/p5-mojolicious-plugin-bootstraphelpers.svg?branch=master">&nbsp;</a>
</div>

# SYNOPSIS

    # Mojolicious
    $self->plugin('BootstrapHelpers');

    # ::Lite
    plugin 'BootstrapHelpers';

    # Meanwhile, somewhere in a template...
    %= formgroup 'Email', text_field => ['email'], large, cols => { small => [3, 9] }

    # ...that renders into
    <div class="form-group form-group-lg">
        <label class="control-label col-sm-3" for="email">Email</label>
        <div class="col-sm-9">
            <input class="form-control" id="email" name="email" type="text">
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
        the other element. In this case `panel => { %panel_has }`. It follows from above that in those cases this entire
        expression is _also_ optional. Such cases are also not marked as optional in syntax definitions and are not mentioned
        in syntax description, unless they need further comment.

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

# HELPERS

[Bootstrap documentation](http://getbootstrap.com/components/#badges)

## Badges

### Syntax

    %= badge $text, %has

**`$text`**

Mandatory. If it is `undef` no output is produced.

**Available strappings**

`right` applies `.pull-right`.

### Examples

    <%= badge '3' %>

    <span class="badge">3</span></a>

<div>
    <p>
    A basic badge.

    </p>
</div>

    <%= badge '4', data => { custom => 'yes' }, right %>

    <span class="badge pull-right" data-custom="yes">4</span>

<div>
    <p>
    A right aligned badge with a data attribute.

    </p>
</div>

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

**Available strappings**

`default` `primary` `success` `info` `warning` `danger` `link` applies the various `.btn-*` classes.

`large` `small` `xsmall` applies `.btn-lg` `.btn-sm` `.btn-xs` respectively.

`active` `block` applies the `.active` and `.block` classes.

`disabled` applies the `.disabled` class if the generated element is an `<a>`. On a `<button>` it applies the `disabled="disabled"` attribute.

### Examples

    %= button 'The example 5' => large, warning

    <button class="btn btn-lg btn-warning" type="button">The example 5</button>

<div>
    <p>
    An ordinary button, with applied strappings.

    </p>
</div>

    %= button 'The example 1' => ['http://www.example.com/'], small

    <a class="btn btn-default btn-sm" href="http://www.example.com/">The example 1</a>

<div>
    <p>
    With a url the button turns into a link.

    </p>
</div>

    %= submit_button 'Save 2', primary

    <button class="btn btn-primary" type="submit">Save 2</button>

<div>
    <p>
    A submit button for use in forms. It overrides the build-in submit_button helper.

    </p>
</div>

## Button groups

### Syntax

There are two different syntaxes. One for single-button dropdowns and one for multi-button dropdowns.

    # multi button
    <%= buttongroup %has,
                    buttons => [
                        [ $button_text, %button_has ],
                        {
                            button => [ $button_text, %button_has ],
                            items => [
                                [ $itemtext, [ $url ], %item_has ],
                               ($headertext,)
                               ([],)
                            ]
                        }
                    ]
    %>

    # single button
    <%= buttongroup {
                        button => [ $button_text, %button_has ],
                        items => [
                            [ $itemtext, [ $url ], %item_has ],
                           ($headertext,)
                           ([],)
                        ]
                    }
    %>

**`buttons => []`**

Single-button: Not available. Multi-button: Mandatory array reference. Takes a list of child elements of two different types:

> **`[ $button_text, %button_has ]`**
>
> Single-button: Not available. Multi-button: Array references are (and take the same arguments as) ordinary [buttons](#buttons). Two exceptions: It can't take a url, and it can take the `caret` strapping.
>
> **`{ ... }`**
>
> Hash references are nested [dropdowns](#dropdowns). Read more there.
>
> For the single-button dropdown, this is the only argument.

### Examples

    <%= buttongroup
        buttons => [
            ['Button 1'],
            ['Button 2'],
            ['Button 3'],
        ]
    %>

    <div class="btn-group">
        <button class="btn btn-default" type="button">Button 1</button>
        <button class="btn btn-default" type="button">Button 2</button>
        <button class="btn btn-default" type="button">Button 3</button>
    </div>

<div>
    <p>
    A basic button group.

    </p>
</div>

    <%= buttongroup small,
        buttons => [
            ['Button 1'],
            { button => ['Dropdown 1', caret],
              items => [
                  ['Item 1', ['item1'] ],
                  ['Item 2', ['item2'] ],
                  [],
                  ['Item 3', ['item3'] ],
              ],
            },
            ['Button 2'],
            ['Button 3'],
        ],
    %>

    <div class="btn-group btn-group-sm">
        <button class="btn btn-default" type="button">Button 1</button>
        <div class="btn-group btn-group-sm">
            <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">Dropdown 1 <span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                <li><a class="menuitem" href="item1" tabindex="-1">Item 1</a></li>
                <li><a class="menuitem" href="item2" tabindex="-1">Item 2</a></li>
                <li class="divider"></li>
                <li><a class="menuitem" href="item3" tabindex="-1">Item 3</a></li>
            </ul>
        </div>
        <button class="btn btn-default" type="button">Button 2</button>
        <button class="btn btn-default" type="button">Button 3</button>
    </div>

<div>
    <p>
    Nested button group. Note that the <code>small</code> strapping is only necessary once. The same classes are automatically applied to the nested <code>.btn-group</code>.

    </p>
</div>

    <%= buttongroup vertical,
        buttons => [
            ['Button 1'],
            { button => ['Dropdown 1', caret],
              items => [
                  ['Item 1', ['item1'] ],
                  ['Item 2', ['item2'] ],
                  [],
                  ['Item 3', ['item3'] ],
              ],
            },
            ['Button 2'],
            ['Button 3'],
        ],
    %>

    <div class="btn-group-vertical">
        <button class="btn btn-default" type="button">Button 1</button>
        <div class="btn-group">
            <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">Dropdown 1 <span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                <li><a class="menuitem" href="item1" tabindex="-1">Item 1</a></li>
                <li><a class="menuitem" href="item2" tabindex="-1">Item 2</a></li>
                <li class="divider"></li>
                <li><a class="menuitem" href="item3" tabindex="-1">Item 3</a></li>
            </ul>
        </div>
        <button class="btn btn-default" type="button">Button 2</button>
        <button class="btn btn-default" type="button">Button 3</button>
    </div>

<div>
    <p>
    Nested button group, with the <code>vertical</code> strapping.

    </p>
</div>

    <%= buttongroup justified,
        buttons => [
            ['Link 1', ['http://www.example.com/'] ],
            ['Link 2', ['http://www.example.com/'] ],
            { dropup,
              button => ['Dropup 1', caret],
              items => [
                  ['Item 1', ['item1'] ],
                  ['Item 2', ['item2'] ],
                  [],
                  ['Item 3', ['item3'] ],
              ],
            },
        ]
    %>

    <div class="btn-group btn-group-justified">
        <a class="btn btn-default" href="http://www.example.com/">Link 1</a>
        <a class="btn btn-default" href="http://www.example.com/">Link 2</a>
        <div class="btn-group dropup">
            <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">Dropup 1 <span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                <li><a class="menuitem" href="item1" tabindex="-1">Item 1</a></li>
                <li><a class="menuitem" href="item2" tabindex="-1">Item 2</a></li>
                <li class="divider"></li>
                <li><a class="menuitem" href="item3" tabindex="-1">Item 3</a></li>
            </ul>
        </div>
    </div>

<div>
    <p>
    Mix links and <code>dropup</code> menus in <code>justified</code> button groups.

    </p>
</div>

    <%= buttongroup
        buttons => [
            ['Link 1', ['http://www.example.com/'] ],
            { button => [undef, caret],
              items => [
                  ['Item 1', ['item1'] ],
                  ['Item 2', ['item2'] ],
                  [],
                  ['Item 3', ['item3'] ],
              ],
            },
        ]
    %>

    <div class="btn-group">
        <a class="btn btn-default" href="http://www.example.com/">Link 1</a>
        <div class="btn-group">
            <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown"><span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                <li><a class="menuitem" href="item1" tabindex="-1">Item 1</a></li>
                <li><a class="menuitem" href="item2" tabindex="-1">Item 2</a></li>
                <li class="divider"></li>
                <li><a class="menuitem" href="item3" tabindex="-1">Item 3</a></li>
            </ul>
        </div>
    </div>

<div>
    <p>
    Split button dropdowns uses the same syntax as any other multi-button dropdown. Set the <code>caret</code> button title to <code>undef</code>.

    </p>
</div>

    <%= buttongroup { button => ['Default', caret],
                      items  => [
                          ['Item 1', ['item1'] ],
                          ['Item 2', ['item2'] ],
                          [],
                          ['Item 3', ['item3'] ],
                      ],
                    }
    %>

    <%= buttongroup { button => ['Big danger', caret, large, danger],
                      items  => [
                          ['Item 1', ['item1'] ],
                          ['Item 2', ['item2'] ],
                          [],
                          ['Item 3', ['item3'] ],
                      ],
                    }
    %>

    <div class="btn-group">
        <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">Default <span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
            <li><a class="menuitem" href="item1" tabindex="-1">Item 1</a></li>
            <li><a class="menuitem" href="item2" tabindex="-1">Item 2</a></li>
            <li class="divider"></li>
            <li><a class="menuitem" href="item3" tabindex="-1">Item 3</a></li>
        </ul>
    </div>

    <div class="btn-group">
        <button class="btn btn-danger btn-lg dropdown-toggle" type="button" data-toggle="dropdown">Big danger <span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
            <li><a class="menuitem" href="item1" tabindex="-1">Item 1</a></li>
            <li><a class="menuitem" href="item2" tabindex="-1">Item 2</a></li>
            <li class="divider"></li>
            <li><a class="menuitem" href="item3" tabindex="-1">Item 3</a></li>
        </ul>
    </div>

<div>
    <p>
    Using the shortcut to create one-button button group dropdowns.
    </p>
</div>

## Dropdowns

### Syntax

    <%= dropdown  %has,
                  button => [ $button_text, %button_has ],
                  items  => [
                      [ $itemtext, [ $url ], %item_has ],
                     ($headertext,)
                     ([],)
                  ]

**`button => []`**

Mandatory array reference. Takes the same arguments as an ordinary [button](#buttons), with two exceptions: It can't take a url, and it can take the `caret` strapping.

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
>
> **`$headertext`**
>
> A string creates a dropdown header.
>
> **`[]`**
>
> An empty array reference creates a divider.

**Available strappings**

`caret` adds a `<span class="caret"></span<>` element on the button.

### Examples

    <%= dropdown
         button => ['Dropdown 1', id => 'a_custom_id'],
         right,
         items => [
            ['Item 1', ['item1'] ],
            ['Item 2', ['item2'] ],
            [],
            ['Item 3', ['item3'] ]
         ] %>

    <div class="dropdown">
        <button class="btn btn-default dropdown-toggle" type="button" id="a_custom_id" data-toggle="dropdown">Dropdown 1</button>
        <ul class="dropdown-menu dropdown-menu-right">
            <li><a class="menuitem" href="item1" tabindex="-1">Item 1</a></li>
            <li><a class="menuitem" href="item2" tabindex="-1">Item 2</a></li>
            <li class="divider"></li>
            <li><a class="menuitem" href="item3" tabindex="-1">Item 3</a></li>
        </ul>
    </div>

<div>
    <p>
    By default, <code>tabindex</code> is set to <code>-1</code>...

    </p>
</div>

    <%= dropdown
         button => ['Dropdown 2', caret, large, primary],
         items => [
            ['Item 1', ['item1'], data => { attr => 2 } ],
            ['Item 2', ['item2'], disabled, data => { attr => 4 } ],
            [],
            ['Item 3', ['item3'], data => { attr => 7 } ],
            [],
            ['Item 4', ['item4'], tabindex => 4 ],
            'This is a header',
            ['Item 5', ['item5'] ],
         ] %>

    <div class="dropdown">
        <button class="btn btn-lg btn-primary dropdown-toggle" type="button" data-toggle="dropdown">Dropdown 2 <span class="caret"></span></button>
        <ul class="dropdown-menu">
            <li><a class="menuitem" href="item1" tabindex="-1" data-attr="2">Item 1</a></li>
            <li class="disabled"><a class="menuitem" href="item2" tabindex="-1" data-attr="4">Item 2</a></li>
            <li class="divider"></li>
            <li><a class="menuitem" href="item3" tabindex="-1" data-attr="7">Item 3</a></li>
            <li class="divider"></li>
            <li><a class="menuitem" href="item4" tabindex="4">Item 4</a></li>
            <li class="dropdown-header">This is a header</li>
            <li><a class="menuitem" href="item5" tabindex="-1">Item 5</a></li>
        </ul>
    </div>

<div>
    <p>
    ...but it can be overridden.
    </p>
</div>

## Form groups

[Bootstrap documentation](http://getbootstrap.com/css/#forms)

### Syntax

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

**`$labeltext`**

Optional. It is either the first argument, or placed in the body. It creates a `label` element before the `input`.

**`cols`**

Optional. It is only used when the `form` is a `.form-horizontal`. You can defined the widths for one or more or all of the sizes. See examples.

> **`$size`**
>
> Mandatory. It is one of `xsmall`, `small`, `medium` or `large`. `$size` takes a two item array reference.
>
> > **`$label_columns`**
> >
> > Mandatory. The number of columns that should be used by the label for that size of screen. Applies `.col-$size-$label_columns` on the label.
> >
> > **`$input_columns`**
> >
> > Mandatory. The number of columns that should be used by the input for that size of screen. Applies `.col-$size-$input_columns` around the input.

**`$fieldtype`**

Mandatory. Is one of `text_field`, `password_field`, `datetime_field`, `date_field`, `month_field`, `time_field`, `week_field`,
`number_field`, `email_field`, `url_field`, `search_field`, `tel_field`, `color_field`.

There can be only one `$fieldtype` per `formgroup`.

> **`$name`**
>
> Mandatory. It sets both the `id` and `name` of the input field. If the `$name` contains dashes then those are translated
> into underscores when setting the `name`. If `id` exists in `%input_has` then that is used for the `id` instead.
>
> **`$input_value`**
>
> Optional. If you prefer you can set `value` in `%input_has` instead. (But don't do both for the same field.)

### Examples

    %= formgroup 'Text test 1', text_field => ['test_text']

    <div class="form-group">
        <label class="control-label" for="test_text">Text test 1</label>
        <input class="form-control" id="test_text" name="test_text" type="text" />
    </div>

<div>
    <p>
    The first item in the array ref is used for both <code>id</code> and <code>name</code>. Except...

    </p>
</div>

    %= formgroup 'Text test 4', text_field => ['test-text', large]

    <div class="form-group">
        <label class="control-label" for="test-text">Text test 4</label>
        <input class="form-control input-lg" id="test-text" name="test_text" type="text" />
    </div>

<div>
    <p>
    ...if the input name (the first item in the text_field array ref) contains dashes -- those are replaced (in the <code>name</code>) to underscores.

    </p>
</div>

    %= formgroup 'Text test 5', text_field => ['test_text', '200' ]

    <div class="form-group">
        <label class="control-label" for="test_text">Text test 5</label>
        <input class="form-control" id="test_text" name="test_text" type="text" value="200" />
    </div>

<div>
    <p>
    An input with a value.

    </p>
</div>

    <form class="form-horizontal">
        %= formgroup 'Text test 6', text_field => ['test_text'], large, cols => { small => [2, 10] }
    </form>

    <form class="form-horizontal">
        <div class="form-group form-group-lg">
            <label class="control-label col-sm-2" for="test_text">Text test 6</label>
            <div class="col-sm-10">
                <input class="form-control" id="test_text" name="test_text" type="text">
            </div>
        </div>
    </form>

<div>
    <p>
    Note the difference with the earlier example. Here <code>large</code> is outside the <code>text_field</code> array reference, and therefore <code>.form-group-lg</code> is applied to the form group.

    </p>
</div>

    %= formgroup 'Text test 8', text_field => ['test_text'], cols => { medium => [2, 10], small => [4, 8] }

    <div class="form-group">
        <label class="control-label col-md-2 col-sm-4" for="test_text">Text test 8</label>
        <div class="col-md-10 col-sm-8">
            <input class="form-control" id="test_text" name="test_text" type="text" />
        </div>
    </div>

<div>
    <p>
    A formgroup used in a <code>.form-horizontal</code> <code>form</code>.

    (Note that in this context, <code>medium</code> and <code>large</code> are not short form strappings. Those don't take arguments.)

    </p>
</div>

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

    %= panel

    <div class="panel panel-default">
        <div class="panel-body">
        </div>
    </div>

<div>
    <p>
    The class is set to <code>.panel-default</code>, by default.

    </p>
</div>

    %= panel undef ,=> begin
        <p>A short text.</p>
    %  end

    <div class="panel panel-default">
        <div class="panel-body">
            <p>A short text.</p>
        </div>
    </div>

<div>
    <p>
    If you want a panel without title, set the title to <code>undef</code>.

    </p>
</div>

    %= panel 'The Header' => begin
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

## Tables

[Bootstrap documentation](http://getbootstrap.com/css/#tables)

### Syntax

    %= table ($title,) %table_has, panel => { %panel_has }, begin
           $body
    %  end

**`$title`**

Optional. If set the table will be wrapped in a panel, and the table replaces the body in the panel.

**`$body`**

Mandatory. `thead`, `td` and so on.

**`panel => { %panel_has }`**

Optional if the table has a `$title`, otherwise without use.

### Examples

<div>
    <p>

    </p>
</div>

    <%= table begin %>
        <tr><td>Table 1</td></tr>
    <% end %>

    <table class="table">
        <tr><td>Table 1</td></tr>
    </table>

<div>
    <p>
    A basic table.

    </p>
</div>

    %= table hover, striped, condensed, begin
        <tr><td>Table 2</td></tr>
    %  end

    <table class="table table-condensed table-hover table-striped">
        <tr><td>Table 2</td></tr>
    </table>

<div>
    <p>
    Several classes applied to the table.

    </p>
</div>

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

<div>
    <p>
    A <code>condensed</code> table with an <code>id</code> wrapped in a <code>success</code> panel.

    </p>
</div>

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
- If the option is set to any other string, the prefix is that string. If you set `tag_prefix => 'bs'`, then `panel` is now used as `bspanel`.

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
