==test==
--t--
    <%= navbar header => ['The brand', ['#'], hamburger, toggler => 'bs-example-navbar-collapse-1'], [] %>
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

==test==
--t--
    <%= navbar html_header => qq{
            <div class="navbar-header">
                <button class="collapsed navbar-toggle" data-target="#bs-example-navbar-collapse-1" data-toggle="collapse" type="button">
                    <span>Expand</span>
                </button>
                <a class="navbar-brand" href="#">The brand</a>
            </div>
    }, [] %>
--t--
--e--
    <nav class="navbar navbar-default">
        <div class="container-fluid">
            <div class="navbar-header">
                <button class="collapsed navbar-toggle" data-target="#bs-example-navbar-collapse-1" data-toggle="collapse" type="button">
                    <span>Expand</span>
                </button>
                <a class="navbar-brand" href="#">The brand</a>
            </div>
        </div>
    </nav>
--e--
By using <code>html_header</code> you can specify an entirely customized header.


==test==
--t--
    <%= navbar header => ['The brand', ['#'], hamburger, toggler => 'bs-example-navbar-collapse-1'],
               [
                    {
                        nav => [
                            [
                                ['Link', ['#'] ],
                                ['Another link', ['#'], active ],
                                {
                                    button => ['Menu', ['#'], caret ],
                                    items => [
                                        ['Choice 1', ['#'] ],
                                        ['Choice 2', ['#'] ],
                                        [],
                                        ['Choice 3', ['#'] ],
                                    ]
                                }
                            ]
                        ]
                    }
               ]
    %>
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
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
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


==no test==
--t--
<%= navbar header => ['The brand', hamburger],
           [
                {
                    nav => [
                        [
                            ['Link', ['#'], active ],
                            ['Link', ['#'] ],
                            {
                                button => ['Dropdown', ['#'], caret],
                                items => [
                                    ['Action', ['#'] ],
                                    ['Another action', ['#'] ],
                                    ['Someting else here', ['#'] ],
                                    [],
                                    ['Separated link', ['#'] ],
                                    [],
                                    ['One more separated link', ['#'] ],
                                ],
                            },
                        },
                    ],
                },
                {
                    form => [
                        ['/login', method => 'post'],
                        left,
                        [
                            formgroup => [
                                undef,
                                text_field => [undef, placeholder => 'Search' ],
                            ],
                            submit_button => ['Submit'],
                        ]
                    ],
                },
                {
                    nav => [
                        right,
                        [
                            ['Link', ['#'] ],
                            {
                                button => ['Dropdown', ['#'], caret],
                                items => [
                                    ['Action', ['#'] ],
                                    ['Another action', ['#'] ],
                                    ['Someting else here', ['#'] ],
                                    [],
                                    ['Separated link', ['#'] ],
                                ],
                            }
                        ],
                    ]
                }
           ]

%>
--t--
--e--
--e--