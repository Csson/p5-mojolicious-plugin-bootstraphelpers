==test==
--t--
    <%= navbar header => ['The brand', ['#'], hamburger, toggler => 'bs-example-navbar-collapse-1'] %>
--t--
--e--
    <nav class="navbar navbar-default">
        <div class="container-fluid">
            <div class="navbar-header">
                <button class="collapsed navbar-toggle" data-target="#bs-example-navbar-collapse-1" data-toggle="collapse" type="button">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">The brand</a>
            </div>
        </div>
    </nav>
--e--


==test example==
--t--
    <%= navbar header => ['The brand', ['#'], hamburger, toggler => 'bs-example-navbar-collapse-2'],
               nav => [ items => [
                       ['Link', ['#'] ],
                       ['Another link', ['#'], active ],
                       ['Menu', ['#'], caret, items => [
                           ['Choice 1', ['#'] ],
                           ['Choice 2', ['#'] ],
                           [],
                           ['Choice 3', ['#'] ],
                       ] ],
                   ]
               ]
    %>
--t--
--e--
    <nav class="navbar navbar-default">
        <div class="container-fluid">
            <div class="navbar-header">
                <button class="collapsed navbar-toggle" data-target="#bs-example-navbar-collapse-2" data-toggle="collapse" type="button">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">The brand</a>
            </div>
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-2">
                <ul class="nav navbar-nav">
                    <li><a href="#">Link</a></li>
                    <li class="active"><a href="#">Another link</a></li>
                    <li class="dropdown">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#">Menu <span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="#">Choice 1</a></li>
                            <li><a href="#">Choice 2</a></li>
                            <li class="divider"></li>
                            <li><a href="#">Choice 3</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
--e--
A simple navbar with a couple of links and a submenu.

==test==
--t--
    <%= navbar inverse, header => ['The Brand', ['#'], hamburger, toggler => 'collapse-45821'],
               form => [
                    [['/login'], method => 'post', left],
                    [
                        formgroup => [
                            text_field => ['search-term', placeholder => 'Search' ],
                        ],
                        submit_button => ['Submit'],
                    ]
                ],
                button => ['A link', ['#'], left ],
                nav => [ items => [
                        ['Another linkage', ['#'] ]
                    ]
                ],
                p => ['Hello', right]
    %>
--t--
--e--
    <nav class="navbar navbar-inverse">
        <div class="container-fluid">
            <div class="navbar-header">
                <button class="collapsed navbar-toggle" data-target="#collapse-45821" data-toggle="collapse" type="button">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">The Brand</a>
            </div>
            <div class="collapse navbar-collapse" id="collapse-45821">
                <form action="/login" class="navbar-form navbar-left" method="post">
                    <div class="form-group">
                        <input class="form-control" id="search-term" name="search_term" placeholder="Search" type="text" />
                    </div>
                    <button class="btn btn-default" type="submit">Submit</button>
                </form>
                <a class="btn btn-default navbar-btn navbar-left" href="#">A link</a>
                <ul class="nav navbar-nav">
                    <li><a href="#">Another linkage</a></li>
                </ul>
                <p class="navbar-right navbar-text">Hello</p>
            </div>
        </div>
    </nav>
--e--


==test example==
--t--
<%= navbar header => ['Brand', ['#'], hamburger, toggler => 'collapse-4124'],
           nav => [ items => [
                   ['Link', ['#'], active ],
                   ['Link', ['#'] ],
                   ['Dropdown', ['#'], caret, items => [
                       ['Action', ['#'] ],
                       ['Another action', ['#'] ],
                       ['Something else here', ['#'] ],
                       [],
                       ['Separated link', ['#'] ],
                       [],
                       ['One more separated link', ['#'] ],
                   ] ] ],
            ],
            form => [
                [['/login'], method => 'post', left],
                [
                    formgroup => [
                        text_field => ['the-search', placeholder => 'Search' ],
                    ],
                    submit_button => ['Submit'],
                ]
            ],
            nav => [
                right,
                items => [
                    ['Link', ['#'] ],
                    ['Dropdown', ['#'], caret, items => [
                            ['Action', ['#'] ],
                            ['Another action', ['#'] ],
                            ['Something else here', ['#'] ],
                            [],
                            ['Separated link', ['#'] ],
                        ],
                    ]
                ],
            ]


%>
--t--
--e--
    <nav class="navbar navbar-default">
        <div class="container-fluid">
            <div class="navbar-header">
                <button type="button" class="collapsed navbar-toggle" data-toggle="collapse" data-target="#collapse-4124">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">Brand</a>
            </div>
            <div class="collapse navbar-collapse" id="collapse-4124">
                <ul class="nav navbar-nav">
                    <li class="active"><a href="#">Link</a></li>
                    <li><a href="#">Link</a></li>
                    <li class="dropdown">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#">Dropdown <span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="#">Action</a></li>
                            <li><a href="#">Another action</a></li>
                            <li><a href="#">Something else here</a></li>
                            <li class="divider"></li>
                            <li><a href="#">Separated link</a></li>
                            <li class="divider"></li>
                            <li><a href="#">One more separated link</a></li>
                        </ul>
                    </li>
                </ul>
                <form action="/login" class="navbar-form navbar-left" method="post">
                    <div class="form-group">
                        <input class="form-control" id="the-search" name="the_search" placeholder="Search" type="text" />
                    </div>
                    <button class="btn btn-default" type="submit">Submit</button>
                </form>
                <ul class="nav navbar-nav navbar-right">
                    <li><a href="#">Link</a></li>
                    <li class="dropdown">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#">Dropdown <span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="#">Action</a></li>
                            <li><a href="#">Another action</a></li>
                            <li><a href="#">Something else here</a></li>
                            <li class="divider"></li>
                            <li><a href="#">Separated link</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
--e--
This is (almost) identical to the <a href="http://getbootstrap.com/components/#navbar">Bootstrap documentation example</a>.