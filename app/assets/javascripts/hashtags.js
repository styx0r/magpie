

var ready;
var original_value;
var suggestion;
ready = function() {

  var hashtags = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('tag'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    limit: 10,
    remote: {
      url: '/autocomplete/hashtags?query=%QUERY',
      wildcard: '%QUERY'
    }
  });

    // kicks off the loading/processing of `local` and `prefetch`
    hashtags.initialize();

    // passing in `null` for the `options` arguments will result in the default
    // options being used
    $('.typeahead-hashtags').typeahead(null, {
      hint: true,
      highlight: true,
      name: 'hashtags',
      displayKey: 'tag',
      source: hashtags.ttAdapter(),
    }).on('typeahead:render', function (event, suggestion) {
          var inField = event.target.value;
          var lastIndex = inField.lastIndexOf(" ");
          original_value = inField.substring(0, lastIndex) + " ";
          console.log('Render triggered');
      }).on('typeahead:select', function (event, sugg) {
          suggestion = sugg;
          console.log('Select triggered');
      }).on('typeahead:close', function (event) {
          console.log('Close triggered');
          var newValue = original_value + suggestion.tag;
          event.target.value = newValue;
          original_value = newValue;
      }).on('typeahead:change', function () {
          console.log('Change triggered');
          this.value = original_value
          console.log(original_value)
      });
  }


$(document).ready(ready);
$(document).on('page:load', ready);
