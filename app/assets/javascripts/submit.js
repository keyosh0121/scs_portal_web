$(function() {
  var eventSelect = $('.event-select');
  var contentSelect = $('.content-select');
  eventSelect.change(function(){
    $.data({
      url: "/submit/comment",
      data: { event_name: eventSelect.has('option:selected').val() }
    });
    console.log("selected");
    console.log(contentSelect.html);
  });
});

