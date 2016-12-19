niceSelect = ->
  # enable chosen js
  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
    width: '418px'

$( document ).on('turbolinks:load', niceSelect)
