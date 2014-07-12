var Team30 = {
  init : function(){
    // Populates the search results form with the selected description
    // and calories from the option element text.
    $('#searchResultsSelect').change(function(){
      var str = $('#searchResultsSelect option:selected').text();
      var description = str.replace(/: \(\d+\.*\d* cals\)$/, '');
      var calories = str.match(/\((\d+\.*\d*) cals\)$/);
      calories = calories ? calories[1] : 0;
      $('#selectedDescription').val(description);
      $('#selectedCalories').val(calories);
    });
  }
};

$(document).ready(function(){
  Team30.init();
});
