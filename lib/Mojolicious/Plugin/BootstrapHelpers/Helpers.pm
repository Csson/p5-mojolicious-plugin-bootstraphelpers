package Mojolicious::Plugin::BootstrapHelpers::Helpers {

    use strict;
    use warnings;
    use Mojo::Base 'Mojolicious::Plugin';

    use List::AllUtils qw/uniq first_index/;
    use Mojo::ByteStream;
    use Mojo::Util 'xml_escape';
    use Scalar::Util 'blessed';
    use String::Trim;
    use Data::Dumper 'Dumper';
    use experimental 'postderef'; # requires 5.20

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
        my $attr = shift;
        return '' if !defined $attr;
        $attr = cleanup_attrs({$attr->%*}); #* Make a copy

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
        my $attr = parse_attributes(@_);

        my $caret = exists $attr->{'__caret'} && $attr->{'__caret'} ? q{ <span class="caret"></span>} : '';

        $attr = add_classes($attr, 'btn', { size => 'btn-%s', button => 'btn-%s', button_default => 'default' });
        $attr = add_classes($attr, 'active') if $attr->{'__active'};
        $attr = add_classes($attr, 'block') if $attr->{'__block'};
        $attr = add_disabled($attr, scalar @url);
        $attr = cleanup_attrs($attr);

        # We have an url
        if(scalar @url) {
            $attr->{'href'} = $c->url_for(@url)->to_string;

            my $html = htmlify_attrs($attr);
            return out(qq{<a$html>} . content_single($content) . qq{$caret</a>});
        }
        else {
            my $html = htmlify_attrs($attr);
            return out(qq{<button$html>} . content_single($content) . qq{$caret</button>});
        }

    }

    sub bootstrap_submit {
        push @_ => (type => 'submit');
        return bootstrap_button(@_);
    }

    sub bootstrap_dropdown {
        my $meat = make_dropdown_meat(@_);

        my $dropdown = qq{
            <div class="dropdown">
                $meat
            </div>
        };
        return out($dropdown);
    }

    sub make_dropdown_meat {
        my $c = shift;

        my $attr = parse_attributes(@_);
        my $button_info = delete $attr->{'button'};

        my $button_text = shift $button_info->@*;
        my $button_attr =  { $button_info->@* };

        my $items_info = delete $attr->{'items'};

        my $ulattr = { __right => exists $attr->{'__right'} ? delete $attr->{'__right'} : 0 };
        $ulattr = add_classes($ulattr, 'dropdown-menu');
        $ulattr = add_classes($ulattr, 'dropdown-menu-right') if $ulattr->{'__right'};
        my $ulhtml = htmlify_attrs($ulattr);

        $button_attr = add_classes($button_attr, 'dropdown-toggle');
        $button_attr->{'data-toggle'} = 'dropdown';
        $button_attr->{'type'} = 'button';
        my $button = bootstrap_button($c, $button_text, $button_attr->%*);

        my $menuitems = '';

        ITEM:
        foreach my $item ($items_info->@*) {
            if(ref $item eq '') {
                $menuitems .= qq{<li class="dropdown-header">$item</li>};
            }
            next ITEM if ref $item ne 'ARRAY';
            if(!scalar $item->@*) {
                $menuitems .= q{<li class="divider"></li>} ;
            }
            else {
                $menuitems .= create_dropdown_menuitem($c, $item->@*);
            }

        }

        my $out = qq{
            $button
            <ul$ulhtml>
                $menuitems
            </ul>
        };

        return out($out);

    }

    sub create_dropdown_menuitem {
        my $c = shift;
        my $item_text = iscoderef($_[-1]) ? pop : shift;
        my @url = shift->@*;

        my $attr = parse_attributes(@_);
        $attr = add_classes($attr, 'menuitem');
        my $liattr = { __disabled => exists $attr->{'__disabled'} ? delete $attr->{'__disabled'} : 0 };
        $liattr = add_disabled($liattr, 1);
        $attr->{'tabindex'} ||= -1;
        $attr->{'href'} = $c->url_for(@url)->to_string;

        my $html = htmlify_attrs($attr);
        my $lihtml = htmlify_attrs($liattr);

        my $tag = qq{<li$lihtml><a$html>$item_text</a></li>};

        return out($tag);
    }

    sub bootstrap_buttongroup {
        my $c = shift;
        my $attr = parse_attributes(@_);
        my $buttons_info = delete $attr->{'buttons'};
        my $button_group_class = delete $attr->{'__vertical'} ? 'btn-group-vertical' : 'btn-group';
        $attr = add_classes($attr, $button_group_class, { size => 'btn-group-%s' });
        my $html = htmlify_attrs($attr);

        #* For the possible inner btn-group, use the same classes.
        my $inner_classes = { class => $attr->{'class'} };
        my $inner_html = htmlify_attrs($inner_classes);

        my $buttons = '';
        foreach my $button ($buttons_info->@*) {
            if(ref $button eq 'ARRAY') {
                $buttons .= bootstrap_button($c, $button->@*, type => 'button');
            }
            elsif(ref $button eq 'HASH') {
                my $meat = make_dropdown_meat($c, $button->%*);
                $buttons .= qq{
                    <div$inner_html>
                        $meat
                    </div>
                };

            }
        }

        my $tag = '';

        $tag = qq{
            <div$html>
                $buttons
            </div>
        };

        return out($tag);
    }

    sub bootstrap_badge {
        my $c = shift;
        my $content = iscoderef($_[-1]) ? pop : shift;
        my $attr = parse_attributes(@_);

        $attr = add_classes($attr, 'badge', { direction => 'pull-%s' });
        my $html = htmlify_attrs($attr);

        my $badge = defined $content && length $content ? qq{<span$html>$content</span>} : '';

        return out($badge);
    }

    sub bootstrap_icon {
        my $c = shift;
        my $icon = shift;

        my $icon_class = $c->config->{'Plugin::BootstrapHelpers'}{'icons'}{'class'};
        my $formatter = $c->config->{'Plugin::BootstrapHelpers'}{'icons'}{'formatter'};

        my $this_icon = sprintf $formatter => $icon;
        my $attr = parse_attributes(@_);
        $attr = add_classes($attr, $icon_class, $this_icon);
        my $html = htmlify_attrs($attr);

        return '' if !defined $icon || !length $icon;
        return out(qq{<span$html></span>});
    }

    sub iscoderef {
        return shift eq 'CODE';
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

        if($formatter) {
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
            if(exists $formatter->{'direction'}) {
                push @classes => sprintfify_class($attr, $formatter->{'direction'}, $formatter->{'direction_default'}, _direction_contexts());
            }
        }

        $attr->{'class'} = trim join ' ' => uniq sort @classes;

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

    sub add_disabled {
        my $attr = shift;
        my $add_as_class = shift; # if false, add as attribute

        if(exists $attr->{'__disabled'} && $attr->{'__disabled'}) {
            if($add_as_class) {
                $attr = add_classes($attr, 'disabled');
            }
            else {
                $attr->{'disabled'} = 'disabled';
            }
        }
        return $attr;
    }

    sub contents {
        my $callback = shift;
        my $content = shift;

        return defined $callback ? $callback->() : xml_escape($content);
    }

    sub content_single {
        my $content = shift;

        return ref $content eq 'CODE' ? $content->() : xml_escape($content);
    }

    sub cleanup_attrs {
        my $hash = shift;

        #* delete all strappings (__*)
        map { delete $hash->{ $_ } } grep { substr($_, 0, 2) eq '__' } keys $hash->%*;

        #* delete all keys whose value is not a string
        map { delete $hash->{ $_ } } grep { $_ ne 'data' && ref $hash->{ $_ } ne '' } keys $hash->%*;

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
    sub _direction_contexts {
        return { map { ("__$_" => $_, $_ => $_) } qw/right block vertical/ };
    }
    sub _menu_contexts {
        return { map { ("__$_" => undef, $_ => undef) } qw/caret/ };
    }
    sub _misc_contexts {
        return { map { ("__$_" => $_, $_ => $_) } qw/active disabled/ };
    }

    sub out {
        my $tag = shift;
        return Mojo::ByteStream->new($tag);
    }

}

1;
