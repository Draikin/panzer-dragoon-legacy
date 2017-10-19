$(document).on('ready turbolinks:load', function() {
  $(".emoticon").click(function(event) {
    var emoticon_code = $(this).attr('id');
    $('.data_entry').insertTextInTextArea(emoticon_code, "", "", null);
    event.preventDefault();
  });
});
