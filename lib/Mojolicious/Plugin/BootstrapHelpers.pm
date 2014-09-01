package Mojolicious::Plugin::BootstrapHelpers {
    use strict;
    use true;
    
    use Mojo::Base 'Mojolicious::Plugin';
    
    use List::AllUtils 'first_index';
    use Mojo::ByteStream;
    use Mojo::Util 'xml_escape';
    use Scalar::Util 'blessed';
    use String::Trim;

    use experimental 'postderef';

    our $VERSION = 0.009;

    sub bootstraps_bootstraps {
        my $c = shift;
        my $arg = shift;

        my $css   = q{<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">};
        my $theme = q{<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css">};
        my $js    = q{<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>};
        my $jq    = q{<script src="//code.jquery.com/jquery-2.1.1.min.js"></script>};

        return out(
              !defined $arg  ? $css
            : $arg eq 'css'  ? $css . $theme
            : $arg eq 'js'   ? $js
            : $arg eq 'jsq'  ? $jq . $js
            : $arg eq 'all'  ? $css . $theme . $js
            : $arg eq 'allq' ? $css . $theme . $jq . $js
            :                 ''
        );
    }

    sub bootstrap_panel {
        my($c, $title, $callback, $content, $attr) = parse_call(@_);
        
        $attr = add_classes($attr, 'panel', { panel => 'panel-%s', panel_default => 'default'});
        
        my $body = qq{
                <div class="panel-body">
                    } . contents($callback, $content) . qq{
                </div>
        };

        return create_panel($title, $body, $attr);

    }

    sub create_panel {
        my $title = shift;
        my $body = shift;
        my $attr = shift;
        
        my $tag = qq{
            <div class="$attr->{'class'}">
            } . (defined $title ? qq{
                <div class="panel-heading">
                    <h3 class="panel-title">$title</h3>
                </div>
            } : '') . qq{
                $body
            </div>
        };

        return out($tag);
    }

    sub bootstrap_table {
        my $c = shift;
        my $callback = ref $_[-1] eq 'CODE' ? pop : undef;
        my $title = scalar @_ % 2 ? shift : undef;
        my $attr = parse_attributes(@_);
        
        $attr = add_classes($attr, 'table', { table => 'table-%s' });
        my $html = htmlify_attrs($attr);

        my $table = qq{
            <table class="$attr->{'class'}"$html>
            } . $callback->() . qq{
            </table>
        };

        if(defined $title) {
            $attr->{'panel'} = add_classes($attr->{'panel'}, 'panel', { panel => 'panel-%s', panel_default => 'default'});
        }


        return defined $title ? create_panel($title, $table, $attr->{'panel'}) : out($table);
    }

    sub htmlify_attrs {
        my $attr = cleanup_attrs({shift->%*}); #* Make a copy

        my $html = join ' ' => map { qq{$_="$attr->{ $_ }"} } sort keys $attr->%*;
        return ' ' . $html if defined $html;
        return '';
    }

    sub bootstrap_formgroup {
        my $c = shift;
        my $title = ref $_[-1] eq 'CODE' ? pop 
                  : scalar @_ % 2        ? shift
                  :                        undef;
        my $attr = parse_attributes(@_);
        
        $attr->{'column_information'} = delete $attr->{'cols'} if ref $attr->{'cols'} eq 'HASH';

        my($id, $input) = fix_input($c, $attr);
        my $label = defined $title ? fix_label($c, $id, $title, $attr) : '';

        $attr = add_classes($attr, 'form-group', { size => 'form-group-%s'});
        $attr = cleanup_attrs($attr);


        my $tag = qq{
            <div class="$attr->{'class'}">
                $label
                $input
            </div>
        };

        return out($tag);
    }

    sub bootstrap_button {
        my $c = shift;
        my $content = ref $_[-1] eq 'CODE' ? pop : shift;

        my @url = shift->@* if ref $_[0] eq 'ARRAY';
        my $attr = { @_ };
        
        $attr = add_classes($attr, 'btn', { size => 'btn-%s', button => 'btn-%s' });
        $attr = cleanup_attrs($attr);

        # We have an url
        if(scalar @url) {
            $attr->{'href'} = $c->url_for(@url)->to_string;
            return out(Mojolicious::Plugin::TagHelpers::_tag('a', $attr->%*, $content));
        }
        else {
            return out(Mojolicious::Plugin::TagHelpers::_tag('button', $attr->%*, $content));
        }

    }

    sub bootstrap_submit {
        push @_ => (type => 'submit');
        return bootstrap_button(@_);
    }

    sub fix_input {
        my $c = shift;
        my $attr = shift;
        
        my $tagname = (grep { exists $attr->{"${_}_field"} } qw/date datetime month time week color email number range search tel text url password/)[0];
        my $info = $attr->{"${tagname}_field"};
        my $id = shift $info->@*;
        
        # if odd number of elements, the first one is the value (shortcut to avoid having to: value => 'value')
        if($info->@* % 2) {
            push $info->@* => (value => shift $info->@*);
        }
        my $tag_attr = { $info->@* };

        my @column_classes = get_column_classes($attr->{'column_information'}, 1);
        $tag_attr = add_classes($tag_attr, 'form-control', { size => 'input-%s' });
        $tag_attr->{'id'} //= $id;
        my $name_attr = $id =~ s{-}{_}rg;

        my $prepend = delete $tag_attr->{'prepend'};
        my $append = delete $tag_attr->{'append'};
        $tag_attr = cleanup_attrs($tag_attr);

        my $horizontal_before = scalar @column_classes ? qq{<div class="} . (trim join ' ' => @column_classes) . '">' : '';
        my $horizontal_after = scalar @column_classes ? '</div>' : '';
        my $input = Mojolicious::Plugin::TagHelpers::_input($c, $name_attr, $tag_attr->%*, type => $tagname);

        # input group not requested
        if(!defined $prepend && !defined $append) {
            return ($id => $horizontal_before . $input . $horizontal_after);
        }

        return $id => qq{
            $horizontal_before
            <div class="input-group">
                } . ($prepend ? qq{<span class="input-group-addon">$prepend</span>} : '') . qq{
                $input
                } . ($append ? qq{<span class="input-group-addon">$append</span>} : '') . qq{
            </div>
            $horizontal_after
        };

    }

    sub fix_label {
        my $c = shift;
        my $for = shift;
        my $title = shift;
        my $attr = shift;

        my @column_classes = get_column_classes($attr->{'column_information'}, 0);
        my @args = (class => trim join ' ' => ('control-label', @column_classes));
        ref $title eq 'CODE' ? push @args => $title : unshift @args => $title;

        return Mojolicious::Plugin::TagHelpers::_label_for($c, $for, @args);
    }

    sub parse_call {
        my $c = shift;
        my $title = shift;
        my $callback = ref $_[-1] eq 'CODE' ? pop : undef;
        my $content = scalar @_ % 2 ? pop : '';
        my $attr = parse_attributes(@_);

        return ($c, $title, $callback, $content, $attr);
    }

    sub parse_attributes {
        my %attr = @_;
        if($attr{'data'} && ref $attr{'data'} eq 'HASH') {
            while(my($key, $value) = each %{ $attr{'data'} }) {
                $key =~ tr/_/-/;
                $attr{ lc("data-$key") } = $value;
            }
            delete $attr{'data'};
        }
        return \%attr;
    }

    sub get_column_classes {
        my $attr = shift;
        my $index = shift;

        my @classes = ();
        foreach my $key (keys $attr->%*) {
            my $correct_name = get_size_for($key);
            if(defined $correct_name) {
                push @classes => sprintf "col-%s-%d" => $correct_name, $attr->{ $key }[ $index ];
            }
        }
        return sort @classes;
    }

    sub add_classes {
        my $attr = shift;
        my $formatter = ref $_[-1] eq 'HASH' ? pop : undef;

        no warnings 'uninitialized';

        my @classes = ($attr->{'class'}, @_);

        if(exists $formatter->{'size'}) {
            push @classes => sprintfify_class($attr, $formatter->{'size'}, $formatter->{'size_default'}, _sizes());
        }
        if(exists $formatter->{'button'}) {
            push @classes => sprintfify_class($attr, $formatter->{'button'}, $formatter->{'button_default'}, _button_contexts());
        }
        if(exists $formatter->{'panel'}) {
            push @classes => sprintfify_class($attr, $formatter->{'panel'}, $formatter->{'panel_default'}, _panel_contexts());
        }
        if(exists $formatter->{'table'}) {
            push @classes => sprintfify_class($attr, $formatter->{'table'}, $formatter->{'table_default'}, _table_contexts());
        }

        $attr->{'class'} = trim join ' ' => sort @classes;

        return $attr;
        
    }

    sub sprintfify_class {
        my $attr = shift;
        my $format = shift;
        my $possibilities = pop;
        my $default = shift;

        my @founds = (grep { exists $attr->{ $_ } } (keys $possibilities->%*));

        return if !scalar @founds && !defined $default;
        push @founds => $default if !scalar @founds;

        return map { sprintf $format => $possibilities->{ $_ } } @founds;

    }

    sub contents {
        my $callback = shift;
        my $content = shift;

        return defined $callback ? $callback->() : xml_escape($content);
    }

    sub cleanup_attrs {
        my $hash = shift;
        
        map { delete $hash->{ $_ } } ('column_information',
                                      'panel',
                                      keys _sizes()->%*,
                                      keys _button_contexts()->%*,
                                      keys _panel_contexts()->%*,
                                      keys _table_contexts()->%*);
        # delete all attributes starting with __
        map { delete $hash->{ $_ } } grep { substr $_, 0 => 2 eq '__' } keys $hash->%*;
        return $hash;
    }

    sub get_size_for {
        my $input = shift;

        return _sizes()->{ $input };
    }

    sub _sizes {
        return {
            __xsmall => 'xs', xsmall => 'xs', xs => 'xs',
            __small  => 'sm', small  => 'sm', sm => 'sm',
            __medium => 'md', medium => 'md', md => 'md',
            __large  => 'lg', large  => 'lg', lg => 'lg',
        }
    }

    sub _button_contexts {
        return { map { ("__$_" => $_, $_ => $_) } qw/default primary success info warning danger link/ };
    }
    sub _panel_contexts {
        return { map { ("__$_" => $_, $_ => $_) } qw/default primary success info warning danger/ };
    }
    sub _table_contexts {
        return { map { ("__$_" => $_, $_ => $_) } qw/striped bordered hover condensed responsive/ };
    }

    sub out {
        my $tag = shift;
        return Mojo::ByteStream->new($tag);
    }

    sub register {
        my $self = shift;
        my $app = shift;
        my $args = shift;

        my $tp = setup_prefix($args->{'tag_prefix'});
        my $ssp = setup_prefix($args->{'short_strappings_prefix'});
        my $init_short_strappings = $args->{'init_short_strappings'} //= 1;

        $app->helper($tp.'bootstrap' => \&bootstraps_bootstraps);
        $app->helper($tp.'table' => \&bootstrap_table);
        $app->helper($tp.'panel' => \&bootstrap_panel);
        $app->helper($tp.'formgroup' => \&bootstrap_formgroup);
        $app->helper($tp.'button' => \&bootstrap_button);
        $app->helper($tp.'submit_button' => \&bootstrap_submit);

        if($init_short_strappings) {
            my @sizes = qw/xsmall small medium large/;
            my @contexts = qw/default primary success info warning danger/;
            my @table = qw/striped bordered hover condensed responsive/;

            foreach my $helper (@sizes, @contexts, @table) {
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
    %= formgroup 'Email' => text_field => ['email-address', prepend => '@'], large

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

   xsmall    default     striped
   small     primary     bordered
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
    
    name        A specific string
    $name       Any string
    $name[]     An array reference  (ordering significant)
    %name       A hash              (ordering not significant)
    $name{}     A hash reference    (ordering not significant)
    (optional)  Anything inside parenthesis is optional


=head1 HELPERS

=head2 Panels

L<Bootstrap documentation|http://getbootstrap.com/components/#panels>

=head3 Syntax

    %= panel ($title, ((%strappings,) begin
        $body
    %  end))

B<C<$title>>

Usually mandatory, but can be omitted if there are no other arguments to the C<panel>. Otherwise, if you don't want a title, set it C<undef>.

B<C<%strappings>>

Optional. Any strapping you want applied to the C<panel>.

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

    %= formgroup ($labeltext,) %arguments

    %= formgroup %arguments, begin
        $labeltext
    %  end

    # %arguments:
    (cols => $size_definitions{})
    (%group_strappings)
    $fieldtype => $field_setting[],
    
    # $field_setting[]
    $name,
    ($value,)
    (%field_arguments)
    
    # $size_definitions{}
    { $size => [ $label_columns, $input_columns ](, ...) },

    # %field_arguments
    (%html_attributes,)
    (prepend => $to_prepend,)
    (append => $to_append,)
    (%field_strappings)

B<C<$labeltext>>

Optional. It is either the first argument, or placed in the body. It creates a C<label> element before the C<input>.

B<C<%arguments>>

Mandatory:

=over 4

B<C<cols =E<gt> $size_definitions{}>>

Optional key-value pair. It is only used when the C<form> is a C<.form-horizontal>. You can define the widths for one or more or all of the sizes.

=over 4

B<C<$size>>

Mandatory. It is one of C<xsmall>, C<small>, C<medium>, or C<large>. 
C<$size> takes a two item array reference:

=over 4

B<C<$label_columns>>

Mandatory. The number of columns that should be used by the label for that size.

B<C<$input_columns>>

Mandatory. The number of columns used for the input field for that size.

=back

=back


B<C<%group_strappings>>

Optional hash. One or more strappings you want applied to the C<.form-group> element.

B<C<$fieldtype>>

Mandatory. Is one of C<text_field>, C<password_field>, C<datetime_field>, C<date_field>, C<month_field>, C<time_field>, C<week_field>, 
C<number_field>, C<email_field>, C<url_field>, C<search_field>, C<tel_field>, C<color_field>.

There can be only one C<$fieldtype> per C<formgroup>. (Behavior if having more than one is not defined.)

B<C<$field_setting[]>>

Mandatory. An array reference:

=over 4

B<C<$name>>

Mandatory. It sets both the C<id> and C<name> of the input field. If the C<$name> contains dashes then those are translated
into underscores when setting the C<name>. If C<$field_arguments{'id'}> exists then that is used for the C<id> instead.

B<C<$value>>

Optional. It is the same as setting C<$field_arguments{'value'}>. (But don't do both for the same field.)

B<C<%field_arguments>>

Optional. A hash:

=over 4

B<C<%html_attributes>>

Optional. All html attributes you want to set on the C<input>.


B<C<prepend =E<gt> $to_prepend>>

Optional key-value pair. Can be used with C<append>. They are used to create L<input groups|http://getbootstrap.com/components/#input-groups>.

=over 4

B<C<$prepend>>

This string is placed directly in front of the C<input>.

=back

B<C<append =E<gt> $to_append>>

Optional key-value pair. Can be used with C<prepend>.

=over 4

B<C<$append>>

This string is placed directly after the C<input>.

=back


B<C<%field_strappings>>

Optional. All strappings you want applied to the C<input>.

=back

=back

=back


=head3 Examples

B<Basic form group>
    
    %= formgroup 'Text test 1', text_field => ['test_text']

    <div class="form-group">
        <label class="control-label" for="test_text">Text test 1</label>
        <input class="form-control" id="test_text" name="test_text" type="text" />
    </div>

The first item in the array ref is used for both C<id> and C<name>. Except...


B<Input group (before), and large input field>

    %= formgroup 'Text test 4', text_field => ['test-text', append => '.00', large]

    <div class="form-group">
        <label class="control-label" for="test_text">Text test 4</label>
        <div class="input-group">
            <input class="form-control input-lg" id="test-text" name="test_text" type="text" />
            <span class="input-group-addon">.00</span>
        </div>
    </div>

Strappings can also be used in this context. Here C<large> applies C<.input-lg>.

If the input name (the first item in the text_field array ref) contains dashes, those are replaced (in the C<name>) to underscores.


B<Input group (before and after), and with value>

    %= formgroup 'Text test 5', text_field => ['test_text', '200', prepend => '$', append => '.00']

    <div class="form-group">
        <label class="control-label" for="test_text">Text test 5</label>
        <div class="input-group">
            <span class="input-group-addon">$</span>
            <input class="form-control" id="test_text" name="test_text" type="text" value="200" />
            <span class="input-group-addon">.00</span>
        </div>
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

    %= button $button_text(, $url[])(, %arguments)

    # %arguments
    (%html_attributes,)
    (%strappings)

B<C<$button_text>>

Mandatory. The text on the button.

B<C<$url[]>>

Optional array reference. It is handed off to L<url_for|Mojolicious::Controller#url_for>, so with it this is
basically L<link_to|Mojolicious::Plugin::TagHelpers#link_to> with Bootstrap classes.

B<C<%arguments>>

Optional hash:

=over 4

B<C<%html_attributes>>

Optional hash of any html attributes you want to set on the button/link.

B<C<%strappings>>

Optional hash. Any strappings you want to set on the button/link.

=back


=head3 Examples

    %= button 'The example 5' => large, warning

    <button class="btn btn-lg btn-warning">The example 5</button>

An ordinary button, with applied strappings.
    
    %= button 'The example 1' => ['http://www.example.com/'], small

    <a class="btn btn-sm" href="http://www.example.com/">The example 1</a>

With a url the button turns into a link.



=head2 Tables

=head3 Syntax

    %= table ($title,) (%arguments,) begin
           $body
    %  end

    # %arguments
    (%html_attributes,)
    (%strappings,)
    (panel => $strappings{})

B<C<$title>>

Optional. If set the table will be wrapped in a panel. The table replaces the body.

B<C<%arguments>>

Optional hash:

=over 4

B<C<%html_attributes>>

Optional. A hash of html attributes you want applied to the table.

B<C<%strappings>>

Optional. A hash of the strappings to apply to the table.


B<C<panel =E<gt> $strappings{}>>

An optional key-value pair:

=over 4

B<C<$strappings{}>>

A hash reference containing any strapping you want to set on the panel.

=back

=back


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
        <table class="table table-condensed">
            <tr><td>Table 4</td></tr>
        </table>
    </div>

A C<condensed> table with an C<id> wrapped in a C<success> panel.


=head1 OPTIONS

Some options are available:

    $app->plugin('BootstrapHelpers', {
        tag_prefix => 'bs',
        short_strappings_prefix => 'set',
        init_short_strappings => 1,
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
