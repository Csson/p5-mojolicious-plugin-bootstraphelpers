use Mojo::Base -strict;
BEGIN {
    $ENV{'MOJO_NO_IPV6'} = 1;
    $ENV{'MOJO_REACTOR'} = 'Mojo::Reactor::Poll';
}

use Test::More;
use Mojolicious::Lite;
use Test::Mojo;

plugin 'BootstrapHelpers';

my $test = Test::Mojo->new;

get '/panel';


my $panel = qq{
            <div class="panel panel-default">-
                <div class="panel-body">-
                </div>-
            </div>

            <div class="panel panel-default">-
                <div class="panel-body">-
                </div>-
            </div>
            <div class="panel panel-default">-
                <div class="panel-heading">-
                    <h3 class="panel-title">Test</h3>-
                </div>-
                <div class="panel-body">-
                </div>-
            </div>

            <div class="panel panel-default">-
                <div class="panel-heading">-
                    <h3 class="panel-title">Test</h3>-
                </div>-
                <div class="panel-body">-
                </div>-
            </div>
        };
$test->get_ok('/panel')->status_is(200)->content_is(trimmed($panel));

done_testing();


sub trimmed {
    my $tag = shift;
    $tag =~ s{>-\n\s+<}{><}gm;
    $tag =~ s{[ \s]+$}{}g;
    return $tag;
}

__DATA__
@@ panel.html.ep
%= bs_panel 'Test', '-no-title' => 1
%= bs_panel 'Test', '-no-title' => 1 => begin
%  end
%= bs_panel 'Test'
%= bs_panel 'Test' => begin
%  end