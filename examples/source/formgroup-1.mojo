==test example==
--t--
    %= formgroup 'Text test 1', text_field => ['test_text']
--t--
--e--
    <div class="form-group">
        <label class="control-label" for="test_text">Text test 1</label>
        <input class="form-control" id="test_text" name="test_text" type="text" />
    </div>
--e--
The first item in the array ref is used for both <code>id</code> and <code>name</code>. Except...


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


==test example==
--t--
    %= formgroup 'Text test 4', text_field => ['test-text', large]
--t--
--e--
    <div class="form-group">
        <label class="control-label" for="test-text">Text test 4</label>
        <input class="form-control input-lg" id="test-text" name="test_text" type="text" />
    </div>
--e--
...if the input name (the first item in the text_field array ref) contains dashes -- those are replaced (in the <code>name</code>) to underscores.





==test example==
--t--
    %= formgroup 'Text test 5', text_field => ['test_text', '200' ]
--t--
--e--
    <div class="form-group">
        <label class="control-label" for="test_text">Text test 5</label>
        <input class="form-control" id="test_text" name="test_text" type="text" value="200" />
    </div>
--e--
An input with a value.

==test example==
--t--
    <form class="form-horizontal">
        %= formgroup 'Text test 6', text_field => ['test_text'], large, cols => { small => [2, 10] }
    </form>
--t--
--e--
    <form class="form-horizontal">
        <div class="form-group form-group-lg">
            <label class="control-label col-sm-2" for="test_text">Text test 6</label>
            <div class="col-sm-10">
                <input class="form-control" id="test_text" name="test_text" type="text">
            </div>
        </div>
    </form>
--e--
Note the difference with the earlier example. Here <code>large</code> is outside the <code>text_field</code> array reference, and therefore <code>.form-group-lg</code> is applied to the form group. 



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



==test example==
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
A formgroup used in a <code>.form-horizontal</code> <code>form</code>.

(Note that in this context, <code>medium</code> and <code>large</code> are not short form strappings. Those don't take arguments.)


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

