$("#signup_btn").click(function(){
});

$("#login_btn").click(function(){
  var json = {};
  json.email = $("#login_email").val();
  json.password = $("#login_password").val();
  console.log(json);
  $.post("/login",json,function(data){
    var json = jQuery.parseJSON(data);
    if(json["message"] === "yes"){
      //move to another page
      window.location.href = "/repo";
    }else{
      $(".login_form_div").addClass("has-error");
    }
  });
});

$("#switch_signup_btn").click(function(){
  $(".login_form_div").hide();
  $(".signup_form_div").show();
});

$("#switch_login_btn").click(function(){
  $(".login_form_div").show();
  $(".signup_form_div").hide();
});

$(".signup_form_div").hide();

$("#login_password").keyup(function(event){
    if(event.keyCode == 13){
        $("#login_btn").click();
    }
});
