/* Set the width of the side navigation to 250px */
function openNav() {
    document.getElementById("mySidenav").style.width = "650px";
}

/* Set the width of the side navigation to 0 */
function closeNav() {
    document.getElementById("mySidenav").style.width = "0";
}

ready = function() {
  $("#sideBarComOpen").click(function (event){
    openNav();
    event.preventDefault();
  });
}


$(document).on('turbolinks:load', ready);
