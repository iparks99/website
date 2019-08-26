<html>
  <head>
    <title>Thank you for your request</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <!-- Add icon library -->
    <link rel="stylesheet" href=
      "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  </head>

  <div id="topnav">
      <button type="button" onclick="location.href='index.html';"
        class="topnavbutton"><i class="fa fa-home"></i> Home</button>
      <button type="button" onclick="location.href='works.html';"
        class="topnavbutton"><i class="fa fa-briefcase"></i> My Works</button>
      <button type="button" onclick="location.href='downloads.html';"
        class="topnavbutton"><i class="fa fa-download"></i> Downloads</button>
      <button type="button" onclick="location.href='contact.html';"
        class="topnavbutton"><i class="fa fa-paper-plane"></i> Contact Me</button>
  </div>

  <body>
    <h3>
      Thank you, <?php echo $_POST["name"]; ?>, for your request. I will send
      you an email as soon as I can.
    </h3>
  </body>
</html>
