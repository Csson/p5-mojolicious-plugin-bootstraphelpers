==test example==
--t--
    <%= input input => { text_field => ['username'] },
              prepend => { check_box => ['agreed'] }
    %>
--t--
--e--
    <div class="input-group">
        <span class="input-group-addon"><input name="agreed" type="checkbox" /></span>
        <input class="form-control" id="username" type="text" name="username" />
    </div>
--e--
An input group with a checkbox.

==test example==
--t--
    <%= input large,
              prepend => { radio_button => ['yes'] },
              input => { text_field => ['username'] },
              append => '@'
    %>
--t--
--e--
    <div class="input-group input-group-lg">
        <span class="input-group-addon"><input name="yes" type="radio" /></span>
        <input class="form-control" id="username" type="text" name="username" />
        <span class="input-group-addon">@</span>
    </div>
--e--
A <code>large</code> input group with a radio button prepended and a string appended.


==test example==
--t--
    <%= input input => { text_field => ['username'] },
              append => { button => ['Click me!'] },
    %>
--t--
--e--
    <div class="input-group">
        <input class="form-control" id="username" type="text" name="username" />
        <span class="input-group-btn"><button class="btn btn-default" type="button">Click me!</button></span>
    </div>
--e--
An input group with a button.



==test example==
    <%= buttongroup ['Default', caret, items  => [
                        ['Item 1', ['item1'] ],
                        ['Item 2', ['item2'] ],
                        [],
                        ['Item 3', ['item3'] ],
                    ] ]
    %>
--t--
    <%= input input  => { text_field => ['username'] },
              append => { buttongroup => [['The button', caret, right, items => [
                                  ['Item 1', ['item1'] ],
                                  ['Item 2', ['item2'] ],
                                  [],
                                  ['Item 3', ['item3'] ],
                              ] ] ]
                        }
    %>
--t--
--e--
    <div class="input-group">
        <input class="form-control" id="username" type="text" name="username" />
        <div class="input-group-btn">
            <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">The button <span class="caret"></span>
            </button>
            <ul class="dropdown-menu dropdown-menu-right">
                <li><a class="menuitem" href="item1" tabindex="-1">Item 1</a></li>
                <li><a class="menuitem" href="item2" tabindex="-1">Item 2</a></li>
                <li class="divider"></li>
                <li><a class="menuitem" href="item3" tabindex="-1">Item 3</a></li>
            </ul>
        </div>
    </div>
--e--
An input group with a button dropdown appended. Note that <code>right</code> is manually applied.


==test example==
--t--
    <%= input input   => { text_field => ['username'] },
              prepend => { buttongroup => [
                              buttons => [
                                ['Link 1', ['http://www.example.com/'] ],
                                [undef, caret, items => [
                                      ['Item 1', ['item1'] ],
                                      ['Item 2', ['item2'] ],
                                      [],
                                      ['Item 3', ['item3'] ],
                                  ],
                               ],
                            ],
                         ],
                      },
    %>
--t--
--e--
    <div class="input-group">
        <div class="input-group-btn">
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
        <input class="form-control" id="username" type="text" name="username" />
    </div>
--e--
An input group with a split button dropdown prepended.
