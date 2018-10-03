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
  $('.band-select-regular').change(function(){
    $('.band-select-temporal').val(0);
  });
  $('.band-select-temporal').change(function(){
    $('.band-select-regular').val(0);
  });

  var memberInput = $('.reg-member-input');
  memberInput.change(function(){
    inputName = $(this).val();
    if (gon.names.indexOf( inputName ) == -1) {
      $(this).css('border', 'solid 1px #822')
      $(this).prev().css('color', '#822')
      $(this).prev().text('登録が完了していない氏名です')
    } else {
      $(this).css('border', 'solid 1px #282')
      $(this).prev().css('color', '#282')
      $(this).prev().text('ポータル登録済み')
    }
  });
});

