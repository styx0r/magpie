var ready;
var original_value;
var suggestion;
ready = function() {

  var hashtags = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    limit: 3,
    minLength: 3,
    remote: {
      url: '/autocomplete/hashtags?query=%QUERY',
      wildcard: '%QUERY',
      replace: function (url, query) {
                    var lastIndex = query.lastIndexOf(" ");
                    if (lastIndex > -1) {
                      lastword = query.slice(lastIndex).trim();
                    }
                    else {
                      lastword = query.trim();
                    }
                    if (lastword.startsWith('#')) {
                      lastword = lastword.replace('#','');
                      customurl = '/autocomplete/hashtags?query=' + lastword;
                    }
                    else {
                      customurl = '/autocomplete/hashtags?query=';
                    }
                    console.log('Querying URL: ' + customurl);
                    return customurl;}
    }
  });

  var users = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    limit: 3,
    minLength: 3,
    remote: {
      url: '/autocomplete/users?query=%QUERY',
      wildcard: '%QUERY',
      replace: function (url, query) {
                    var lastIndex = query.lastIndexOf(" ");
                    if (lastIndex > -1) {
                      lastword = query.slice(lastIndex).trim();
                    }
                    else {
                      lastword = query.trim();
                    }
                    if (lastword.startsWith('@')) {
                      lastword = lastword.replace('@','');
                      customurl = '/autocomplete/users?query=' + lastword;
                    }

                    else {
                        customurl = '/autocomplete/users?query=';
                    }
                    console.log('Querying URL: ' + customurl);
                    return customurl;}
    }
  });

    users.initialize();
    hashtags.initialize();

    $('.typeahead-hashtags').typeahead(null,
      [
      {
      hint: true,
      highlight: true,
      name: 'hashtags',
      displayKey: 'tag',
      source: hashtags.ttAdapter(),
      templates: {
        empty: [],
        suggestion: function (term) {
          return '<p>' + term.tag + '</p>';
          }

          }
    },
    {
      hint: true,
      highlight: true,
      name: 'users',
      displayKey: 'identity',
      source: users.ttAdapter(),
      templates: {
        empty: [],
        suggestion: function (term) {
          return '<p>' + term.identity + '(' + term.name + ')</p>';
          }
       }
    }
  ]).on('typeahead:render', function (event, suggestion) {
          var inField = event.target.value;
          var lastIndex = inField.lastIndexOf(" ");
          original_value = inField.substring(0, lastIndex) + " ";
      }).on('typeahead:select', function (event, sugg) {
          suggestion = sugg;
          console.log('Selected suggestion:' + sugg)
      }).on('typeahead:close', function (event) {
          if (typeof suggestion != 'undefined') {
          var newValue = original_value + suggestion.tag;
          this.value = newValue;
          original_value = newValue;
          }
      }).on('typeahead:change', function () {
          this.value = original_value;
      }).on('typeahead:cursorchange', function (event, suggestion) {
          if (typeof suggestion != 'undefined') {
            this.value = original_value + suggestion.tag;
          }
      });
  }


$(document).ready(ready);
$(document).on('page:load', ready);
