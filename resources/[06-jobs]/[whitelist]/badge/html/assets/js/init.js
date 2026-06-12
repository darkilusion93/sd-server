$(document).ready(function(){
  // LUA listener
  window.addEventListener('message', function( event ) {
    if (event.data.action == 'open') {
      var type        = event.data.type;
      var userData    = event.data.array['user'][0];
      var licenseData = event.data.array['cargo'];
      var sex         = userData.sex;

      if ( type == 'driver' || type == null || type == 'police' || type == 'sheriff' || type == 'pj' || type == 'navy' || type == 'ambulance' || type == 'ranger' || type == 'municipal' || type == 'bomb' ) {
        $('#name').css('color', '#282828');


		$('#name').text(licenseData);
		$('#name2').text(userData.firstname);
		$('#name3').text(userData.lastname);

      if ( userData.job == 'police' ) {
			$('#id-card').css('background', 'url(assets/images/lspd.png)');
		} else if ( userData.job  == 'sheriff' ) {
			$('#id-card').css('background', 'url(assets/images/sheriff.png)');
		} else if ( userData.job  == 'ranger' ) {
			$('#id-card').css('background', 'url(assets/images/maritima.png)');
		} else if ( userData.job  == 'ambulance' ) {
			$('#id-card').css('background', 'url(assets/images/ranger.png)');
		} else if ( userData.job  == 'municipal' ) {
			$('#id-card').css('background', 'url(assets/images/pm.png)');
		} else if ( userData.job == 'pj' ) {
			$('#id-card').css('background', 'url(assets/images/PJ.png)');
		} else if ( userData.job  == 'navy' ) {
			$('#id-card').css('background', 'url(assets/images/navy.png)');
		} else {
			$('#id-card').css('background', 'url(assets/images/state.png)');
        }
      }
      $('#id-card').show();
    } else if (event.data.action == 'close') {
      $('#name').text('');
	  $('#name2').text('');
	  $('#name3').text('');
      $('#dob').text('');
      $('#height').text('');
      $('#signature').text('');
      $('#sex').text('');
      $('#id-card').hide();
      $('#licenses').html('');
    }
  });
});
