package Mojolicious::Plugin::BootstrapHelpers {
    use Mojo::Base 'Mojolicious::Plugin';
    use Syntax::Collection::Basic;

    use Mojo::ByteStream;
    use Mojo::Util 'xml_escape';
    use Scalar::Util 'blessed';
    use String::Trim;

    use experimental 'postderef';

    our $VERSION = 0.01;

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
        my $title = shift;
        
        #my $callback = ref $_[-1] eq 'CODE' ? pop : undef;
        #my $content = scalar @_ % 2 ? pop : '';
        
        my($id, $input) = fix_input($c, @_);

        my $tag = q{
            <div class="form-group">
                } . Mojolicious::Plugin::TagHelpers::_label_for($c, $id, $title) . qq{
                $input
            </div>
        };

        return out($tag);
    }
    # %= bs_button 'The text' => ['url', {}], attr => value
    sub bootstrap_button {
        my $c = shift;
        my $content = shift;
        #my @url = ($content);
        my @url = shift->@* if ref $_[0] eq 'ARRAY';
        
        if(ref $_[-1] ne 'CODE') {
            push @_ => $content;
        }

        # We have an url
        if(scalar @url) {
            return out(Mojolicious::Plugin::TagHelpers::_tag('a', href => $c->url_for(@url), @_));
        }
        else {
            return out(qq{<button>$content</button>});
        }

    }

    sub fix_input {
        my $c = shift;
        my $attr = parse_attributes(@_);

        my $tagname = (grep { exists $attr->{"${_}_field"} } qw/date datetime month time week color email number range search tel text url/)[0];
        my $id = shift $attr->{"${tagname}_field"}->@*;
        
        # if odd number of elements, the first one is the value (shortcut to avoid having to: value => 'value')
        if($attr->{"${tagname}_field"}->@* % 2) {
            push $attr->{"${tagname}_field"}->@* => (value => shift $attr->{"${tagname}_field"}->@*);
        }
        my %tag_attr = $attr->{"${tagname}_field"}->@*;

        $tag_attr{'class'} = exists $tag_attr{'class'} ? $tag_attr{'class'} . ' form-control' : 'form-control';
        $tag_attr{'id'}  = $id;

        # input group not requested
        if(!exists $tag_attr{'_prepend'} && !exists $tag_attr{'_append'}) {
            return ($id => Mojolicious::Plugin::TagHelpers::_input($c, $id, %tag_attr, type => $tagname));
        }

        my $prepend = delete $tag_attr{'_prepend'};
        my $append = delete $tag_attr{'_append'};
        my $input = Mojolicious::Plugin::TagHelpers::_input($c, $id, %tag_attr, type => $tagname);

        return $id => qq{
            <div class="input-group">
                } . ($prepend ? qq{<span class="input-group-addon">$prepend</span>} : '') . qq{
                $input
                } . ($append ? qq{<span class="input-group-addon">$append</span>} : '') . qq{
            </div>
        };

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

Mojolicious::Plugin::BootstrapHelpers - Blah blah blah

=head1 SYNOPSIS

  use Mojolicious::Plugin::BootstrapHelpers;

=head1 DESCRIPTION

Mojolicious::Plugin::BootstrapHelpers is

=head1 AUTHOR

Erik Carlsson E<lt>info@code301.comE<gt>

=head1 COPYRIGHT

Copyright 2014- Erik Carlsson

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
