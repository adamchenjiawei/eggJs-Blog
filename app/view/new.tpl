<html>
<head>
  <title></title>
  <link rel="stylesheet" href="/public/bootstrap.min.css" type="text/css">
</head>
<body>
<h1> Blog New </h1>
<form action="/posts" method="post" id="article-form">
  <div class="form-group">
    <label>标题</label>
    <input type="text" class="form-control" placeholder="标题" name="title">
  </div>
  <div class="form-group">
    <label>正文内容</label>
    <textarea  class="form-control" rows="3" name="body">
    </textarea>
  </div>

  <input class="btn btn-default" type="submit" value="Submit">
</form>

<script src="/public/bootstrap.min.js"></script>
</body>
</html>