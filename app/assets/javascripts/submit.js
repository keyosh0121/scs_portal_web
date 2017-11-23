$(document).on('turbolinks:load', function() {
  var eventSelect = $('.event-select');
  var contentSelect = $('.content-select');

  eventSelect.change(function(){
    contentSelect.html('')
    var result = $.ajax({
      url: "/submit/comment/conference/get_content",
      type: 'POST',
      data: { event_name: eventSelect.has('option:selected').val() }
    });

    result.done(function(data, stat, xhr) {
      var resultText = data
      console.log(resultText);
      contentSelect.append('<option disabled selected>選択して下さい</option>')
      for(let k in resultText) {
        contentSelect.append('<option value="' + resultText[k].name + '"> '+ resultText[k].name + '</option>')
      }
    });
  });
});

