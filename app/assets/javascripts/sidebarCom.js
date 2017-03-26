/* Set the width of the side navigation to 250px */
function openNav() {
    document.getElementById("micropostBarID").style.width = "650px";
    document.getElementById("main").style.marginLeft = "650px";
    //localStorage.setItem("micropostsOpen", true); //if nav should stay open when clicking on other link
}

/* Set the width of the side navigation to 0 */
function closeNav() {
    document.getElementById("micropostBarID").style.width = "0";
    document.getElementById("main").style.marginLeft = "0";
    //localStorage.setItem("micropostsOpen", false); //if nav should stay open when clicking on other link
}

ready = function() {
  $("#sideBarComOpen").click(function (event){
    event.preventDefault();
    if($("#sideBarComOpen")[0].getAttribute("open") != "true"){
      openNav();
      $("#sideBarComOpen")[0].setAttribute("open", "true");
    } else {
      closeNav();
      $("#sideBarComOpen")[0].setAttribute("open", "false");
    }
  });
  //if nav should stay open when clicking on other link
  //if(localStorage.getItem("micropostsOpen") == "true"){
  //  openNav();
  //}

}


$(document).on('turbolinks:load', ready);
