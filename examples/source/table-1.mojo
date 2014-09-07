==test==
--t--
    <%= table begin %>
        <tr><td>Table 1</td></tr>
    <% end %>
--t--
--e--
    <table class="table">
        <tr><td>Table 1</td></tr>
    </table>
--e--

==test==
--t--
    %= table hover, striped, condensed, begin
        <tr><td>Table 2</td></tr>
    %  end
--t--
--e--
    <table class="table table-condensed table-hover table-striped">
        <tr><td>Table 2</td></tr>
    </table>
--e--

==test==
--t--
    %= table 'Heading Table 3', hover, striped, condensed, begin
        <tr><td>Table 3</td></tr>
    %  end
--t--
--e--
    <div class="panel panel-default">
        <div class="panel-heading">
            <h3 class="panel-title">Heading Table 3</h3>
        </div>
        <table class="table table-condensed table-hover table-striped">
            <tr><td>Table 3</td></tr>
        </table>
    </div>
--e--

==test==
--t--
    %= table 'Heading Table 4', panel => { success }, condensed, id => 'the-table', begin
        <tr><td>Table 4</td></tr>
    %  end
--t--
--e--
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">Heading Table 4</h3>
        </div>
        <table class="table table-condensed" id="the-table">
            <tr><td>Table 4</td></tr>
        </table>
    </div>
--e--

==test==
--t--

--t--
--e--

--e--

==test==
--t--

--t--
--e--

--e--
