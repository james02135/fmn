<%namespace name="functions" file="functions.mak" inheritable="True" />
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="management of fedmsg end user notifications">
    <meta name="author" content="Ralph Bean">

    <link rel="shortcut icon" href="/static/ico/favicon.png">

    <title>fedmsg notifications</title>

    <link href="/static/bootstrap/css/bootstrap.css" rel="stylesheet">
    <link href="/static/css/navbar.css" rel="stylesheet">
    <link href="/static/css/footer.css" rel="stylesheet">
    <link href="/static/css/avatars.css" rel="stylesheet">
  </head>

  <body>

    <div id="wrap" class="container">

      <!-- Static navbar -->
      <div class="navbar navbar-default">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="${url_for('index')}">Fedora Notifications</a>
        </div>

        <div class="navbar-collapse collapse">
          <ul class="nav navbar-nav">

            % if fas_user:
              % if 'profile' == current:
              <li class="active">
              % else:
              <li>
              % endif
              <a href="${url_for('profile', username=fas_user.username)}">profile</a>
              </li>

              % for ctx in contexts:
                % if ctx.name == current:
                <li class="active">
                % else:
                <li>
                % endif
                <a href="${url_for('context', username=username, context=ctx.name)}">${ctx.name}</a>
                </li>
              % endfor
            % endif

          </ul>
          <ul class="nav navbar-nav navbar-right">
            % if fas_user:
            <li><a href="${url_for('logout')}">Logout</a></li>
            % else:
            <li><a href="${url_for('login')}">Login</a></li>
            % endif
          </ul>

        </div><!--/.nav-collapse -->
      </div>

      ${self.body()}

    </div> <!-- /container -->

    <div id="footer">
      <div class="container">
        <p class="text-muted credit">
        Fedora Notifications is powered by
        <a href="http://fedmsg.com">fedmsg</a>.  The
        <a href="https://github.com/fedora-infra/fedmsg-notifications">source</a>
        and
        <a href="https://github.com/fedora-infra/fedmsg-notifications/issues">issue tracker</a>
        are available on github.
        ©2013 Red Hat, Inc., <a href="http://threebean.org">Ralph Bean</a>.
        </p>
      </div>
    </div>

    <!-- Placed at the end of the document so the pages load faster -->
    <script src="/static/js/jquery-1.10.2.min.js"></script>
    <script src="/static/bootstrap/js/bootstrap.min.js"></script>
  </body>
</html>