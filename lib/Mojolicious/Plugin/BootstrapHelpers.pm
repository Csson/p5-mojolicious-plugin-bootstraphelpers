package Mojolicious::Plugin::BootstrapHelpers {
    use Mojo::Base 'Mojolicious::Plugin';
    use Syntax::Collection::Basic;

    use Mojo::ByteStream;
    use Mojo::Util 'xml_escape';
    use Scalar::Util 'blessed';
    use String::Trim;

    use experimental 'postderef';

    our $VERSION = 0.001320;

    sub register {
        my $self = shift;
        my $app = shift;

        $app->helper(bs_panel => \&bootstrap_panel);
        $app->helper(bs_formgroup => \&bootstrap_formgroup);
        $app->helper(bs_button => \&bootstrap_button);


    }

    sub bootstrap_panel {
        my($c, $title, $callback, $content, $attr) = parse_call(@_);
        
        $attr->{'panel_type'} //= 'default';
        $attr->{'no_title'} //= 0;
        
        my $tag = qq{
            <div class="panel panel-$attr->{'panel_type'}">
            } . (!$attr->{'no_title'} ? qq{
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

        #my $callback = ref $_[-1] eq 'CODE' ? pop : undef;
        #my $content = scalar @_ % 2 ? pop : '';
        
        my($id, $input) = fix_input($c, $attr);
        my $label = fix_label($c, $id, $title, $attr);

        my $form_group_class = join ' ' => ('form-group', get_size($attr, 'form-group-%s'));

        my $tag = qq{
            <div class="$form_group_class">
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
        my %attr = @_;
        
        my @tag_attrs = ();
        push @tag_attrs => (class => join ' ' => ('btn', get_size(\%attr, 'btn-%s')));

        # We have an url
        if(scalar @url) {
            push @tag_attrs => (href => $c->url_for(@url));
            return out(Mojolicious::Plugin::TagHelpers::_tag('a', @tag_attrs, $content));
        }
        else {
            return out(Mojolicious::Plugin::TagHelpers::_tag('button', @tag_attrs, $content));
        }

    }

    sub fix_input {
        my $c = shift;
        my $attr = shift;
        
        my $tagname = (grep { exists $attr->{"${_}_field"} } qw/date datetime month time week color email number range search tel text url/)[0];
        my $id = shift $attr->{"${tagname}_field"}->@*;
        
        # if odd number of elements, the first one is the value (shortcut to avoid having to: value => 'value')
        if($attr->{"${tagname}_field"}->@* % 2) {
            push $attr->{"${tagname}_field"}->@* => (value => shift $attr->{"${tagname}_field"}->@*);
        }
        my %tag_attr = $attr->{"${tagname}_field"}->@*;

        {
            no warnings 'uninitialized';
            $tag_attr{'class'} = trim join ' ' => ($tag_attr{'class'}, 'form-control', get_size(\%tag_attr, 'input-%s'));
            $tag_attr{'id'}  = $id;
        }

        my $prepend = delete $tag_attr{'prepend'};
        my $append = delete $tag_attr{'append'};

        # input group not requested
        if(!defined $prepend && !defined $append) {
            return ($id => Mojolicious::Plugin::TagHelpers::_input($c, $id, %tag_attr, type => $tagname));
        }

        
        my $input = Mojolicious::Plugin::TagHelpers::_input($c, $id, %tag_attr, type => $tagname);

        return $id => qq{
            <div class="input-group">
                } . ($prepend ? qq{<span class="input-group-addon">$prepend</span>} : '') . qq{
                $input
                } . ($append ? qq{<span class="input-group-addon">$append</span>} : '') . qq{
            </div>
        };

    }

    sub fix_label {
        my $c = shift;
        my $for = shift;
        my $title = shift;
        my $attr = shift;

        my @args = (class => 'control-label');
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

    sub get_size {
        my $attr = shift;
        my $format = shift;

        my %possible_sizes = qw/xsmall xs  small s  medium md  large lg/;
        my $attr_size = (grep { exists $attr->{ $_ } } (%possible_sizes))[0];

        return if !defined $attr_size;

        my $size = exists $possible_sizes{ $attr_size } ? $possible_sizes{ $attr_size } : $attr_size;
        delete $attr->{ $attr_size };

        return sprintf $format => $size;
    }

    sub contents {
        my $callback = shift;
        my $content = shift;

        return defined $callback ? $callback->() : xml_escape($content);
    }

    sub out {
        my $tag = shift;
        $tag =~ s{>[ \n\t\s]+<}{><}mg;
        $tag =~ s{[ \s]+$}{}g;
        return Mojo::ByteStream->new($tag);
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

=head1 DESCRIPTION

Mojolicious::Plugin::BootstrapHelpers is a convenience plugin that reduces some bootstrap complexity by introducing several tag helpers specifically for L<Bootstrap 3|http://www.getbootstrap.com/>.

The goal is not to have tag helpers for everything, but for common use cases.

All examples below currently works.

=head2 Panel
    
    %= bs_panel Test => no_title => 1

Generates

    <div class="panel panel-default">
        <div class="panel-body">
        </div>
    </div>

=head1 AUTHOR

Erik Carlsson E<lt>info@code301.comE<gt>

=head1 COPYRIGHT

Copyright 2014- Erik Carlsson

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
