

var ready;
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
      // `ttAdapter` wraps the suggestion engine in an adapter that
      // is compatible with the typeahead jQuery plugin
      source: hashtags.ttAdapter()
    });

  }

$(document).ready(ready);
$(document).on('page:load', ready);
