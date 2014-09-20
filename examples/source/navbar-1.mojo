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

==test==
--t--
    <%= navbar inverse, header => ['The Brand', ['#'], hamburger, toggler => 'collapse-45821'],
               [
                    form => [
                        ['/login', method => 'post'],
                        left,
                        [
                            formgroup => [
                                undef,
                                text_field => ['search-term', placeholder => 'Search' ],
                            ],
                            submit_button => ['Submit'],
                        ]
                    ],
                    button => ['A link', ['#'], left ],
                    nav => [
                        [
                            ['Another linkage', ['#'] ]
                        ]
                    ],
                    p => ['Hello', right]
               ]
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


==no test==
--t--
<%= navbar header => ['The brand', ['#'], hamburger],
           [
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
           ]

%>
--t--
--e--
--e--