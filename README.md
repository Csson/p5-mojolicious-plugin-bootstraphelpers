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

# DESCRIPTION

Mojolicious::Plugin::BootstrapHelpers is a convenience plugin that reduces some bootstrap complexity by introducing several tag helpers specifically for [Bootstrap 3](http://www.getbootstrap.com/).

The goal is not to have tag helpers for everything, but for common use cases.

All examples below (and more, see tests) currently works.

## Panels

[Bootstrap documentation](http://getbootstrap.com/components/#panels)

### No body, no title

    %= bs_panel

    <div class="panel panel-default">
        <div class="panel-body">
        </div>
    </div>

### Body, no title

    %= bs_panel undef ,=> begin
        <p>A short text.</p>
    %  end

    <div class="panel panel-default">
        <div class="panel-body">
            <p>A short text.</p>
        </div>
    </div>

### Body and title

    %= bs_panel 'The header' => begin
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

### Body and title, with context

    %= bs_panel 'Panel 5', success => 1 => begin
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

## Form groups

[Bootstrap documentation](http://getbootstrap.com/css/#forms)

### Basic form group

    %= bs_formgroup 'Text test 1', text_field => ['test_text']

    <div class="form-group">
        <label class="control-label" for="test_text">Text test 1</label>
        <input class="form-control" id="test_text" name="test_text" type="text" />
    </div>

The first item in the array ref is used for both `id` and `name`.

### Input group (before), and large input field

    %= bs_formgroup 'Text test 4', text_field => ['test_text', append => '.00', large => 1]

    <div class="form-group">
        <label class="control-label" for="test_text">Text test 4</label>
        <div class="input-group">
            <input class="form-control input-lg" id="test_text" name="test_text" type="text" />
            <span class="input-group-addon">.00</span>
        </div>
    </div>

### Input group (before and after), and with value

    %= bs_formgroup 'Text test 5', text_field => ['test_text', '200', prepend => '$', append => '.00']

    <div class="form-group">
        <label class="control-label" for="test_text">Text test 5</label>
        <div class="input-group">
            <span class="input-group-addon">$</span>
            <input class="form-control" id="test_text" name="test_text" type="text" value="200" />
            <span class="input-group-addon">.00</span>
        </div>
    </div>

The (optional) second item in the array ref is the value, if any, that should populate the input tag.

### Large input group

    %= bs_formgroup 'Text test 6', text_field => ['test_text'], large => 1

    <div class="form-group form-group-lg">
        <label class="control-label" for="test_text">Text test 6</label>
        <input class="form-control" id="test_text" name="test_text" type="text" />
    </div>

Note the difference with the earlier example. Here `large => 1` is outside the `text_field` array ref, and therefore is applied to the form group. 

    %= bs_formgroup 'Text test 8', text_field => ['test_text'], cols => { medium => [2, 10], small => [4, 8] }

    <div class="form-group">
        <label class="control-label col-md-2 col-sm-4" for="test_text">Text test 8</label>
        <div class="col-md-10 col-sm-8">
            <input class="form-control" id="test_text" name="test_text" type="text" />
        </div>
    </div>

If the `form` has the `form-horizontal` class, you can set the column widths with the `cols` attribute. The first item in each array ref is for the label, and the second for the input.

# AUTHOR

Erik Carlsson <csson@cpan.org>

# COPYRIGHT

Copyright 2014- Erik Carlsson

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

# POD ERRORS

Hey! **The above document had some coding errors, which are explained below:**

- Around line 139:

    Unknown directive: =head
