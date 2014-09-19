==test==
--t--
    <%= nav pills => [
                ['Item 1', ['#'] ],
                ['Item 2', ['#'], active ],
                ['Item 3', ['#'] ],
                ['Item 4', ['#'], disabled ],
            ]
    %>
--t--
--e--
    <ul class="nav nav-pills">
        <li><a href="#">Item 1</a></li>
        <li class="active"><a href="#">Item 2</a></li>
        <li><a href="#">Item 3</a></li>
        <li class="disabled"><a href="#">Item 4</a></li>
    </ul>
--e--

==test==
--t--
    <%= nav justified, tabs => [
                ['Item 1', ['#'] ],
                ['Item 2', ['#'], active ],
                ['Item 3', ['#'] ],
                {
                    button => ['Dropdown', ['#'], caret],
                    items => [
                        ['There are...', ['#'] ],
                        ['...three...', ['#'] ],
                        [],
                        ['...choices', ['#'] ],
                    ],
                },
            ]
    %>
--t--
--e--
    <ul class="nav nav-justified nav-tabs">
        <li><a href="#">Item 1</a></li>
        <li class="active"><a href="#">Item 2</a></li>
        <li><a href="#">Item 3</a></li>
        <li class="dropdown">
            <a class="dropdown-toggle" data-toggle="dropdown" href="#">Dropdown <span class="caret"></span></a>
            <ul class="dropdown-menu">
                <li><a href="#">There are...</a></li>
                <li><a href="#">...three...</a></li>
                <li class="divider"></li>
                <li><a href="#">...choices</a></li>
            </ul>
        </li>
    </ul>
--e--
