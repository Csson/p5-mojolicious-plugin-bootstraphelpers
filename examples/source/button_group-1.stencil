==test example==
--t--
    <%= buttongroup
        buttons => [
            ['Button 1'],
            ['Button 2'],
            ['Button 3'],
        ]
    %>
--t--
--e--
    <div class="btn-group">
        <button class="btn btn-default" type="button">Button 1</button>
        <button class="btn btn-default" type="button">Button 2</button>
        <button class="btn btn-default" type="button">Button 3</button>
    </div>
--e--
A basic button group.

==test example==
--t--
    <%= buttongroup small,
        buttons => [
            ['Button 1'],
            ['Dropdown 1', caret, items => [
                ['Item 1', ['item1'] ],
                ['Item 2', ['item2'] ],
                [],
                ['Item 3', ['item3'] ],
            ] ],
            ['Button 2'],
            ['Button 3'],
        ],
    %>
--t--
--e--
    <div class="btn-group btn-group-sm">
        <button class="btn btn-default" type="button">Button 1</button>
        <div class="btn-group btn-group-sm">
            <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">Dropdown 1 <span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                <li><a class="menuitem" href="item1" tabindex="-1">Item 1</a></li>
                <li><a class="menuitem" href="item2" tabindex="-1">Item 2</a></li>
                <li class="divider"></li>
                <li><a class="menuitem" href="item3" tabindex="-1">Item 3</a></li>
            </ul>
        </div>
        <button class="btn btn-default" type="button">Button 2</button>
        <button class="btn btn-default" type="button">Button 3</button>
    </div>
--e--
Nested button group. Note that the <code>small</code> strapping is only necessary once. The same classes are automatically applied to the nested <code>.btn-group</code>.



==test example==
--t--
    <%= buttongroup vertical,
        buttons => [
            ['Button 1'],
            ['Dropdown 1', caret, items => [
                  ['Item 1', ['item1'] ],
                  ['Item 2', ['item2'] ],
                  [],
                  ['Item 3', ['item3'] ],
            ] ],
            ['Button 2'],
            ['Button 3'],
        ],
    %>
--t--
--e--
    <div class="btn-group-vertical">
        <button class="btn btn-default" type="button">Button 1</button>
        <div class="btn-group">
            <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">Dropdown 1 <span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                <li><a class="menuitem" href="item1" tabindex="-1">Item 1</a></li>
                <li><a class="menuitem" href="item2" tabindex="-1">Item 2</a></li>
                <li class="divider"></li>
                <li><a class="menuitem" href="item3" tabindex="-1">Item 3</a></li>
            </ul>
        </div>
        <button class="btn btn-default" type="button">Button 2</button>
        <button class="btn btn-default" type="button">Button 3</button>
    </div>
--e--
Nested button group, with the <code>vertical</code> strapping.


==test==
--t--
    <%= buttongroup justified,
        buttons => [
            ['Button 1'],
            ['Button 2'],
            ['Button 3'],
        ]
    %>
--t--
--e--
    <div class="btn-group btn-group-justified">
        <div class="btn-group">
            <button class="btn btn-default" type="button">Button 1</button>
        </div>
        <div class="btn-group">
            <button class="btn btn-default" type="button">Button 2</button>
        </div>
        <div class="btn-group">
            <button class="btn btn-default" type="button">Button 3</button>
        </div>
    </div>
--e--
A justified button group. Note the automatic (and necessary) wrapping of buttons in <code>.btn-groups</code>.

==test example==
--t--
    <%= buttongroup justified,
        buttons => [
            ['Link 1', ['http://www.example.com/'] ],
            ['Link 2', ['http://www.example.com/'] ],
            ['Dropup 1', caret, dropup, items => [
                ['Item 1', ['item1'] ],
                ['Item 2', ['item2'] ],
                [],
                ['Item 3', ['item3'] ],
            ] ],
        ]
    %>
--t--
--e--
    <div class="btn-group btn-group-justified">
        <a class="btn btn-default" href="http://www.example.com/">Link 1</a>
        <a class="btn btn-default" href="http://www.example.com/">Link 2</a>
        <div class="btn-group dropup">
            <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">Dropup 1 <span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                <li><a class="menuitem" href="item1" tabindex="-1">Item 1</a></li>
                <li><a class="menuitem" href="item2" tabindex="-1">Item 2</a></li>
                <li class="divider"></li>
                <li><a class="menuitem" href="item3" tabindex="-1">Item 3</a></li>
            </ul>
        </div>
    </div>
--e--
Mix links and <code>dropup</code> menus in <code>justified</code> button groups.


==test example==
--t--
    <%= buttongroup
        buttons => [
            ['Link 1', ['http://www.example.com/'] ],
            [undef, caret, items => [
                ['Item 1', ['item1'] ],
                ['Item 2', ['item2'] ],
                [],
                ['Item 3', ['item3'] ],
            ] ],
        ]
    %>
--t--
--e--
    <div class="btn-group">
        <a class="btn btn-default" href="http://www.example.com/">Link 1</a>
        <div class="btn-group">
            <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown"><span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                <li><a class="menuitem" href="item1" tabindex="-1">Item 1</a></li>
                <li><a class="menuitem" href="item2" tabindex="-1">Item 2</a></li>
                <li class="divider"></li>
                <li><a class="menuitem" href="item3" tabindex="-1">Item 3</a></li>
            </ul>
        </div>
    </div>
--e--
Split button dropdowns uses the same syntax as any other multi-button dropdown. Set the <code>caret</code> button title to <code>undef</code>.


==test example==
--t--
    <%= buttongroup ['Default', caret, items  => [
                        ['Item 1', ['item1'] ],
                        ['Item 2', ['item2'] ],
                        [],
                        ['Item 3', ['item3'] ],
                    ] ]
    %>

    <%= buttongroup ['Big danger', caret, large, danger, items => [
                          ['Item 1', ['item1'] ],
                          ['Item 2', ['item2'] ],
                          [],
                          ['Item 3', ['item3'] ],
                    ] ]
    %>
--t--
--e--
    <div class="btn-group">
        <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">Default <span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
            <li><a class="menuitem" href="item1" tabindex="-1">Item 1</a></li>
            <li><a class="menuitem" href="item2" tabindex="-1">Item 2</a></li>
            <li class="divider"></li>
            <li><a class="menuitem" href="item3" tabindex="-1">Item 3</a></li>
        </ul>
    </div>

    <div class="btn-group">
        <button class="btn btn-danger btn-lg dropdown-toggle" type="button" data-toggle="dropdown">Big danger <span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
            <li><a class="menuitem" href="item1" tabindex="-1">Item 1</a></li>
            <li><a class="menuitem" href="item2" tabindex="-1">Item 2</a></li>
            <li class="divider"></li>
            <li><a class="menuitem" href="item3" tabindex="-1">Item 3</a></li>
        </ul>
    </div>
--e--
Using the shortcut to create single-button button group dropdowns.
