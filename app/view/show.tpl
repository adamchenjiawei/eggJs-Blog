<html>
<head>
  <title></title>
  <link rel="stylesheet" href="/public/bootstrap.min.css" type="text/css">
</head>
<body>
<h1> Blog Show </h1>
<a class="btn btn-success" href="/posts" role="button">首页</a>

<div class="form-group">
  <label>标题</label>
  <p>{{ data.title }}</p>
</div>
<div class="form-group">
  <label>正文内容</label>
  <textarea  class="form-control" rows="3" name="body">
    {{ data.body }}
    </textarea>
</div>

<script src="/public/bootstrap.min.js"></script>
</body>
</html>