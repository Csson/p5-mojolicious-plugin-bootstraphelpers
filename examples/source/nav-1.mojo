==test==
--t--
	<%= nav pills => [
				['Item 1', ['#'] ],
				['Item 2', ['#'], active ],
			]
	%>
--t--
--e--
	<ul class="nav nav-pills">
		<li><a href="#">Item 1</a></li>
		<li class="active"><a href="#">Item 2</a></li>
	</ul>
--e--