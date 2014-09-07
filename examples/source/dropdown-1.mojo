==test==
--t--
    <%= dropdown 'Dropdown 1',
         button => [id => 'a_custom_id'],
         items => [
            ['Item 1', ['item1'] ],
            ['Item 2', ['item2'] ],
            divider,
            ['Item 3', ['item3'] ]
         ] %>
--t--
--e--
    <div class="dropdown">
        <button class="btn btn-default dropdown-toggle" type="button" id="a_custom_id" data-toggle="dropdown">Dropdown 1</button>
        <ul class="dropdown-menu">
            <li><a class="menuitem" href="item1" tabindex="-1">Item 1</a></li>
            <li><a class="menuitem" href="item2" tabindex="-1">Item 2</a></li>
            <li class="divider"></li>
            <li><a class="menuitem" href="item3" tabindex="-1">Item 3</a></li>
        </ul>
    </div>
--e--


==test==
--t--
    <%= dropdown 'Dropdown 2', caret,
         items => [
            ['Item 1', ['item1'], data => { attr => 2 } ],
            ['Item 2', ['item2'], data => { attr => 4 } ],
            divider,
            ['Item 3', ['item3'], data => { attr => 7 } ],
            divider,
            ['Item 4', ['item4'], tabindex => 4 ],
         ] %>

--t--
--e--
    <div class="dropdown">
        <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">Dropdown 2<span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
            <li><a class="menuitem" href="item1" tabindex="-1" data-attr="2">Item 1</a></li>
            <li><a class="menuitem" href="item2" tabindex="-1" data-attr="4">Item 2</a></li>
            <li class="divider"></li>
            <li><a class="menuitem" href="item3" tabindex="-1" data-attr="7">Item 3</a></li>
            <li class="divider"></li>
            <li><a class="menuitem" href="item4" tabindex="4">Item 4</a></li>
        </ul>
    </div>

--e--
