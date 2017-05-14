<html>
<head>
  <title></title>
  <link rel="stylesheet" href="/public/bootstrap.min.css" type="text/css">
</head>
<body>
<h1> Blog Index </h1>

<a class="btn btn-success" href="/posts/new" role="button">新增Blog</a>
<table class="table table-bordered">
  <tr>
    <td>title</td>
    <td>body</td>
    <td>操作</td>
  </tr>
  {% for post in data %}
  <tr class="info">
    <td>{{ post.title }}</td>
    <td>{{ post.body }}</td>
    <td>
      <a class="btn btn-info" href="/posts/{{ post.id }}" role="button">详情</a>
      <a class="btn btn-danger" onclick="deletePost(this)" data-id="{{ post.id }}" role="button">删除</a>
    </td>
  </tr>
  {% endfor %}
</table>
<script src="https://cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
<script src="/public/bootstrap.min.js"></script>
<script>
  function deletePost(self){
    let id = $(self).attr('data-id');
    if (confirm("确定要删除？")) {
      $.ajax({
        contentType: "text;charset=utf-8",
        type: "DELETE",
        url: `/posts/${id}`,
        dataType: "text",
        async: true,
        success: function (res) {
          location.reload();
        }
      });
    }
  }

</script>
</body>
</html>