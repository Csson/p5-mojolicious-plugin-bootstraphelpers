==test==
--t--
    %= formgroup 'Text test 1', text_field => ['test-text']
--t--
--e--
    <div class="form-group">
        <label class="control-label" for="test-text">Text test 1</label>
        <input class="form-control" id="test-text" name="test_text" type="text" />
    </div>
--e--

==test==
--t--
    %= formgroup 'Text test 2', text_field => ['test_text', size => 30]
--t--
--e--
    <div class="form-group">
        <label class="control-label" for="test_text">Text test 2</label>
        <input class="form-control" id="test_text" name="test_text" size="30" type="text" />
    </div>
--e--

==test==
--t--
    %= formgroup 'Text test 3', text_field => ['test_text', prepend => '@']
--t--
--e--
    <div class="form-group">
        <label class="control-label" for="test_text">Text test 3</label>
        <div class="input-group">
            <span class="input-group-addon">@</span>
            <input class="form-control" id="test_text" name="test_text" type="text" />
        </div>
    </div>
--e--

==test==
--t--
    %= formgroup 'Text test 4', text_field => ['test_text', large]
--t--
--e--
    <div class="form-group">
        <label class="control-label" for="test_text">Text test 4</label>
        <input class="form-control input-lg" id="test_text" name="test_text" type="text" />
    </div>
--e--

==test==
--t--
    %= formgroup 'Text test 5', text_field => ['test_text', '200' ]
--t--
--e--
    <div class="form-group">
        <label class="control-label" for="test_text">Text test 5</label>
        <input class="form-control" id="test_text" name="test_text" type="text" value="200" />
    </div>
--e--

==test==
--t--
    %= formgroup 'Text test 6', large, text_field => ['test_text']
--t--
--e--
    <div class="form-group form-group-lg">
        <label class="control-label" for="test_text">Text test 6</label>
        <input class="form-control" id="test_text" name="test_text" type="text" />
    </div>
--e--

==test==
--t--
    %= formgroup text_field => ['test_text', xsmall] => begin
        Text test 7
    %  end
--t--
--e--
    <div class="form-group">
        <label class="control-label" for="test_text"> Text test 7 </label>
        <input class="form-control input-xs" id="test_text" name="test_text" type="text" />
    </div>
--e--

==test==
--t--
    %= formgroup 'Text test 8', text_field => ['test_text'], cols => { medium => [2, 10], small => [4, 8] }
--t--
--e--
    <div class="form-group">
        <label class="control-label col-md-2 col-sm-4" for="test_text">Text test 8</label>
        <div class="col-md-10 col-sm-8">
            <input class="form-control" id="test_text" name="test_text" type="text" />
        </div>
    </div>
--e--

==test==
--t--
    %= formgroup text_field => ['test-text-9']
--t--
--e--
    <div class="form-group">
        <input class="form-control" id="test-text-9" name="test_text_9" type="text" />
    </div>
--e--

==test==
--t--
    
--t--
--e--
--e--

