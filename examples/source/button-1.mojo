
==test==
--t--
    %= button 'The example 1' => ['http://www.example.com/'], small
--t--
--e--
    <a class="btn btn-default btn-sm" href="http://www.example.com/">The example 1</a>
--e--

==test==
--t--
    %= button 'The example 2' => [url_for]    
--t--
--e--
    <a class="btn btn-default" href="/button_1_2">The example 2</a>
--e--

==test==
--t--
    %= button 'The example 3' => ['panel_1']
--t--
--e--
    <a class="btn btn-default" href="panel_1">The example 3</a>    
--e--


==test==
--t--
    %= button 'The example 4'
--t--
--e--
    <button class="btn btn-default">The example 4</button>
--e--


==test==
--t--
    %= button 'The example 5' => large, warning
--t--
--e--
    <button class="btn btn-lg btn-warning">The example 5</button>
--e--


==test==
--t--
    %= button [url_for] => begin
       The Example 6
    %  end
--t--
--e--
    <a class="btn btn-default" href="/button_1_6"> The Example 6 </a>
--e--


==test==
--t--
    %= submit_button 'Save 1'
--t--
--e--
    <button class="btn btn-default" type="submit">Save 1</button>
--e--


==test==
--t--
    %= submit_button 'Save 2', primary
--t--
--e--
    <button class="btn btn-primary" type="submit">Save 2</button>
--e--


==test==
--t--
    
--t--
--e--
--e--
