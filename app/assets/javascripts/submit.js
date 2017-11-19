$(function() {
  var eventSelect = $('.event-select');
  eventSelect.change(function(){
    $.get({
      url: "/submit/comment",
      data: { name: eventSelect.has('option:selected').val()}
    });
    console.log("selected");
    $('.content-select').html('<%= j(options_for_select(@books)) %>');
  });
});

