var ready;

var preSuggestion;
var lastSuggestion;
var inField;
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

    $('.typeahead').typeahead(null,
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
          return '<p>' + term.tag + '(' + term.name + ')</p>';
          }
       }
    }
  ]).on('typeahead:render', function (event, suggestion) {
          // Always remember the current value before the last word
          // The last word needs to be replaced with the suggestion
          inField = event.target.value;
          var lastIndex = inField.lastIndexOf(" ");
          if (lastIndex > 0) {
          preSuggestion = inField.substring(0, lastIndex) + " ";
          }
          else {
            preSuggestion = inField.substring(0, lastIndex)
          }
      }).on('typeahead:select', function (event, suggestion) {
          // We remember the last chosen suggestion
          lastSuggestion = suggestion;
      }).on('typeahead:close', function (event) {
          // If the selection box is closed, start autocompletion
          if (typeof lastSuggestion != 'undefined') {
          console.log('Inserting completed text: ' + preSuggestion + lastSuggestion.tag )
          var postSuggestion = preSuggestion + lastSuggestion.tag + ' ';
          this.value = postSuggestion;
          preSuggestion = postSuggestion;
          }
          lastSuggestion = undefined;
          inField = this.value;
      }).on('typeahead:change', function () {
        // When the field loses focus, restore its original value
        this.value = inField;
      }).on('typeahead:cursorchange', function (event, suggestion) {
          // When the user is selecting a suggestion with the mouse or cursor ...
          // Set the autocompleted text in the field
          if (typeof suggestion != 'undefined') {
            this.value = preSuggestion + suggestion.tag;
          }
      });
  }


$(document).on('turbolinks:load', ready);
