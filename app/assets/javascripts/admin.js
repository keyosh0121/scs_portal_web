$(function(){
  var modal = $('.modal');
  $('.modal-close').click(function(){
    modal.fadeOut();
  });
  $('.open-modal').on('click', function(event) {
    var user_id = $(this).data('id');
    var user_name = $(this).data('name');
    $('.modal-title').text(user_name + "さんの権限を変更");
    $('.modal form').attr("action","/database/users/authority_edit/" + user_id);
    modal.fadeIn();
  });
});
