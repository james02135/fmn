<%inherit file="master.mak"/>
<div class="jumbotron">
  <h1>Filters for ${username}'s' <em>${chain.name}</em> chain</h1>
  <p>for the ${current.name} messaging context</p>
</div>
<div class="row">
  <form class="form-inline" role="form" action="/api/filter/new" method="post">
    <div class="form-group">
      <input type="text" class="form-control" name="filter_name" id="filter_name" placeholder="Filter Name">
    </div>
    <input name="username" id="username" value="${username}" type="hidden">
    <input name="context" id="context" value="${current.name}" type="hidden">
    <input name="chain_name" id="chain_name" value="${chain.name}" type="hidden">
    <button type="submit" class="btn btn-success">&#43; Add Filter</button>
  </form>
</div>
% if chain.filters:
<div class="row">
  <div class="md-col-6">
    <p>Current filters</p>
    <ul>
      % for flt in chain.filters:
      <li>${flt.name}</li>
      %endfor
    </ul>
  </div>
</div>
% endif