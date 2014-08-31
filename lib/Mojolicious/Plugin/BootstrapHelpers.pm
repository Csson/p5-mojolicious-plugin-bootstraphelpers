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

    our $VERSION = 0.003;

    sub bootstrap_panel {
        my($c, $title, $callback, $content, $attr) = parse_call(@_);
        
        #$attr = replace_context('panel_context');
        $attr = add_classes($attr, 'panel', { panel_context => 'panel-%s', default => 'default'});
        
        my $tag = qq{
            <div class="$attr->{'class'}">
            } . (defined $title ? qq{
                <div class="panel-heading">
                    <h3 class="panel-title">$title</h3>
                </div>
            } : '') . qq{
                <div class="panel-body">
                    } . contents($callback, $content) . qq{
                </div>
            </div>
        };

        return out($tag);

    }

    sub bootstrap_formgroup {
        my $c = shift;
        my $title = ref $_[-1] eq 'CODE' ? pop : shift;
        my $attr = parse_attributes(@_);
        
        $attr->{'column_information'} = delete $attr->{'cols'} if ref $attr->{'cols'} eq 'HASH';

        my($id, $input) = fix_input($c, $attr);
        my $label = fix_label($c, $id, $title, $attr);

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
        
        $attr = add_classes($attr, 'btn', { size => 'btn-%s', button_context => 'btn-%s' });
        $attr = cleanup_attrs($attr);

        # We have an url
        if(scalar @url) {
            $attr->{'href'} = $c->url_for(@url);
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
        $tag_attr->{'id'} = $id;

        my $prepend = delete $tag_attr->{'prepend'};
        my $append = delete $tag_attr->{'append'};
        $tag_attr = cleanup_attrs($tag_attr);

        my $horizontal_before = scalar @column_classes ? qq{<div class="} . (trim join ' ' => @column_classes) . '">' : '';
        my $horizontal_after = scalar @column_classes ? '</div>' : '';
        my $input = Mojolicious::Plugin::TagHelpers::_input($c, $id, $tag_attr->%*, type => $tagname);

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
            push @classes => sprintfify_class($attr, $formatter->{'size'}, $formatter->{'default'}, _sizes());
        }
        if(exists $formatter->{'button_context'}) {
            push @classes => sprintfify_class($attr, $formatter->{'button_context'}, $formatter->{'default'}, _button_contexts());
        }
        if(exists $formatter->{'panel_context'}) {
            push @classes => sprintfify_class($attr, $formatter->{'panel_context'}, $formatter->{'default'}, _panel_contexts());
        }

        $attr->{'class'} = trim join ' ' => sort @classes;

        return $attr;
        
    }

    sub sprintfify_class {
        my $attr = shift;
        my $format = shift;
        my $possibilities = pop;
        my $default = shift;

        my $found = (grep { exists $attr->{ $_ } } (keys $possibilities->%*))[0];

        return if !defined $found && !defined $default;
        $found = $default if !defined $found;

        return sprintf $format => $possibilities->{ $found };

    }

    sub contents {
        my $callback = shift;
        my $content = shift;

        return defined $callback ? $callback->() : xml_escape($content);
    }

    sub cleanup_attrs {
        my $hash = shift;
        
        map { delete $hash->{ $_ } } ('column_information', keys _sizes()->%*, keys _button_contexts()->%*, keys _panel_contexts()->%*);
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

    sub out {
        my $tag = shift;
        $tag =~ s{>[ \n\t\s]+<}{><}mg;
        $tag =~ s{[ \s]+$}{}g;
        return Mojo::ByteStream->new($tag);
    }

    sub register {
        my $self = shift;
        my $app = shift;
        my $args = shift;

        my $px = setup_prefix($args->{'global_prefix'});
        my $spx = setup_prefix($args->{'shortcut_prefix'});
        my $suppress_shortcuts = $args->{'suppress_shortcuts'} //= 0;

        $app->helper($px.'panel' => \&bootstrap_panel);
        $app->helper($px.'formgroup' => \&bootstrap_formgroup);
        $app->helper($px.'button' => \&bootstrap_button);
        $app->helper($px.'submit_button' => \&bootstrap_submit);

        if(!$suppress_shortcuts) {
            my @sizes = qw/xsmall small medium large/;
            my @contexts = qw/default primary success info warning danger/;

            foreach my $helper (@sizes, @contexts) {
               $app->helper($spx.$helper, sub { ("__$helper" => 1) });
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

=head1 STATUS

This is an unstable work in progress. Backwards compatibility is currently not to be expected between releases.

Currently supported Bootstrap version: 3.2.0.

Only Perl 5.20+ is supported (thanks to postderef). This might change.

=head1 DESCRIPTION

Mojolicious::Plugin::BootstrapHelpers is a convenience plugin that reduces some bootstrap complexity by introducing several tag helpers specifically for L<Bootstrap 3|http://www.getbootstrap.com/>.

The goal is not to have tag helpers for everything, but for common use cases.

All examples below (and more, see tests) currently works.

=head2 Shortcuts

There are several shortcuts for context and size classes, that automatically expands to the correct class depending on which tag it is applied to.

For instance, if you apply the C<info> shortcut to a panel, it becomes C<panel-info>, but when applied to a button it becomes C<btn-info>.

For sizes, you can only use C<xsmall>, C<small>, C<medium> and C<large>, they are shortened to the Bootstrap type classes.

The following shortcuts are available:

   xsmall    default
   small     primary
   medium    success
   large     info
             warning
             danger

See below for usage. B<Important:> You can't follow a shortcut with a fat comma (C<=E<gt>>). The fat comma auto-quotes the shortcut, and then the shortcut is not a shortcut anymore.

If there is no corresponding class for the element you add the shortcut to it is automatically removed.

=head2 Panels

L<Bootstrap documentation|http://getbootstrap.com/components/#panels>

=head3 No body, no title

    %= panel

    <div class="panel panel-default">
        <div class="panel-body">
        </div>
    </div>

=head3 Body, no title

    %= panel undef ,=> begin
        <p>A short text.</p>
    %  end

    <div class="panel panel-default">
        <div class="panel-body">
            <p>A short text.</p>
        </div>
    </div>

=head3 Body and title

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

=head3 Body and title, with context
    
    %= panel 'Panel 5', success => 1 => begin
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

=head2 Form groups

L<Bootstrap documentation|http://getbootstrap.com/css/#forms>

=head3 Basic form group
    
    %= formgroup 'Text test 1', text_field => ['test_text']

    <div class="form-group">
        <label class="control-label" for="test_text">Text test 1</label>
        <input class="form-control" id="test_text" name="test_text" type="text" />
    </div>

The first item in the array ref is used for both C<id> and C<name>.

=head3 Input group (before), and large input field

    %= formgroup 'Text test 4', text_field => ['test_text', append => '.00', large => 1]

    <div class="form-group">
        <label class="control-label" for="test_text">Text test 4</label>
        <div class="input-group">
            <input class="form-control input-lg" id="test_text" name="test_text" type="text" />
            <span class="input-group-addon">.00</span>
        </div>
    </div>

=head3 Input group (before and after), and with value

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

=head3 Large input group

    %= formgroup 'Text test 6', text_field => ['test_text'], large => 1

    <div class="form-group form-group-lg">
        <label class="control-label" for="test_text">Text test 6</label>
        <input class="form-control" id="test_text" name="test_text" type="text" />
    </div>

Note the difference with the earlier example. Here C<large =E<gt> 1> is outside the C<text_field> array ref, and therefore is applied to the form group. 

=head3 Horizontal form groups
    
    %= formgroup 'Text test 8', text_field => ['test_text'], cols => { medium => [2, 10], small => [4, 8] }

    <div class="form-group">
        <label class="control-label col-md-2 col-sm-4" for="test_text">Text test 8</label>
        <div class="col-md-10 col-sm-8">
            <input class="form-control" id="test_text" name="test_text" type="text" />
        </div>
    </div>

If the C<form> has the C<form-horizontal> class, you can set the column widths with the C<cols> attribute. The first item in each array ref is for the label, and the second for the input.

=head1 AUTHOR

Erik Carlsson E<lt>csson@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2014- Erik Carlsson

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
