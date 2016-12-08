function read_less_jobs(job_id, type){

  $.ajax({
    async: true,
    url: "/job_read_less?job_id=" + job_id + "&type=" + type,
    cache: true,
    local_type: type,
    local_job_id: job_id,
    success: function(html) {
      document.getElementById('read-more-'.concat(type).concat('-job-').concat(job_id)).innerHTML = html;
    }
  });

}
