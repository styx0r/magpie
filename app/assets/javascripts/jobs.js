$(document).on('turbolinks:load', function() {
    $(".job_collapse_switch").click(function(e) {
        e.preventDefault();
        //console.log(e.target);
        if ($("#job_collapse_switch_text_"+e.target.id.split("_").last()).html() == "open") {
          $("#job_collapse_switch_text_"+e.target.id.split("_").last()).html("close");
          $("#job_collapse_switch_icon_"+e.target.id.split("_").last()).attr("class", "fa fa-minus-square");
          $("#job_collapse_switch_icon_"+e.target.id.split("_").last()).attr("style", "color:orange;text-align:right;");
        } else {
          $("#job_collapse_switch_text_"+e.target.id.split("_").last()).html("open");
          $("#job_collapse_switch_icon_"+e.target.id.split("_").last()).attr("class", "fa fa-plus-square");
          $("#job_collapse_switch_icon_"+e.target.id.split("_").last()).attr("style", "color:green;text-align:right;");
        }
        //console.log($("#job_collapse_switch_icon_"+e.target.id.split("_").last()).attr("class"));
        //console.log($("#job_collapse_switch_text_"+e.target.id.split("_").last()).html());
        //$("#job_collapse_switch_text_"+e.target.id.split("_").last()).html()
        //console.log(document.getElementById("#job_collapse_switch_text_"+e.target.id.split("_").last()));
        /*if (((e.target.children)[1]).innerHTML == "open") {
          ((e.target.children)[1]).innerHTML = "close"
        }*/
    });
});
