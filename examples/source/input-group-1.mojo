==test==
--t--
	%= input input => { text_field => ['username'] },
			 prepend => { checkbox => ['agreed'] },
--t--
--e--
	<div class="input-group">
		<span class="input-group-addon"><input name="agreed" type="checkbox" /></span>
		<input class="form-control" type="text" name="username" />
	</div>
--e--