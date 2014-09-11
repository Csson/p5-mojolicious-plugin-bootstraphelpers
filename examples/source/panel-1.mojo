==test==
--t--
    %= panel
--t--
--e--
    <div class="panel panel-default">
        <div class="panel-body">
        </div>
    </div>
--e--
The class is set to <code>.panel-default</code>, by default.


==test==
--t--
    %= panel undef ,=> begin
        <p>A short text.</p>
    %  end
--t--
--e--
    <div class="panel panel-default">
        <div class="panel-body">
            <p>A short text.</p>
        </div>
    </div>
--e--
If you want a panel without title, set the title to <code>undef</code>.


==test==
--t--
    %= panel 'The Header' => begin
        <p>A short text.</p>
    %  end
--t--
--e--
    <div class="panel panel-default">
        <div class="panel-heading">
            <h3 class="panel-title">The Header</h3>
        </div>
        <div class="panel-body">
            <p>A short text.</p>
        </div>
    </div>
--e--


==test==
--t--
    %= panel 'Panel 5', success, begin
        <p>A short text.</p>
    %  end
--t--
--e--
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">Panel 5</h3>
        </div>
        <div class="panel-body">
            <p>A short text.</p>
        </div>
    </div>
--e--






==test==
--t--
    %= panel
--t--
--e--
    <div class="panel panel-default">
        <div class="panel-body">
        </div>
    </div>
--e--

==test==
--t--
    %= panel undef ,=> begin
        <p>In the panel.</p>
    %  end
--t--
--e--
    <div class="panel panel-default">
        <div class="panel-body">
            <p>In the panel.</p>
        </div>
    </div>
--e--

==test==
--t--
    %= panel 'Test'
--t--
--e--
    <div class="panel panel-default">
        <div class="panel-heading">
            <h3 class="panel-title">Test</h3>
        </div>
        <div class="panel-body">
        </div>
    </div>
--e--

==test==
--t--
%= panel 'The Header' => begin
    <p>A short text.</p>
%  end
--t--
--e--
    <div class="panel panel-default">
        <div class="panel-heading">
            <h3 class="panel-title">The Header</h3>
        </div>
        <div class="panel-body">
            <p>A short text.</p>
        </div>
    </div>
--e--

==test==
--t--
    %= panel 'Panel 5', success, begin
        <p>A short text.</p>
    %  end
--t--
--e--
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">Panel 5</h3>
        </div>
        <div class="panel-body">
            <p>A short text.</p>
        </div>
    </div>
--e--