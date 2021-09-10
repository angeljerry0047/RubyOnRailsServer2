// When the document loads do everything inside here ...
     $(document).ready(function(){
        
       // When a link is clicked
       $("a.short").click(function () {
            
           // switch all tabs off
           $(".active").removeClass("active");
            
           // switch this tab on
           $(this).addClass("active");

          
       });
       $("a.select").click(function () {
            
           // switch all tabs off
           $(".active").removeClass("active");
            
           // switch this tab on
           $(this).addClass("active");

       
     });
        
     });
     
