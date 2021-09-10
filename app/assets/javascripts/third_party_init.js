S2p.chosenParams = {
  allow_single_deselect: true,
  no_results_text: 'No results matched'
};

S2p.initializeChosen = function() {
  $('.chzn-select:not(:hidden)').chosen(S2p.chosenParams);
}

$(window).ready(S2p.initializeChosen);

