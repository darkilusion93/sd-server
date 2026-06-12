//$(document).ready(function() {
//  
//    var counter = 0;
//    var c = 0;
//    var i = setInterval(function(){
//        $(".loading-page .counter h1").html(c + "%");
//        $(".loading-page .counter hr").css("width", c + "%");
//      counter++;
//      c++;
//        
//      if(counter == 101) {
//          clearInterval(i);
//      }
//    }, 2000);
//});

    window.onData = function(data) {
    	if (data.setDisplay == true) {
            $("body").css('background', 'linear-gradient(0deg, rgba(19,19,19,0.0) 0%, rgba(19,19,19,0.5) 37%, rgba(19,19,19,0.9) 100%');
            $("#container").css('display', 'flex');
    	} else {
            $('*').css('background', 'transparent');
            $("#container").css('display', 'none');
    	}
    	
    }


    window.onload = function(e) {
        window.addEventListener('message', function(event) {
            onData(event.data)
        });
    }
