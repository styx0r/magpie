/* Set the width of the side navigation to 250px */
function openNav() {
    document.getElementById("micropostBarID").style.width = "650px";
    document.getElementById("main").style.marginLeft = "650px";
    localStorage.setItem("micropostsOpen", true);
}

/* Set the width of the side navigation to 0 */
function closeNav() {
    document.getElementById("micropostBarID").style.width = "0";
    document.getElementById("main").style.marginLeft = "0";
    localStorage.setItem("micropostsOpen", false);
}

ready = function() {
  $("#sideBarComOpen").click(function (event){
    openNav();
    event.preventDefault();
  });
  console.log(localStorage.getItem("micropostsOpen"));
  if(localStorage.getItem("micropostsOpen") == "true"){
    console.log("test")
    openNav();
  }

}


$(document).on('turbolinks:load', ready);
