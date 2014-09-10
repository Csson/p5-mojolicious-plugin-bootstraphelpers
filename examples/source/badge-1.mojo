==test example 1==
--t--
    <%= badge '3' %>
--t--
--e--
    <span class="badge">3</span></a>
--e--

A basic badge.


==test example 2==
--t--
    <%= badge '4', data => { custom => 'yes' }, right %>
--t--
--e--
    <span class="badge pull-right" data-custom="yes">4</span>
--e--

A right aligned badge with a data attribute.


==test==
--t--
    %= badge 'Badge 2', right
--t--
--e--
    <span class="badge pull-right">Badge 2</span>
--e--


==test==
--t--
    % my $empty_badge = '';
    %= badge $empty_badge
--t--
--e--

--e--
A badge with undef value or empty string is not rendered.
