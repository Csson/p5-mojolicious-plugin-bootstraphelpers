
# Code here

==test==
--t--
%= link_to 'MetaCPAN', 'http://www.metacpan.org/'
--t--
--e--
<a href="http://www.metacpan.org/">MetaCPAN</a>
--e--

==test==
--t--
%= text_field username => placeholder => 'Enter name'
--t--
--e--
<input name="username" placeholder="Enter name" type="text" />
--e--
