==test==
--t--
    <%= navbar header => ['The brand', ['#'], hamburger, toggler => 'bs-example-navbar-collapse-1'] %>
--t--
--e--
    <nav class="navbar navbar-default">
        <div class="container-fluid">
            <div class="navbar-header">
                <button class="collapse navbar-toggle" data-target="#bs-example-navbar-collapse-1" data-toggle="collapse" type="button">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">The brand</a>
            </div>
        </div>
    </nav>
--e--


==no test==
--t--
<%= navbar header => ['The brand', hamburger],
           [
                {
                    nav => {
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
                            ],
                        },
                    },
                },
                {
                    form => {
                        left,
                        [
                            formgroup => [
                                undef,
                                text_field => [undef, placeholder => 'Search' ],
                            ],
                            submit_button => ['Submit'],
                        ]
                    },
                },
                {
                    nav => {
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
                    }
                }
           ]

%>
--t--
--e--
--e--