function read_more_jobs(job_id, type, text){
  var divEl = document.getElementById('read-more-'.concat(type).concat('-job-').concat(job_id));
  out = text;
  //out = out.concat('<a href="javascript:void(0);" onclick="read_less_jobs('.concat(job_id).concat(',').concat(type).concat(',') <%= (simple_format job.output[:stdout].join()).to_json %>);">... read more</a>')
  divEl.innerHTML = out;
}
