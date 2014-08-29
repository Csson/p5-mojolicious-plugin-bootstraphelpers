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


    }

    sub bootstrap_panel {
        my($c, $title, $callback, $content, $attr) = parse_call(@_);
        
        $attr->{'-panel-type'} //= 'default';
        $attr->{'-no-title'} //= 0;
        
        my $tag = qq{
            <div class="panel panel-$attr->{'-panel-type'}">
            } . (!$attr->{'-no-title'} ? qq{
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
# %= bs_formgroup 'Email', -text_field => ['field-name', 'default value', placeholder => 'what'], -addons => ['', '@']
    sub bootstrap_formgroup {
        my $c = shift;
        my $title = shift;
        #my $callback = ref $_[-1] eq 'CODE' ? pop : undef;
        #my $content = scalar @_ % 2 ? pop : '';
        my $attr = parse_attributes(@_);

        my $text_field = fix_text_field($attr->{'-text_field'});
        my $addons = fix_addons($attr->{'-addons'});

        my $tag = qq{
            <div class="form-group">
                <label>$title</label>
                <input type="text" class="form-control" />
            </div>
        };

        return out($tag);
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

    sub fix_addons {
        my $addons = shift;
        return (undef, undef) if !defined $addons;

        if(ref $addons ne 'ARRAY') {
            warn '-addons must be (two item) array ref';
            return (undef, undef);
        }
        elsif(scalar $addons->@* != 2) {
            warn '-addons must be two item array ref';
            return (undef, undef);
        }
        return $addons;

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
