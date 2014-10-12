
var email_okay = false;
var password_okay = false;
var username_okay = false;

function signup_btn(){
  if(email_okay == true && password_okay == true&& username_okay == true){
    $('#signup_btn').prop('disabled', false);
  }
}

$("#sign_up_form .modal-body input[name='email']").focusout(function(){
  var json = {};
  json.email = $("#sign_up_form .modal-body input[name='email']").val();
  $.get("/email_available",json,function(data){
    if(data["message"] === "yes"){
      $("#email_error_message").hide();
      email_okay = true;
      signup_btn();
    }else{
      $("#email_error_message").show();
      $('#signup_btn').prop('disabled', true);
      email_okay = false;
    }
  });
});
$("#sign_up_form .modal-body input[name='username']").focusout(function(){
  var json = {}
  json.user_name = $("#sign_up_form .modal-body input[name='username']").val();
  $.get("/user_name_available",json,function(data){
    if(data["message"] === "yes"){
      $("#username_error_message").hide();
      username_okay = true;
      signup_btn();
    }else{
      $("#username_error_message").show();
      $('#signup_btn').prop('disabled', true);
      username_okay = false;
    }
  });
});

function check_passwords(){
  if($("#sign_up_form .modal-body input[name='password']").val() === $("#sign_up_form .modal-body input[name='password_confirm']").val()){
    $("#password_error_message").hide();
    password_okay = true;
    signup_btn();
  }else{
    $("#password_error_message").show();
    $('#signup_btn').prop('disabled', true);
    password_okay = false;
  }
}

$("#sign_up_form .modal-body input[name='password']").focusout(function(){
  check_passwords();
});
$("#sign_up_form .modal-body input[name='password_confirm']").focusout(function(){
  check_passwords();
});



$("#signup_btn").click(function(){
  var json = {};
  var okay = true;
  json.email = $("#sign_up_form .modal-body input[name='email']").val();
  json.username = $("#sign_up_form .modal-body input[name='username']").val();
  json.password = $("#sign_up_form .modal-body input[name='password']").val();
  json.password_confirm = $("#sign_up_form .modal-body input[name='password_confirm']").val();
  if(json.email === "Email" || json.email === ""){
    $("#email_error_message").show();
    okay = false;
  }
  if(json.username === "Username" || json.email === ""){
    $("#username_error_message").show();
    okay = false;
  }
  if(json.password === ""){
    $("#password_error_message").show();
    okay = false;
  }
  if(okay){
    $.post("/signup",json,function(data){
      var json = jQuery.parseJSON(data);
      if(json["message"] === "yes"){
        window.location.href = "/home";
      }else{
        $(".signup_form_div").addClass("has-error");
      }
    });
  }
});

$("#login_btn").click(function(){
  var json = {};
  json.email = $("#login_email").val();
  json.password = $("#login_password").val();
  $.post("/login",json,function(data){
    var json = jQuery.parseJSON(data);
    if(json["message"] === "yes"){
      window.location.href = "/home";
    }else{
      $(".login_form_div").addClass("has-error");
    }
  });
});

$("#switch_signup_btn").click(function(){
  $(".login_form_div").hide();
  $(".signup_form_div").show();
  $("#email_error_message").hide();
  $("#username_error_message").hide();
  $("#password_error_message").hide();
});

$("#switch_login_btn").click(function(){
  $(".login_form_div").show();
  $(".signup_form_div").hide();
  $("#email_error_message").hide();
  $("#username_error_message").hide();
  $("#password_error_message").hide();
});

$(".signup_form_div").hide();

$("#login_password").keyup(function(event){
    if(event.keyCode == 13){
        $("#login_btn").click();
    }
});

$("#email_error_message").hide();
$("#username_error_message").hide();
$("#password_error_message").hide();

$("#sign_up_form input").keyup(function(event){
    if(event.keyCode == 13){
        $("#signup_btn").click();
    }
});



$("#repo_btn").click(function(){
  var json = {};
  json.title = $("#repo_title").val();
  json.location = $("#repo_location").val();
  json.github = $("#repo_github").val();
  json.demo = $("#repo_demo").val();
  json.blurb = $("#repo_blurb").val();
  $.post("/repo",json,function(resp){
    if(resp["message"] !== "no"){
      var url = "/repo/"+resp["message"]+"";
      window.location.href = url;
    }else{
      console.log("BAD FORM");
    }
  });
});

$("#follow_btn").click(function(){
  $.post("/follow/"+$(this).attr("repo_id"),function(data){
    if(data["message"] === "yes"){
      location.reload();
    }else{
      console.log("Strange Error");
    }
  });
});

$("#unfollow_btn").click(function(){
  $.post("/unfollow/"+$(this).attr("repo_id"),function(data){
    if(data["message"] === "yes"){
      location.reload();
    }else{
      console.log("Strange Error");
    }
  });
});

$("#edit_repo_btn").click(function(){
  var json = {};
  json.title = $(".edit_form input[name='title']").val();
  json.demo_url = $(".edit_form input[name='demo_url']").val();
  json.repo_url = $(".edit_form input[name='repo_url']").val();
  json.date_location = $(".edit_form input[name='date_location']").val();
  json.blurb = $(".edit_form textarea").val();
  json.tags = $(".edit_form input[name='tags']").val();
  $.post("/repo/"+$("#edit_repo_modal_btn").attr("repo_id")+"/edit",json,function(resp){
    location.reload();
  });
});

$("#delete_repo_btn").click(function(){
  $.post("/repo/"+$(this).attr("repo_id")+"/delete",function(data){
    if(data["message"] === "yes"){
      window.location.href = "/home";
    }else{
      console.log("Strange Error");
    }
  });
});

$(".edit_form input").keyup(function(event){
    if(event.keyCode == 13){
        $("#edit_repo_btn").click();
    }
});

$("#collapse_comment_btn").click(function(){
  $("#comment_feed").hide();
  $("#uncollapse_comment_btn").show();
  $("#collapse_comment_btn").hide();
});

$("#uncollapse_comment_btn").hide();
$("#uncollapse_comment_btn").click(function(){
  $("#comment_feed").show();
  $("#uncollapse_comment_btn").hide();
  $("#collapse_comment_btn").show();
});

$("#comment_btn").click(function(){
  var json = {};
  json.message = $("#meow_textarea").val();
  json.repo = $(this).attr("repo_id");
  $.post("/comment/new",json,function(resp){
    if(resp["message"] !== "no"){
      location.reload();
    }else{
      console.log("Strange Error");
    }
  });
});

$("#meow_textarea").keyup(function(event){
    if(event.keyCode == 13){
        $("#comment_btn").click();
    }
});
