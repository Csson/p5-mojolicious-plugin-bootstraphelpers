==test example==
--t--
    <%= toolbar id => 'my-toolbar'
                groups => [
                    { buttons => [
                        ['Button 1'],
                        ['Button 2'],
                        ['Button 3'],
                      ],
                    },
                    { buttons => [
                        ['Button 4', primary],
                        ['Button 5'],
                        ['Button 6'],
                      ],
                    },
                ]
    %>
--t--
--e--
    <div class="btn-toolbar" id="my-toolbar">
        <div class="btn-group">
            <button class="btn btn-default" type="button">Button 1</button>
            <button class="btn btn-default" type="button">Button 2</button>
            <button class="btn btn-default" type="button">Button 3</button>
        </div>
        <div class="btn-group">
            <button class="btn btn-primary" type="button">Button 1</button>
            <button class="btn btn-default" type="button">Button 2</button>
            <button class="btn btn-default" type="button">Button 3</button>
        </div>
    </div>
--e--