==test==
--t--
    %= button 'The example 5' => large, warning
--t--
--e--
    <button class="btn btn-lg btn-warning">The example 5</button>
--e--

An ordinary button, with applied strappings.


==test==
--t--
    %= button 'The example 1' => ['http://www.example.com/'], small
--t--
--e--
    <a class="btn btn-default btn-sm" href="http://www.example.com/">The example 1</a>
--e--

With a url the button turns into a link.


==test==
--t--
    %= submit_button 'Save 2', primary
--t--
--e--
    <button class="btn btn-primary" type="submit">Save 2</button>
--e--

A submit button for use in forms. It overrides the build-in submit_button helper.





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
    <a class="btn btn-default" href="/button_1_5">The example 2</a>
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
    %= button [url_for], disabled, begin
       The Example 6
    %  end
--t--
--e--
    <a class="btn btn-default disabled" href="/button_1_9"> The Example 6 </a>
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
    %= submit_button 'Save 2', primary, disabled
--t--
--e--
    <button class="btn btn-primary" disabled="disabled" type="submit">Save 2</button>
--e--


==test loop(active block)==
--t--
    %= button 'Loop', [var]
--t--
--e--
    <button class="[var] btn btn-default">Loop</button>
--e--

