==test==
--t--
	%= badge 'Badge 1'
--t--
--e--
	<span class="badge">Badge 1</span></a>
--e--

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


==test==
--t--
	<%= badge 'Badge 4', data => { custom => 'yes' }, right %>
--t--
--e--
	<span class="badge pull-right" data-custom="yes">Badge 4</span>
--e--
